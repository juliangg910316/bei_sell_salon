import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/controllers/transaccion_controller.dart';
import 'package:bei_sell/models/fact.dart';
import 'package:bei_sell/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FactListScreen extends StatelessWidget {
  const FactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionController>(
        init: TransactionController(),
        builder: (controller) {
          return FutureBuilder(
              future: Hive.boxExists('fact_salon'),
              builder: (context, snapshot) {
                print('TransactionsPage >> resp = $snapshot');
                if (snapshot.connectionState == ConnectionState.done) {
                  print('TransactionsPage >> resp = ${snapshot.data}');
                  controller.isCreatedBox = snapshot.data as bool;
                  if (snapshot.data as bool) {
                    return _buildListener(
                      controller: controller,
                    );
                  } else {
                    return const Center(child: Text('Bienvenido!!!'));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              });
        });
  }
}

class _buildListener extends StatelessWidget {
  final TransactionController controller;
  const _buildListener({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FactSalon>>(
      valueListenable: Boxes.getFactSalon().listenable(),
      builder: (context, box, _) {
        List<DateTime> dateTimes = Util.getListDateTimeSort(box.keys);
        List<FactSalon> cierres = [];
        dateTimes.forEach((date) {
          FactSalon? cDiario = box.get((Util.format).format(date));
          if (cDiario != null) cierres.add(cDiario);
        });
        if (cierres.isNotEmpty) controller.cierres = cierres.reversed.toList();
        return getView(controller: controller);
      },
    );
  }
}

class getView extends StatelessWidget {
  const getView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TransactionController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (_, index) => ListTile(
              leading: ShaderMask(
                shaderCallback: (rect) {
                  Shader shader = const LinearGradient(
                          colors: [Colors.green, Colors.greenAccent])
                      .createShader(rect);
                  return shader;
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.monetization_on_outlined,
                  ),
                ),
              ),
              title: Text('${controller.cierres[index].fact}'),
              onLongPress: () =>
                  controller.deleteTransaction(controller.cierres[index]),
              trailing: Text(
                  '${controller.cierres[index].createdDate.split('.')[0]} / ${Util.getNameMonth(controller.cierres[index].createdDate.split('.')[1], true).toUpperCase()}'),
            ),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: controller.cierres.length);
  }
}
