import 'dart:math';

import 'package:bei_sell/boxes.dart';
import 'package:bei_sell/models/fact.dart';
import 'package:bei_sell/utils/util.dart';
import 'package:bei_sell/utils/util_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalonController extends GetxController {
  late List<FactSalon> cierres = [];
  late List<FactSalon> dataCierresSpots = [];
  String selected = 'Dia';
  final dropdownList = <String>['Dia', 'Semana', 'Mes'];

  void setUpdate() {
    print('controller update');
    update();
  }

  int getProfits() {
    int result = 0;
    if (cierres.isNotEmpty) {
      List<FactSalon> list = _getCierresForDate();
      for (var i = 0; i < list.length; i++) {
        result = result + list[i].profit;
      }
    }
    return result;
  }

  int getFact() {
    int result = 0;
    if (cierres.isNotEmpty) {
      List<FactSalon> list = _getCierresForDate();
      for (var i = 0; i < list.length; i++) {
        result = result + list[i].fact;
      }
    }
    return result;
  }

  int getInversion() {
    int result = 0;
    if (cierres.isNotEmpty) {
      List<FactSalon> list = _getCierresForDate();
      for (var i = 0; i < list.length; i++) {
        result = result + list[i].inversion;
      }
    }
    return result;
  }

  int getCosts() {
    int result = 0;
    if (cierres.isNotEmpty) {
      List<FactSalon> list = _getCierresForDate();
      for (var i = 0; i < list.length; i++) {
        Map<String, int> sal = list[i].salary;
        result = result + sal.values.first;
      }
    }
    return result;
  }

  String getTextLastDay() {
    List<FactSalon> cSemana = _getCierresForDate();
    switch (selected) {
      case 'Dia':
        DateTime date = cierres.isNotEmpty
            ? (Util.format).parse(cierres[cierres.length - 1].createdDate)
            : DateTime.now();
        if (date.day == DateTime.now().day) {
          return 'HOY';
        } else {
          return 'el ${date.day} de ${Util.getNameMonth(date.month.toString(), false)}';
        }

      case 'Semana':
        return 'del ${cSemana[0].createdDate.split('.')[0]}/${Util.getNameMonth(cSemana[0].createdDate.split('.')[1], true)} hasta HOY';

      case 'Mes':
        return 'del ${cSemana[0].createdDate.split('.')[0]}/${Util.getNameMonth(cSemana[0].createdDate.split('.')[1], true)} hasta HOY';

      default:
        return '';
    }
  }

  LineChartBarData get lineChartBarData {
    List<FactSalon> dataCierres = _getCierresForSpots();

    List<FlSpot> mSpots = [];
    for (var i = 0; i < dataCierres.length; i++) {
      mSpots.add(FlSpot(i.toDouble(), dataCierres[i].fact.toDouble()));
    }
    return LineChartBarData(
      isCurved: true,
      color: Colors.blue, //[const Color(0xff4af699)],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: mSpots,
    );
  }

  LineChartData get sampleData => LineChartData(
        lineBarsData: [lineChartBarData],
        lineTouchData: lineTouchData,
        gridData: FlGridData(show: false),
        titlesData: titlesData,
        borderData: borderData,
        minX: -1,
        maxX: 7,
        minY: 0,
        maxY: 3000,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: ChartUtil.getBottomTitles(dataCierresSpots),
        rightTitles: AxisTitles(),
        topTitles: AxisTitles(),
        /* leftTitles: leftTitles(
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
            }
            return '';
          },
        ), */
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  void setSelected(String val) {
    if (selected != val) {
      selected = val;
      update();
    }
  }

  List<FactSalon> _getCierresForDate() {
    switch (selected) {
      case 'Dia':
        if (cierres.length > 0) {
          return [cierres[cierres.length - 1]];
        } else {
          return [];
        }
      case 'Semana':
        return cierres.sublist(
            cierres.length - (min(cierres.length, 7)), cierres.length);
      case 'Mes':
        return cierres.sublist(
            cierres.length - (min(cierres.length, 30)), cierres.length);
      default:
        return [cierres[cierres.length - 1]];
    }
  }

  List<FactSalon> _getCierresForSpots() {
    List<FactSalon> result = cierres.sublist(
        cierres.length - min(cierres.length, 7), cierres.length);

    dataCierresSpots = result;
    return result;
  }

  void convertBox(List<FactSalon> cierresOld) {
    /* Hive.openBox('cierresDiario').then((value) {
      for (var co in cierresOld) {
        value.put(co.createdDate.toString(), co);
      }
      update();
    }); */
    /* final boxOld = Boxes.getCierreDiario();
    boxOld.clear();
    boxOld.close(); */
    final box = Boxes.getFactSalon();
    int i = 0;
    for (var co in cierresOld) {
      print('convertBox >> key = ${co.createdDate.toString()}, keyOld = $i');
      box.delete(i);
      box.put(co.createdDate.toString(), co);
      i = i + 1;
    }
    print('convertBox >> length = ${box.length}');
    //update();
  }
}
