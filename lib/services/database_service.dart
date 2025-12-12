import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/schedule.dart';
import '../models/grade.dart';
import '../models/announcement.dart';

class DatabaseService {
  static const String usersBox = 'users';
  static const String studentsBox = 'students';
  static const String teachersBox = 'teachers';
  static const String schedulesBox = 'schedules';
  static const String gradesBox = 'grades';
  static const String announcementsBox = 'announcements';
  static const String currentUserBox = 'currentUser';

  // Get boxes
  static Future<Box<User>> getUsersBox() async {
    return Hive.box<User>(usersBox);
  }

  static Future<Box<Student>> getStudentsBox() async {
    return Hive.box<Student>(studentsBox);
  }

  static Future<Box<Teacher>> getTeachersBox() async {
    return Hive.box<Teacher>(teachersBox);
  }

  static Future<Box<Schedule>> getSchedulesBox() async {
    return Hive.box<Schedule>(schedulesBox);
  }

  static Future<Box<Grade>> getGradesBox() async {
    return Hive.box<Grade>(gradesBox);
  }

  static Future<Box<Announcement>> getAnnouncementsBox() async {
    return Hive.box<Announcement>(announcementsBox);
  }

  static Future<Box> getCurrentUserBox() async {
    return Hive.box(currentUserBox);
  }

  // User operations
  static Future<void> createUser(User user) async {
    final box = await getUsersBox();
    await box.put(user.username, user);
  }

  static Future<User?> getUserByUsername(String username) async {
    final box = await getUsersBox();
    return box.get(username);
  }

  static Future<List<User>> getAllUsers() async {
    final box = await getUsersBox();
    return box.values.toList();
  }

  static Future<void> updateUser(String username, User user) async {
    final box = await getUsersBox();
    await box.put(username, user);
  }

  static Future<void> deleteUser(String username) async {
    final box = await getUsersBox();
    await box.delete(username);
  }

  // Student operations
  static Future<void> createStudent(Student student) async {
    final box = await getStudentsBox();
    await box.put(student.nis, student);
  }

  static Future<Student?> getStudentByNis(String nis) async {
    final box = await getStudentsBox();
    return box.get(nis);
  }

  static Future<List<Student>> getAllStudents() async {
    final box = await getStudentsBox();
    return box.values.toList();
  }

  static Future<void> updateStudent(String nis, Student student) async {
    final box = await getStudentsBox();
    await box.put(nis, student);
  }

  static Future<void> deleteStudent(String nis) async {
    final box = await getStudentsBox();
    await box.delete(nis);
  }

  // Teacher operations
  static Future<void> createTeacher(Teacher teacher) async {
    final box = await getTeachersBox();
    await box.put(teacher.nip, teacher);
  }

  static Future<Teacher?> getTeacherByNip(String nip) async {
    final box = await getTeachersBox();
    return box.get(nip);
  }

  static Future<List<Teacher>> getAllTeachers() async {
    final box = await getTeachersBox();
    return box.values.toList();
  }

  static Future<void> updateTeacher(String nip, Teacher teacher) async {
    final box = await getTeachersBox();
    await box.put(nip, teacher);
  }

  static Future<void> deleteTeacher(String nip) async {
    final box = await getTeachersBox();
    await box.delete(nip);
  }

  // Schedule operations
  static Future<void> createSchedule(Schedule schedule) async {
    final box = await getSchedulesBox();
    await box.add(schedule);
  }

  static Future<List<Schedule>> getAllSchedules() async {
    final box = await getSchedulesBox();
    return box.values.toList();
  }

  static Future<List<Schedule>> getSchedulesByKelas(String kelas) async {
    final box = await getSchedulesBox();
    return box.values
        .where((schedule) => schedule.kelas == kelas)
        .toList();
  }

  static Future<void> updateSchedule(int index, Schedule schedule) async {
    final box = await getSchedulesBox();
    await box.putAt(index, schedule);
  }

  static Future<void> deleteSchedule(int index) async {
    final box = await getSchedulesBox();
    await box.deleteAt(index);
  }

  // Grade operations
  static Future<void> createGrade(Grade grade) async {
    final box = await getGradesBox();
    
    // Check if grade already exists for this student and subject
    final existingIndex = box.values.toList().indexWhere(
      (g) => g.nisStudent == grade.nisStudent && 
             g.mataPelajaran == grade.mataPelajaran
    );
    
    if (existingIndex != -1) {
      // Update existing grade
      grade.updatedAt = DateTime.now();
      await box.putAt(existingIndex, grade);
    } else {
      // Create new grade
      await box.add(grade);
    }
  }

  static Future<List<Grade>> getGradesByStudent(String nis) async {
    final box = await getGradesBox();
    return box.values
        .where((grade) => grade.nisStudent == nis)
        .toList();
  }

  static Future<List<Grade>> getGradesByMataPelajaran(String mataPelajaran) async {
    final box = await getGradesBox();
    return box.values
        .where((grade) => grade.mataPelajaran == mataPelajaran)
        .toList();
  }

  static Future<List<Grade>> getAllGrades() async {
    final box = await getGradesBox();
    return box.values.toList();
  }

  static Future<void> deleteGrade(int index) async {
    final box = await getGradesBox();
    await box.deleteAt(index);
  }

  // Announcement operations
  static Future<void> createAnnouncement(Announcement announcement) async {
    final box = await getAnnouncementsBox();
    await box.add(announcement);
  }

  static Future<List<Announcement>> getAllAnnouncements() async {
    final box = await getAnnouncementsBox();
    return box.values.toList().reversed.toList(); // Latest first
  }

  static Future<void> updateAnnouncement(int index, Announcement announcement) async {
    final box = await getAnnouncementsBox();
    announcement.updatedAt = DateTime.now();
    await box.putAt(index, announcement);
  }

  static Future<void> deleteAnnouncement(int index) async {
    final box = await getAnnouncementsBox();
    await box.deleteAt(index);
  }

  // Current user session
  static Future<void> setCurrentUser(String username, String role) async {
    final box = await getCurrentUserBox();
    await box.put('username', username);
    await box.put('role', role);
  }

  static Future<Map<String, String?>> getCurrentUser() async {
    final box = await getCurrentUserBox();
    return {
      'username': box.get('username'),
      'role': box.get('role'),
    };
  }

  static Future<void> logout() async {
    final box = await getCurrentUserBox();
    await box.delete('username');
    await box.delete('role');
  }
}
