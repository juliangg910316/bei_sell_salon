import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/controllers/inversions_list_controller.dart';
import 'package:bei_sell/models/costs.dart';
import 'package:bei_sell/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InversionsListScreen extends StatelessWidget {
  const InversionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InversionsListController>(
        init: InversionsListController(),
        builder: (controller) {
          return FutureBuilder(
              future: Hive.boxExists('costs'),
              builder: (context, snapshot) {
                print('InversionsListPage >> resp = $snapshot');
                if (snapshot.connectionState == ConnectionState.done) {
                  print('InversionsListPage >> resp = ${snapshot.data}');
                  controller.isCreatedBox = snapshot.data as bool;
                  if (snapshot.data as bool) {
                    return BuildListener(
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

class BuildListener extends StatelessWidget {
  final InversionsListController controller;
  const BuildListener({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<CostsSalon>>(
      valueListenable: Boxes.getCosts().listenable(),
      builder: (context, box, _) {
        List<DateTime> dateTimes = Util.getListDateTimeSort(box.keys);
        List<CostsSalon> cierres = [];
        for (var date in dateTimes) {
          CostsSalon? cDiario = box.get((Util.format).format(date));
          if (cDiario != null) cierres.add(cDiario);
        }
        if (cierres.isNotEmpty) {
          controller.inversionList = cierres.reversed.toList();
        }
        return GetView(controller: controller);
      },
    );
  }
}

class GetView extends StatelessWidget {
  const GetView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final InversionsListController controller;

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
              title: Text('${controller.inversionList[index].cost}'),
              onLongPress: () =>
                  controller.deleteTransaction(controller.inversionList[index]),
              trailing: Text(
                  '${controller.inversionList[index].createdDate.split('.')[0]} / ${Util.getNameMonth(controller.inversionList[index].createdDate.split('.')[1], true).toUpperCase()}'),
            ),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: controller.inversionList.length);
  }
}
