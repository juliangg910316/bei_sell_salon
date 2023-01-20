import 'package:bei_sell/controllers/home_controller.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/state_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: ((controller) {
          return Scaffold(
            body: SafeArea(
                child: IndexedStack(
                    index: controller.indexBarNavigation,
                    children: controller.widgetOptions)),
            bottomNavigationBar: CurvedNavigationBar(
              items: controller.iconOptions,
              height: 60,
              color: Colors.grey,
              backgroundColor: Colors.white,
              buttonBackgroundColor: Colors.blue,
              onTap: controller.setIndex,
            ),
          );
        }));
  }
}
