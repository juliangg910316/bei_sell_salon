import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/models/fact.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  late List<FactSalon> cierres = [];
  bool isCreatedBox = false;

  void deleteTransaction(FactSalon cierr) {
    final box = Boxes.getFactSalon();
    box.delete(cierr.createdDate);
    update();
  }
}
