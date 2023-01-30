import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 2)
class Product extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double cuantity;

  @HiveField(2)
  String um;

  @HiveField(3)
  double price;

  @HiveField(4)
  String currency;

  @HiveField(5)
  String inversion;

  Product(
      {required this.name,
      required this.cuantity,
      required this.um,
      required this.price,
      required this.currency,
      required this.inversion});
}
