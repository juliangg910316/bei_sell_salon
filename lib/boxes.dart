import 'package:bei_sell/models/costs.dart';
import 'package:bei_sell/models/fact.dart';
import 'package:bei_sell/models/product.dart';
import 'package:bei_sell/models/turn.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<FactSalon> getFactSalon() => Hive.box<FactSalon>('fact_salon');

  static Box<CostsSalon> getCosts() => Hive.box<CostsSalon>('costs');

  static Box<Product> getProduct() => Hive.box<Product>('products');

  static Box<Turn> getTurn() => Hive.box<Turn>('turn');
}
