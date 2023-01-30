import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/controllers/salon_controller.dart';
import 'package:bei_sell/models/fact.dart';
import 'package:bei_sell/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';

class OperationDialogController extends GetxController {
  final facturadoController = TextEditingController();
  final gananciasController = TextEditingController();
  final salariosController = TextEditingController();
  final inversionController = TextEditingController();
  final FactSalon? factSalon;
  final formKey = GlobalKey<FormState>();
  DateTime selectDate = DateTime.now().obs();

  OperationDialogController({required this.factSalon});

  @override
  void onInit() {
    super.onInit();
    if (factSalon != null) {
      facturadoController.text = factSalon!.fact.toString();
      gananciasController.text = factSalon!.profit.toString();
      salariosController.text = factSalon!.salary[0].toString();
      inversionController.text = factSalon!.inversion.toString();
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

  Future addTransaction(int facturado, int ganancias, Map<String, int> salarios,
      int inversion, bool isCreatedBox, SalonController controller) async {
    final transaction = FactSalon(
        createdDate: (Util.format).format(selectDate),
        fact: facturado,
        profit: ganancias,
        description: "",
        salary: salarios,
        inversion: inversion);

    if (isCreatedBox) {
      final box = Boxes.getFactSalon();
      box.put(transaction.createdDate, transaction);
    } else {
      Hive.openBox('fact_salon')
          .then((value) => value.put(transaction.createdDate, transaction));
    }
    print('addTransaction complete');
    controller.setUpdate();
  }
}
