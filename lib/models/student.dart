import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 1)
class Student extends HiveObject {
  @HiveField(0)
  String nis;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String kelas;
  
  @HiveField(3)
  String jurusan;
  
  @HiveField(4)
  DateTime createdAt;

  Student({
    required this.nis,
    required this.name,
    required this.kelas,
    required this.jurusan,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      nis: map['nis'],
      name: map['name'],
      kelas: map['kelas'],
      jurusan: map['jurusan'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nis': nis,
      'name': name,
      'kelas': kelas,
      'jurusan': jurusan,
      'createdAt': createdAt,
    };
  }
}
