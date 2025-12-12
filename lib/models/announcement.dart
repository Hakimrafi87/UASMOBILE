import 'package:hive/hive.dart';

part 'announcement.g.dart';

@HiveType(typeId: 5)
class Announcement extends HiveObject {
  @HiveField(0)
  String judul;
  
  @HiveField(1)
  String isi;
  
  @HiveField(2)
  String adminNama;
  
  @HiveField(3)
  DateTime createdAt;
  
  @HiveField(4)
  DateTime? updatedAt;

  Announcement({
    required this.judul,
    required this.isi,
    required this.adminNama,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt;

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      judul: map['judul'],
      isi: map['isi'],
      adminNama: map['adminNama'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'isi': isi,
      'adminNama': adminNama,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
