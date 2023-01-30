import 'package:bei_sell/controllers/salon_controller.dart';
import 'package:bei_sell/shared/custom_text_style.dart';
import 'package:bei_sell/widget/amount_text.dart';
import 'package:bei_sell/widget/frame_home.dart';
import 'package:flutter/material.dart';

class HomeViewTop extends StatelessWidget {
  final SalonController controller;
  const HomeViewTop({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20)),
          color: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Salón de Belleza',
                    style: CustomTextStyle.titleTextStyle(size: 24),
                  ),
                  DropdownButton(
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: Colors.blueGrey,
                    iconDisabledColor: Colors.white,
                    iconEnabledColor: Colors.white,
                    value: controller.selected,
                    items: controller.dropdownList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (String? val) {
                      controller.setSelected(val!);
                    },
                  )
                  /* IconButton(
                      onPressed: () => print('setting'),
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      )), */
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              AmountText(amount: controller.getFact().toString()),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: Text(
                  'Facturado ${controller.getTextLastDay()}',
                  style: CustomTextStyle.bodyTextStyle(size: 18),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                height: 80,
                width: double.infinity,
                child: Row(
                  children: [
                    FrameHome(
                      title: 'Salario',
                      body: controller.getCosts().toString(),
                      onPressed: () => print('facturado'),
                      color: Colors.grey[200],
                    ),
                    FrameHome(
                      title: 'Ganancias',
                      body: controller.getProfits().toString(),
                      onPressed: () => print('inversion'),
                    ),
                    FrameHome(
                      title: 'Utilidades',
                      body: controller.getInversion().toString(),
                      onPressed: () => print('gastos'),
                      color: Colors.grey[200],
                    ),
                  ],
                ),
              )
              /* Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContainer(
                  title: 'Facturado',
                  body: '${controller.getFacturado()} CUP',
                  onPressed: () => print('Facturado')),
              SizedBox(width: 16),
              _buildContainer(
                  title: 'Gastos',
                  body: '${controller.getGastos()} CUP',
                  onPressed: () => print('Gastos')),
            ],
          ), */
            ],
          ),
        ));
  }
}
