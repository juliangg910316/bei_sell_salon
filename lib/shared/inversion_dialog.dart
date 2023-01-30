import 'package:bei_sell/controllers/inversion_dialog_controller.dart';
import 'package:bei_sell/shared/custom_button.dart';
import 'package:bei_sell/shared/custom_text_editing.dart';
import 'package:bei_sell/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class InversionAddDialog extends StatelessWidget {
  const InversionAddDialog({Key? key, required this.isCreatedBox})
      : super(key: key);
  final bool isCreatedBox;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InversionDialogController>(
        init: InversionDialogController(),
        builder: (controller) {
          return AlertDialog(
            title: const Text('Inversión'),
            content: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    CustomTextEditing.buildMonto(
                        controller.gastoController, 'Gasto'),
                    /* SizedBox(height: 8),
                    buildName(controller.gananciasController, 'Ganancias'),
                    SizedBox(height: 8),
                    buildName(controller.inversionController, 'Inversión'), */
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
                    final gasto =
                        int.tryParse(controller.gastoController.text) ?? 0;
                    //final gan = int.tryParse(controller.gananciasController.text) ?? 0;

                    controller.addTransaction(gasto, isCreatedBox);

                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
