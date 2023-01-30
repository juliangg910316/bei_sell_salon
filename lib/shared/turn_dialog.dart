import 'package:bei_sell/controllers/calendar_event_controller.dart';
import 'package:bei_sell/controllers/turn_dialog_controller.dart';
import 'package:bei_sell/models/turn.dart';
import 'package:bei_sell/shared/custom_button.dart';
import 'package:bei_sell/shared/custom_text_editing.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class TurnoDialog extends StatelessWidget {
  final CalendarEventController pController;
  final Turn? turno;
  final int index;
  const TurnoDialog(
      {Key? key,
      required this.pController,
      required this.turno,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TurnoDialogController>(
        init: TurnoDialogController(turno),
        builder: (controller) {
          return AlertDialog(
            title: const Text('Nuevo turno'),
            content: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    CustomTextEditing.buildName(
                        controller.nameController, 'Nombre'),
                    /* SizedBox(height: 8),
                    buildName(controller.gananciasController, 'Ganancias'),
                    SizedBox(height: 8),
                    buildName(controller.inversionController, 'Inversión'), */
                    const SizedBox(height: 8),
                    CustomTextEditing.buildMonto(
                        controller.montoController, 'Pago'),
                    /* SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => controller.setSelectDate(context),
                      child: Text(
                          '${controller.selectDate.day} ${Utiles.getNameMonth(controller.selectDate.month, false)}'),
                    ) */
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
                    final name = controller.nameController.text;
                    //final gan = int.tryParse(controller.gananciasController.text) ?? 0;
                    final pay =
                        int.tryParse(controller.montoController.text) ?? 0;
                    //final inv = int.tryParse(controller.inversionController.text) ?? 0;

                    controller.addTurno(name, pay, index, pController);

                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
