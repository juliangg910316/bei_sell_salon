import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/controllers/calendar_event_controller.dart';
import 'package:bei_sell/models/turn.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';

class TurnoDialogController extends GetxController {
  final nameController = TextEditingController();
  final montoController = TextEditingController();
  final Turn? turno;
  final formKey = GlobalKey<FormState>();
  DateTime selectDate = DateTime.now().obs();

  TurnoDialogController(this.turno);

  @override
  void onInit() {
    super.onInit();
    if (turno != null) {
      nameController.text = turno!.name.toString();
      montoController.text = turno!.pay.toString();
    }
  }

  Future<void> setSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2025));
    if (picked != null && picked != selectDate) {
      selectDate = picked;
      update();
    }
  }

  Future addTurno(String name, int monto, int value,
      CalendarEventController controller) async {
    DateTime date = DateTime(
        controller.focusedDay.year,
        controller.focusedDay.month,
        controller.focusedDay.day,
        controller.horaTurno[value] ?? 8,
        0);
    final transaction = Turn(name, date, monto, 0);

    if (controller.isCreatedBox) {
      final box = Boxes.getTurn();
      box.put(date.toString(), transaction);
    } else {
      Hive.openBox('turn')
          .then((value) => value.put(date.toString(), transaction));
    }
    print('addTurno complete');
    controller.update();
  }
}
