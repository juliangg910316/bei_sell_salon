import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/models/costs.dart';
import 'package:bei_sell/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InversionDialogController extends GetxController {
  final gastoController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime selectDate = DateTime.now().obs();

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

  Future addTransaction(int cost, bool isCreatedBox) async {
    final transaction = CostsSalon(
      createdDate: (Util.format).format(selectDate),
      cost: cost,
      description: '',
      prod: '',
    );

    if (isCreatedBox) {
      final box = Boxes.getCosts();
      box.put(transaction.createdDate, transaction);
    } else {
      Hive.openBox('costs')
          .then((value) => value.put(transaction.createdDate, transaction));
    }
    print('addTransaction complete');
    update();
  }
}
