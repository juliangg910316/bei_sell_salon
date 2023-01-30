import 'package:bei_sell/models/fact.dart';
import 'package:bei_sell/utils/util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartUtil {
  static AxisTitles getBottomTitles(List<FactSalon> cierres) {
    return AxisTitles(
        axisNameSize: 22,
        axisNameWidget: const Text("Name"),
        sideTitles: SideTitles(interval: 1, reservedSize: 22, showTitles: true),
        drawBehindEverything: true
        //showTitles: true,
        // reservedSize: 22,
        //margin: 10,
        // interval: 1,
        // getTextStyles: (context, value) => const TextStyle(
        //   color: Color(0xff72719b),
        //   fontWeight: FontWeight.bold,
        //   fontSize: 16,
        // ),
        // getTitles: (value) {
        //   //print('getTitles $value');
        //   if (value < 0) {
        //     return '';
        //   } else {
        //     if (value.toInt() > cierres.length - 1) {
        //       return '';
        //     } else {
        //       DateTime date =
        //           (Util.format).parse(cierres[value.toInt()].createdDate);
        //       print('weekday = ${date.weekday}');
        //       String dd = Util.getNameWeekDay(date.weekday);
        //       return dd;
        //     }
        //   }
        // },
        );
  }
}
