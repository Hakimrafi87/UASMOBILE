import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String username;
  
  @HiveField(1)
  String password;
  
  @HiveField(2)
  String role; // admin, guru, siswa
  
  @HiveField(3)
  String name;
  
  @HiveField(4)
  String? email;
  
  @HiveField(5)
  String? phone;
  
  @HiveField(6)
  DateTime createdAt;

  User({
    required this.username,
    required this.password,
    required this.role,
    required this.name,
    this.email,
    this.phone,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
      role: map['role'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'role': role,
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': createdAt,
    };
  }
}
