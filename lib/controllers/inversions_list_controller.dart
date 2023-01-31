import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/models/costs.dart';
import 'package:get/get.dart';

class InversionsListController extends GetxController {
  late List<CostsSalon> inversionList = [];
  bool isCreatedBox = false;

  void deleteTransaction(CostsSalon inversion) {
    final box = Boxes.getCosts();
    box.delete(inversion.createdDate);
    update();
  }
}
