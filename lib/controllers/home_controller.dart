import 'package:bei_sell/screens/calendar_screen.dart';
import 'package:bei_sell/screens/configuration_screen.dart';
import 'package:bei_sell/screens/salon_screen.dart';
import 'package:bei_sell/screens/setting_screen.dart';
import 'package:bei_sell/screens/store_screen.dart';
import 'package:bei_sell/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  int indexBarNavigation = 0;

  List<Widget> widgetOptions = <Widget>[
    const SafeArea(child: SalonScreen()),
    const SafeArea(child: CalendarScreen()),
    const SafeArea(child: TransactionsScreen()),
    const SafeArea(child: SettingScreen()),
  ];

  List<Widget> iconOptions = [
    const Icon(Icons.account_balance_wallet_outlined),
    const Icon(Icons.calendar_today_outlined),
    const Icon(Icons.graphic_eq_sharp),
    const Icon(Icons.list_alt_outlined),
  ];

  setIndex(int index) {
    indexBarNavigation = index;
    update();
  }
}
