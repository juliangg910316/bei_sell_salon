import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/controllers/salon_controller.dart';
import 'package:bei_sell/models/fact.dart';
import 'package:bei_sell/shared/inversion_dialog.dart';
import 'package:bei_sell/shared/operation_dialog.dart';
import 'package:bei_sell/utils/util.dart';
import 'package:bei_sell/widget/home_view_top.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/adapters.dart';

class SalonScreen extends StatelessWidget {
  const SalonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isCreatedBox = false;
    return GetBuilder<SalonController>(
        init: SalonController(),
        builder: (controller) {
          return Scaffold(
            /* appBar: AppBar(
              title: Text('Salón de Belleza'),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () => print('config'),
                    icon: Icon(Icons.settings))
              ],
            ), */
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder(
                    future: Hive.boxExists('fact_salon'),
                    builder: (context, snapshot) {
                      print('fact_salon >> resp = $snapshot');
                      if (snapshot.connectionState == ConnectionState.done) {
                        print('fact_salon >> resp = ${snapshot.data}');
                        isCreatedBox = snapshot.data as bool;
                        if (isCreatedBox) {
                          return BuildListener(
                            controller: controller,
                          );
                        } else {
                          return const Center(child: Text('Bienvenido!!!'));
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () => showDialog(
                              context: context,
                              builder: (context) => OperationDialog(
                                isCreatedBox: isCreatedBox,
                                pController: controller,
                              ),
                            ),
                        child: Row(
                          children: const [
                            Icon(Icons.add),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Cierre día')
                          ],
                        )),
                    ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) =>
                            InversionAddDialog(isCreatedBox: isCreatedBox),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Inversión')
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                )
              ],
            ),
            /* floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => OperationDialog(
                  isCreatedBox: isCreatedBox,
                  pController: controller,
                ),
              ),
            ), */
          );
        });
  }
}

class BuildListener extends StatelessWidget {
  final SalonController controller;
  const BuildListener({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FactSalon>>(
      valueListenable: Boxes.getFactSalon().listenable(),
      builder: (context, box, _) {
        print('box keys ${box.keys}');
        List<DateTime> dateTimes = Util.getListDateTimeSort(box.keys);
        //print('box datetime sort = $dateTimes');
        List<FactSalon> cierres = [];
        for (var date in dateTimes) {
          //print('box format = ${(Utiles.format).format(date)}');
          FactSalon? cDiario = box.get((Util.format).format(date));
          if (cDiario != null) {
            //print('box CierreDiario = $cDiario');
            cierres.add(cDiario);
          }
        }
        //print('box Cierres = $cierres');
        if (cierres.isNotEmpty) {
          controller.cierres = cierres;
        }
        return Body(controller: controller);
      },
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SalonController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeViewTop(
          controller: controller,
        ),
        const SizedBox(
          height: 32,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 200,
              width: double.infinity,
              //color: Colors.grey,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                color: Colors.grey[300],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LineChart(controller.sampleData,
                    swapAnimationDuration: const Duration(milliseconds: 150),
                    swapAnimationCurve: Curves.linear),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
