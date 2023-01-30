// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turn.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TurnAdapter extends TypeAdapter<Turn> {
  @override
  final int typeId = 3;

  @override
  Turn read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Turn(
      fields[0] as String,
      fields[1] as DateTime,
      fields[2] as int,
      fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Turn obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.pay)
      ..writeByte(3)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TurnAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
