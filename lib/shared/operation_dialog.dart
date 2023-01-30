import 'package:bei_sell/controllers/operation_dialog_controller.dart';
import 'package:bei_sell/controllers/salon_controller.dart';
import 'package:bei_sell/models/fact.dart';
import 'package:bei_sell/shared/custom_button.dart';
import 'package:bei_sell/shared/custom_text_editing.dart';
import 'package:bei_sell/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class OperationDialog extends StatelessWidget {
  final FactSalon? cierreDiario;
  final bool isCreatedBox;
  final SalonController pController;

  const OperationDialog(
      {Key? key,
      this.cierreDiario,
      required this.isCreatedBox,
      required this.pController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OperationDialogController>(
        init: OperationDialogController(factSalon: cierreDiario),
        builder: (controller) {
          return AlertDialog(
            title: const Text('Cierre del dia'),
            content: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    CustomTextEditing.buildMonto(
                        controller.facturadoController, 'Facturado'),
                    /* SizedBox(height: 8),
                    buildName(controller.gananciasController, 'Ganancias'),
                    SizedBox(height: 8),
                    buildName(controller.inversionController, 'Inversión'), */
                    const SizedBox(height: 8),
                    CustomTextEditing.buildMonto(
                        controller.salariosController, 'Salario'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => controller.setSelectDate(context),
                      child: Text(
                          '${controller.selectDate.day} ${Util.getNameMonth(controller.selectDate.month.toString(), false)}'),
                    )
                    /* SizedBox(height: 8),
                buildRadioButtons(), */
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              CustomButtons.buildCancelButton(context),
              CustomButtons.buildAddButton(
                isEditing: false,
                onPressed: () async {
                  if (controller.formKey.currentState!.validate()) {
                    final fact =
                        int.tryParse(controller.facturadoController.text) ?? 0;
                    //final gan = int.tryParse(controller.gananciasController.text) ?? 0;
                    final sal =
                        int.tryParse(controller.salariosController.text) ?? 0;
                    //final inv = int.tryParse(controller.inversionController.text) ?? 0;
                    final gan = ((fact - sal) * 0.4).round();
                    final inv = (fact - sal) - gan;
                    Map<String, int> salarios = {'Beidis': sal};

                    controller.addTransaction(
                        fact, gan, salarios, inv, isCreatedBox, pController);

                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
