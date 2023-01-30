import 'package:hive/hive.dart';

part 'turn.g.dart';

@HiveType(typeId: 3)
class Turn extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final int pay;
  @HiveField(3)
  final int value; //! valor del turno, o sea, turno 1, 2, 3, ....

  Turn(this.name, this.date, this.pay, this.value);

  @override
  String toString() =>
      '{name : $name , date : $date, pay : $pay, value: $value}';

  static Turn fromJson(Map<String, dynamic> json) {
    List<String> sDate = json['date'].split(' ');
    print('fecha = ${sDate[0]}');
    List<String> sFecha = sDate[0].split('-');
    print('hora = ${sDate[1]}');
    String hora = '0';
    if (json['name'] != 'Descanso') {
      hora = sDate[1].split(':')[0];
      if (hora == '00') {
        hora = '08';
      }
    }
    print('hora = $hora');
    return Turn(
        json['name'],
        DateTime(int.parse(sFecha[0]), int.parse(sFecha[1]),
            int.parse(sFecha[2]), int.parse(hora)),
        json['pay'],
        json['value']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date.toString(),
        'pay': pay,
        'value': value,
      };
}
