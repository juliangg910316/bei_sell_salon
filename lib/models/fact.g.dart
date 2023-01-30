// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FactSalonAdapter extends TypeAdapter<FactSalon> {
  @override
  final int typeId = 0;

  @override
  FactSalon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FactSalon(
      createdDate: fields[0] as String,
      fact: fields[1] as int,
      profit: fields[2] as int,
      description: fields[3] as String,
      salary: (fields[4] as Map).cast<String, int>(),
      inversion: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FactSalon obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.createdDate)
      ..writeByte(1)
      ..write(obj.fact)
      ..writeByte(2)
      ..write(obj.profit)
      ..writeByte(5)
      ..write(obj.inversion)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.salary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FactSalonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
