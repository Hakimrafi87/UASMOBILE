// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradeAdapter extends TypeAdapter<Grade> {
  @override
  final int typeId = 4;

  @override
  Grade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Grade(
      nisStudent: fields[0] as String,
      mataPelajaran: fields[1] as String,
      nilaiTugas: fields[2] as double,
      nilaiUts: fields[3] as double,
      nilaiUas: fields[4] as double,
      guruInputNama: fields[5] as String,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Grade obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.nisStudent)
      ..writeByte(1)
      ..write(obj.mataPelajaran)
      ..writeByte(2)
      ..write(obj.nilaiTugas)
      ..writeByte(3)
      ..write(obj.nilaiUts)
      ..writeByte(4)
      ..write(obj.nilaiUas)
      ..writeByte(5)
      ..write(obj.guruInputNama)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
