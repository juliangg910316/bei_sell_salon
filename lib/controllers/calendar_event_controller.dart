import 'dart:collection';

import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/models/turn.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarEventController extends GetxController {
  bool isCreatedBox = false;
  late List<Turn> turnos;
  late DateTime focusedDay;
  late DateTime kFirstDay;
  late DateTime kLastDay;
  late LinkedHashMap<DateTime, List<Turn>> kEvents;
  late Map<DateTime, List<Turn>> kEventSource;
  List<DateTime> kHoliday = [];
  Map<int, int> horaTurno = {0: 8, 1: 10, 2: 13, 3: 15, 4: 17, 5: 19};

  late final ValueNotifier<List<Turn>> selectedEvents;
  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date

  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  @override
  void onInit() {
    super.onInit();
    focusedDay = DateTime.now();
    kFirstDay = DateTime(focusedDay.year, focusedDay.month - 1, focusedDay.day);
    kLastDay = DateTime(focusedDay.year + 1, focusedDay.month, focusedDay.day);
    selectedDay = focusedDay;

    kEventSource = {
      for (var item in List.generate(1, (index) => index))
        DateTime.utc(kFirstDay.year, kFirstDay.month, item): List.empty()
    };

    kEvents = LinkedHashMap<DateTime, List<Turn>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(kEventSource);

    selectedEvents = ValueNotifier(getEventsForDay(focusedDay));
  }

  void setTurnos(List<Turn> iTurnos) {
    print('setTurnos >> turnos = $iTurnos');
    turnos = iTurnos;
    print('setTurnos >> turnos = $turnos');
    kEventSource = Map.fromIterable(List.generate(300, (index) => index),
        key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item),
        value: (item) {
          DateTime date = DateTime.utc(kFirstDay.year, kFirstDay.month, item);
          //print('kEventSource>> value: date = $date');
          List<Turn> result = [];
          for (var i = 0; i < turnos.length; i++) {
            if (isSameDay(turnos[i].date, date) &&
                turnos[i].name != 'Descanso') {
              result.add(turnos[i]);
              //print('kEventSource>> value: result = $result');
            }
          }
          return result;
        });

    kHoliday = [];
    for (Turn turno in iTurnos) {
      print('turno for holiday = ${turno.name}');
      if (turno.name == 'Descanso') {
        print('turno for holiday = ${turno.date}');
        kHoliday.add(turno.date);
      }
    }

    kEvents = LinkedHashMap<DateTime, List<Turn>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(kEventSource);

    //selectedEvents = ValueNotifier(getEventsForDay(focusedDay));
    selectedEvents.value = getEventsForDay(focusedDay);
    //update();
  }

  List<Turn> getEventsForDay(DateTime date) {
    return kEvents[date] ?? [];
  }

  List<Turn> getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ...getEventsForDay(d),
    ];
  }

  void onDaySelected(DateTime sDay, DateTime fDay) {
    if (!isSameDay(selectedDay, sDay)) {
      selectedDay = sDay;
      focusedDay = fDay;
      rangeStart = null;
      rangeEnd = null;
      rangeSelectionMode = RangeSelectionMode.toggledOff;
      selectedEvents.value = getEventsForDay(sDay);
      update();
    }
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime fDay) {
    selectedDay = null;
    focusedDay = fDay;
    rangeStart = start;
    rangeEnd = end;
    rangeSelectionMode = RangeSelectionMode.toggledOn;
    update();
    if (start != null && end != null) {
      selectedEvents.value = getEventsForRange(start, end);
    } else if (start != null) {
      selectedEvents.value = getEventsForDay(start);
    } else if (end != null) {
      selectedEvents.value = getEventsForDay(end);
    }
  }

  void setCalendarFormat(CalendarFormat format) {
    calendarFormat = format;
    update();
  }

  @override
  void onClose() {
    super.onClose();
    selectedEvents.dispose();
  }

  bool getHoliday(DateTime day) {
    //print('getHoliday day = $day');
    //print('getHoliday return = ${kHoliday.contains(day)}');
    bool result = false;
    for (var date in kHoliday) {
      //print('getHoliday kHoliday = $date');
      if (date.year == day.year &&
          date.month == day.month &&
          date.day == day.day) {
        result = true;
        break;
      }
    }
    return result;
  }

  bool isHoliday() {
    print('isHoliday selectedDay = $selectedDay');
    return getHoliday(selectedDay!);
  }

  Future addHoliday(DateTime day) async {
    print('day = $day');
    final transaction = Turn('Descanso', day, 0, 0);
    //turnos.
    if (isCreatedBox) {
      final box = Boxes.getTurn();
      print('addHoliday box index = ${box.keys}');
      if (box.containsKey(day.toString())) {
        print('addHoliday box delete');
        box.delete(day.toString());
      } else {
        print('addHoliday box add');
        box.put(day.toString(), transaction);
      }
    } else {
      Hive.openBox('turn')
          .then((value) => value.put(day.toString(), transaction));
    }
    print('addDescanso complete');
    update();
  }

  Future removeTurno(Turn? turno) async {
    if (turno != null) {
      print('index = ${turno.date}');
      final box = Boxes.getTurn();
      box.delete(turno.date.toString());
      print('removeTurno complete');
      update();
    }
  }

  void convertBox(List<Turn> cast) {
    final box = Boxes.getTurn();
    /* int i = 0;
    for (var co in cast) {
      DateTime dateTime = new DateTime(co.date.year, co.date.month, co.date.day,
          horaTurno[co.value] ?? 8, 0);
      print(
          'convertBoxCalendar >> dateTime = ${co.date.toString()}, value = ${co.value}');
      print('convertBoxCalendar >> key = ${dateTime.toString()}, keyOld = $i');
      box.delete(i);
      box.put(dateTime.toString(), co);
      i = i + 1;
    } */
    //int last = box.keys.toList().last;
    Iterable<dynamic> keys = box.keys;
    for (var i = 0; i < box.length; i++) {
      print('convertBoxCalendar >> key = ${keys.elementAt(i)}');
      if (keys.elementAt(i).toString().length < 3) {
        Turn turnoOld = box.getAt(i)!;
        DateTime dateTime = DateTime(
            turnoOld.date.year,
            turnoOld.date.month,
            turnoOld.date.day,
            turnoOld.name == 'Descanso' ? horaTurno[turnoOld.value] ?? 8 : 0,
            0);
        print(
            'convertBoxCalendar >> dateTime = ${turnoOld.date.toString()}, value = ${turnoOld.value}');
        print(
            'convertBoxCalendar >> key = ${dateTime.toString()}, keyOld = ${keys.elementAt(i)}');
        box.delete(keys.elementAt(i));
        box.put(dateTime.toString(),
            Turn(turnoOld.name, dateTime, turnoOld.pay, 0));
      }
    }
    print('convertBoxCalendar >> length = ${box.length}');
  }
}
