import 'package:hive/hive.dart';

part 'costs.g.dart';

@HiveType(typeId: 1)
class CostsSalon extends HiveObject {
  @HiveField(0)
  String createdDate;

  @HiveField(1)
  int cost;

  @HiveField(2)
  String prod;

  @HiveField(3)
  String description;

  CostsSalon({
    required this.createdDate,
    required this.cost,
    required this.prod,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'createdDate': createdDate,
        'gasto': cost,
        'producto': prod,
        'description': description,
      };

  // DateTime getDateTime() {
  //   print('getDateTime >> ${(Utiles.format).parse(createdDate)}');
  //   return (Utiles.format).parse(createdDate);
  // }
}
