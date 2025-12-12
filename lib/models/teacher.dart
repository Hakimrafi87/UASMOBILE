import 'package:hive/hive.dart';

part 'teacher.g.dart';

@HiveType(typeId: 2)
class Teacher extends HiveObject {
  @HiveField(0)
  String nip;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String mataPelajaran;
  
  @HiveField(3)
  DateTime createdAt;

  Teacher({
    required this.nip,
    required this.name,
    required this.mataPelajaran,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      nip: map['nip'],
      name: map['name'],
      mataPelajaran: map['mataPelajaran'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nip': nip,
      'name': name,
      'mataPelajaran': mataPelajaran,
      'createdAt': createdAt,
    };
  }
}
