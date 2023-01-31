import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/controllers/calendar_event_controller.dart';
import 'package:bei_sell/models/turn.dart';
import 'package:bei_sell/shared/operation_dialog.dart';
import 'package:bei_sell/shared/turn_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarEventController>(
        init: CalendarEventController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Turnos'),
            ),
            body: FutureBuilder(
                future: Hive.boxExists('turn'),
                builder: (context, snapshot) {
                  print('resp = $snapshot');
                  if (snapshot.connectionState == ConnectionState.done) {
                    print('resp = ${snapshot.data}');
                    controller.isCreatedBox = snapshot.data as bool;
                    if (snapshot.data as bool) {
                      return BuildListener(
                        controller: controller,
                      );
                    } else {
                      return Center(
                        child: ElevatedButton(
                            onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => TurnoDialog(
                                    pController: controller,
                                    turno: null,
                                    index: 0,
                                  ),
                                ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.add),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Turno')
                              ],
                            )),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          );
        });
  }
}

class BuildListener extends StatelessWidget {
  final CalendarEventController controller;
  const BuildListener({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Turn>>(
      valueListenable: Boxes.getTurn().listenable(),
      builder: (context, box, _) {
        print('box.getTurno values ${box.length}');
        print('box.getTurno keys ${box.keys}');
        /* bool isConvert = false;
        Iterable<dynamic> keys = box.keys;
        for (var i = 0; i < box.length; i++) {
          print('convertBoxCalendar >> key = ${keys.elementAt(i)}');
          if (keys.elementAt(i).toString().length < 3) {
            isConvert = true;
          }
        }
        if (isConvert) {
          print('box.getTurno containsKey $isConvert');
          controller.convertBox(box.values.toList().cast<Turno>());
          //return Center(child: Text('Actualizando Base de Datos!!!'));
        } else { */
        final cierres = box.values.toList().cast<Turn>();
        print('box.getTurno new $cierres');
        controller.setTurnos(box.values.toList().cast<Turn>());
        //}
        return CalendarBody(
          controller: controller,
        );
      },
    );
  }
}

class CalendarBody extends StatelessWidget {
  final CalendarEventController controller;
  const CalendarBody({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TableCalendar(
        locale: 'es',
        focusedDay: controller.focusedDay,
        firstDay: controller.kFirstDay,
        lastDay: controller.kLastDay,
        selectedDayPredicate: (day) => isSameDay(controller.selectedDay, day),
        rangeStartDay: controller.rangeStart,
        rangeEndDay: controller.rangeEnd,
        calendarFormat: controller.calendarFormat,
        rangeSelectionMode: controller.rangeSelectionMode,
        eventLoader: controller.getEventsForDay,
        onDaySelected: controller.onDaySelected,
        onDayLongPressed: (day, _) => controller.addHoliday(day),
        onRangeSelected: controller.onRangeSelected,
        onFormatChanged: (format) {
          if (controller.calendarFormat != format) {
            controller.setCalendarFormat(format);
          }
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekStyle: const DaysOfWeekStyle(
            weekendStyle: TextStyle(color: Colors.deepPurple)),
        calendarStyle: const CalendarStyle(
          weekendTextStyle: TextStyle(color: Colors.deepPurple),
          outsideDaysVisible: false,
        ),
        holidayPredicate: (day) => controller.getHoliday(day),
      ),
      const SizedBox(height: 8.0),
      Expanded(
        child: ValueListenableBuilder<List<Turn>>(
          valueListenable: controller.selectedEvents,
          builder: (context, value, _) {
            print('builder expanded: $value');
            if (value.length == 0 && controller.isHoliday()) {
              return const Center(
                  child: Text('Descanso',
                      style: TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold)));
            } else {
              return ListTurnos(controller: controller, turns: value);
            }
          },
        ),
      ),
    ]);
  }
}

class ListTurnos extends StatelessWidget {
  const ListTurnos({
    Key? key,
    required this.controller,
    required this.turns,
  }) : super(key: key);

  final CalendarEventController controller;
  final List<Turn> turns;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        Turn? turn;
        for (var i = 0; i < turns.length; i++) {
          if (turns[i].date.hour == controller.horaTurno[index]) {
            turn = turns[i];
          }
        }
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: turn != null ? Colors.blue : Colors.grey),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: GetListTile(
            controller: controller,
            index: index,
            turn: turn,
          ),
        );
      },
    );
  }
}

class GetListTile extends StatelessWidget {
  const GetListTile(
      {Key? key,
      required this.controller,
      required this.index,
      required this.turn})
      : super(key: key);

  final CalendarEventController controller;
  final int index;
  final Turn? turn;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () => showDialog(
              context: context,
              builder: (context) => TurnoDialog(
                pController: controller,
                turno: turn,
                index: index,
              ),
            ),
        onLongPress: () => controller.removeTurno(turn),
        title: GetTitle(turn),
        //enabled: turno != null ? true : false,
        selected: turn != null ? true : false,
        hoverColor: Colors.red,
        //tileColor: Colors.amber,
        //selectedTileColor: Colors.lightBlue,
        focusColor: Colors.blue,
        leading: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Icon(
              Icons.timer_sharp,
              color: turn != null ? Colors.blue : Colors.grey,
            ),
            Text(
              horarios[index],
              style: TextStyle(color: turn != null ? Colors.blue : Colors.grey),
            ),
            //Text(index < 2 ? 'AM' : 'PM')
          ],
        ),

        //subtitle: Text('algo'),
        trailing: turn != null
            ? Text('\$ ${turn!.pay}')
            : const Icon(Icons.navigate_next));
  }
}

/* class getLeading extends StatelessWidget {
  final int index;
  const getLeading(
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(horarios[index]), Text(index < 2 ? 'AM' : 'PM')],
    );
  }
} */

class GetTitle extends StatelessWidget {
  final Turn? turn;
  const GetTitle(
    this.turn, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return turn != null
        ? Text(turn!.name)
        : const Text(
            'Vacio',
            style: TextStyle(color: Colors.grey),
          );
  }
}

List<String> horarios = ['8 AM', '10 AM', '1 PM', '3 PM', '5 PM', '7 PM'];
