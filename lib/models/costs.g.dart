// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'costs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CostsSalonAdapter extends TypeAdapter<CostsSalon> {
  @override
  final int typeId = 1;

  @override
  CostsSalon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CostsSalon(
      createdDate: fields[0] as String,
      cost: fields[1] as int,
      prod: fields[2] as String,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CostsSalon obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.createdDate)
      ..writeByte(1)
      ..write(obj.cost)
      ..writeByte(2)
      ..write(obj.prod)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostsSalonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
