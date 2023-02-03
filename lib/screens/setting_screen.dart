import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/models/fact.dart';
import 'package:bei_sell/models/turn.dart';
import 'package:bei_sell/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configuración'),
        ),
        body: Column(
          children: [
            MyListTile(
              option: 'Salvar datos',
              onPresses: () => saveTurnos(),
            ),
            MyListTile(
              option: 'Salvar índices',
              onPresses: () => saveIndexTurnos(),
            ),
            MyListTile(
              option: 'Cargar turnos',
              onPresses: () => loadTurnos(),
            ),
            MyListTile(
              option: 'Borrar turnos',
              onPresses: () => clearTurnos(),
            )
          ],
        ));
  }
}

class MyListTile extends StatelessWidget {
  const MyListTile({
    Key? key,
    required this.option,
    required this.onPresses,
  }) : super(key: key);

  final String option;
  final Function onPresses;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        onTap: () => onPresses(),
        title: Text(option),
        trailing: const Icon(Icons.navigate_next),
      ),
    );
  }
}

void clearTurnos() {
  final box = Boxes.getTurn();
  box.clear();
  Get.snackbar('Bei Nails', 'Turnos borrados');
}

void loadTurnos() async {
  Util.readTurns().then((value) {
    print('value read = $value');
    final box = Boxes.getTurn();
    for (var turno in value) {
      box.put(turno.date.toString(), turno);
    }
    print('box.keys = ${box.keys}');
    print('box.values = ${box.values}');
  });
  Get.snackbar('Bei Nails', 'Turnos cargados en archivo');
}

void saveTurnos() {
  final box = Boxes.getTurn();
  final turnos = box.values.toList().cast<Turn>();
  Util.writeTurnos(turnos).then((value) {
    print('value writeTurnos = $value');
  });
  final boxCierres = Boxes.getFactSalon();
  final cierres = boxCierres.values.toList().cast<FactSalon>();
  Util.writeCierres(cierres).then((value) {
    print('value writeCierres = $value');
  });
  Get.snackbar('Bei Nails', 'Datos salvados en archivo');
}

void saveIndexTurnos() {
  final box = Boxes.getTurn();
  final Iterable<dynamic> keys = box.keys;
  Util.writeIndexTurns(keys).then((value) {
    print('value index write = $value');
  });
  Get.snackbar('Bei Nails', 'Turnos salvados en archivo');
}
