import 'dart:convert';
import 'dart:io';

import 'package:bei_sell/models/fact.dart';
import 'package:bei_sell/models/turn.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Util {
  static final DateFormat format = DateFormat("dd.MM.yyyy");

  static String getNameMonth(String month, bool small) {
    switch (month) {
      case '01':
      case '1':
        return small ? 'ene' : 'Enero';
      case '02':
      case '2':
        return small ? 'feb' : 'Febrero';
      case '03':
      case '3':
        return small ? 'mar' : 'Marzo';
      case '04':
      case '4':
        return small ? 'abr' : 'Abril';
      case '05':
      case '5':
        return small ? 'may' : 'Mayo';
      case '06':
      case '6':
        return small ? 'jun' : 'Junio';
      case '07':
      case '7':
        return small ? 'jul' : 'Julio';
      case '08':
      case '8':
        return small ? 'ago' : 'Agosto';
      case '09':
      case '9':
        return small ? 'sep' : 'Septiembre';
      case '10':
        return small ? 'oct' : 'Octubre';
      case '11':
        return small ? 'nov' : 'Noviembre';
      case '12':
        return small ? 'dic' : 'Diciembre';
      default:
        return '';
    }
  }

  static String getNameWeekDay(int weekday) {
    switch (weekday) {
      case 1:
        return 'lun';
      case 2:
        return 'mar';
      case 3:
        return 'mie';
      case 4:
        return 'jue';
      case 5:
        return 'vie';
      case 6:
        return 'sab';
      case 7:
        return 'dom';
      default:
        return '';
    }
  }

  static List<DateTime> getListDateTimeSort(Iterable<dynamic> index) {
    List<DateTime> dateTimes = [];
    index.forEach((element) {
      dateTimes.add(format.parse(element));
    });
    dateTimes.sort((a, b) => a.compareTo(b));
    return dateTimes;
  }

  static Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/turnos.txt');
  }

  static Future<File> get _indexFile async {
    final path = await _localPath;
    return File('$path/index_turnos.txt');
  }

  static Future<File> get _cierresFile async {
    final path = await _localPath;
    return File('$path/cierres.txt');
  }

  static Future<File> writeTurnos(List<Turn> turnos) async {
    final file = await _localFile;
    String contens = '';
    for (var i = 0; i < turnos.length; i++) {
      String json = jsonEncode(turnos[i].toJson());
      print('json = $json');
      if (i == 0)
        contens = '$json';
      else
        contens = '$contens; $json';
    }

    // Write the file
    return file.writeAsString('$contens');
  }

  static Future<File> writeCierres(List<FactSalon> cierres) async {
    final file = await _cierresFile;
    String contens = '';
    for (var i = 0; i < cierres.length; i++) {
      String json = jsonEncode(cierres[i].toJson());
      print('json = $json');
      if (i == 0)
        contens = '$json';
      else
        contens = '$contens; $json';
    }

    // Write the file
    return file.writeAsString('$contens');
  }

  static Future<File> writeIndexTurns(Iterable<dynamic> keys) async {
    final file = await _indexFile;
    String contens = '${keys.elementAt(0).toString()}';
    for (var i = 1; i < keys.length; i++) {
      contens = '$contens, ${keys.elementAt(i).toString()}';
    }

    // Write the file
    return file.writeAsString('$contens');
  }

  static Future<List<Turn>> readTurns() async {
    List<Turn> turns = [];
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      print('contents = $contents');
      List<String> list = contents.split('; ');
      for (var cont in list) {
        print('turnos = $cont');
        Map<String, dynamic> turnoMap = jsonDecode(cont);
        print('name = ${turnoMap.values}');
        turns.add(Turn.fromJson(turnoMap));
      }

      return turns;
    } catch (e) {
      print('exception = $e');
      // If encountering an error, return 0
      return turns;
    }
  }
}
