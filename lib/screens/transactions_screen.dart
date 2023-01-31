import 'package:bei_sell/screens/fact_list_screen.dart';
import 'package:bei_sell/screens/inversions_list_screen.dart';
import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(text: 'Cierres'),
              Tab(
                text: 'Inversiones',
              )
            ]),
            title: const Text('Transacciones'),
          ),
          body: const TabBarView(children: [
            FactListScreen(),
            InversionsListScreen(),
          ]),
        ));
  }
}
