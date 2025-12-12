import 'package:hive/hive.dart';

part 'schedule.g.dart';

@HiveType(typeId: 3)
class Schedule extends HiveObject {
  @HiveField(0)
  String hari;
  
  @HiveField(1)
  String jamMulai;
  
  @HiveField(2)
  String jamSelesai;
  
  @HiveField(3)
  String mataPelajaran;
  
  @HiveField(4)
  String guruPengampu; // nama guru
  
  @HiveField(5)
  String kelas;
  
  @HiveField(6)
  DateTime createdAt;

  Schedule({
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.mataPelajaran,
    required this.guruPengampu,
    required this.kelas,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      hari: map['hari'],
      jamMulai: map['jamMulai'],
      jamSelesai: map['jamSelesai'],
      mataPelajaran: map['mataPelajaran'],
      guruPengampu: map['guruPengampu'],
      kelas: map['kelas'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hari': hari,
      'jamMulai': jamMulai,
      'jamSelesai': jamSelesai,
      'mataPelajaran': mataPelajaran,
      'guruPengampu': guruPengampu,
      'kelas': kelas,
      'createdAt': createdAt,
    };
  }
}
