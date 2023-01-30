import 'package:get/get.dart';

class SalonController extends GetxController {
  String selected = 'Dia';
  final dropdownList = <String>['Dia', 'Semana', 'Mes'];

  void setUpdate() {
    print('controller update');
    update();
  }
}
