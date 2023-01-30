import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'fact.g.dart';

@HiveType(typeId: 0)
class FactSalon extends HiveObject {
  @HiveField(0)
  String createdDate;

  @HiveField(1)
  int fact;

  @HiveField(2)
  int profit;

  @HiveField(5)
  int inversion;

  @HiveField(3)
  String description;

  @HiveField(4)
  Map<String, int> salary;

  FactSalon(
      {required this.createdDate,
      required this.fact,
      required this.profit,
      required this.description,
      required this.salary,
      required this.inversion});

  @override
  String toString() {
    // TODO: implement toString
    return '$createdDate : $fact';
  }

  Map<String, dynamic> toJson() => {
        'createdDate': createdDate,
        'facturado': fact,
        'ganancias': profit,
        'description': description,
        'salarios': salary,
        'inversion': inversion,
      };

  /*DateTime getDateTime() {
    print('getDateTime >> ${(Utiles.format).parse(createdDate)}');
    return (Utiles.format).parse(createdDate);
  }*/
}
