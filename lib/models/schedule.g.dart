// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleAdapter extends TypeAdapter<Schedule> {
  @override
  final int typeId = 3;

  @override
  Schedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Schedule(
      hari: fields[0] as String,
      jamMulai: fields[1] as String,
      jamSelesai: fields[2] as String,
      mataPelajaran: fields[3] as String,
      guruPengampu: fields[4] as String,
      kelas: fields[5] as String,
      createdAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Schedule obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.hari)
      ..writeByte(1)
      ..write(obj.jamMulai)
      ..writeByte(2)
      ..write(obj.jamSelesai)
      ..writeByte(3)
      ..write(obj.mataPelajaran)
      ..writeByte(4)
      ..write(obj.guruPengampu)
      ..writeByte(5)
      ..write(obj.kelas)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
