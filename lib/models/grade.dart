import 'package:hive/hive.dart';

part 'grade.g.dart';

@HiveType(typeId: 4)
class Grade extends HiveObject {
  @HiveField(0)
  String nisStudent;
  
  @HiveField(1)
  String mataPelajaran;
  
  @HiveField(2)
  double nilaiTugas;
  
  @HiveField(3)
  double nilaiUts;
  
  @HiveField(4)
  double nilaiUas;
  
  @HiveField(5)
  String guruInputNama;
  
  @HiveField(6)
  DateTime createdAt;
  
  @HiveField(7)
  DateTime? updatedAt;

  Grade({
    required this.nisStudent,
    required this.mataPelajaran,
    required this.nilaiTugas,
    required this.nilaiUts,
    required this.nilaiUas,
    required this.guruInputNama,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt;

  // Hitung nilai akhir: (Tugas * 30%) + (UTS * 30%) + (UAS * 40%)
  double get nilaiAkhir {
    return (nilaiTugas * 0.3) + (nilaiUts * 0.3) + (nilaiUas * 0.4);
  }

  // Konversi ke predikat
  String get predikat {
    final nilai = nilaiAkhir;
    if (nilai >= 85) return 'A';
    if (nilai >= 75) return 'B';
    if (nilai >= 65) return 'C';
    return 'D';
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      nisStudent: map['nisStudent'],
      mataPelajaran: map['mataPelajaran'],
      nilaiTugas: (map['nilaiTugas'] as num).toDouble(),
      nilaiUts: (map['nilaiUts'] as num).toDouble(),
      nilaiUas: (map['nilaiUas'] as num).toDouble(),
      guruInputNama: map['guruInputNama'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nisStudent': nisStudent,
      'mataPelajaran': mataPelajaran,
      'nilaiTugas': nilaiTugas,
      'nilaiUts': nilaiUts,
      'nilaiUas': nilaiUas,
      'guruInputNama': guruInputNama,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
