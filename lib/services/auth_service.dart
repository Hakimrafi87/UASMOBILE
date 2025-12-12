import '../models/user.dart';
import 'database_service.dart';

class AuthService {
  // Login dengan username dan password
  static Future<User?> login(String username, String password) async {
    try {
      final user = await DatabaseService.getUserByUsername(username);
      
      if (user != null && user.password == password) {
        // Save session
        await DatabaseService.setCurrentUser(username, user.role);
        return user;
      }
      
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Register user (hanya admin yang bisa membuat user baru)
  static Future<bool> registerUser({
    required String username,
    required String password,
    required String role,
    required String name,
    String? email,
    String? phone,
  }) async {
    try {
      // Check if user already exists
      final existingUser = await DatabaseService.getUserByUsername(username);
      if (existingUser != null) {
        return false; // User already exists
      }

      final newUser = User(
        username: username,
        password: password,
        role: role,
        name: name,
        email: email,
        phone: phone,
      );

      await DatabaseService.createUser(newUser);
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  // Get current logged in user
  static Future<User?> getCurrentUser() async {
    try {
      final currentData = await DatabaseService.getCurrentUser();
      final username = currentData['username'];
      
      if (username != null) {
        return await DatabaseService.getUserByUsername(username);
      }
      
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      await DatabaseService.logout();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final currentData = await DatabaseService.getCurrentUser();
      return currentData['username'] != null;
    } catch (e) {
      return false;
    }
  }

  // Update user profile
  static Future<bool> updateUserProfile({
    required String username,
    String? email,
    String? phone,
    String? password,
  }) async {
    try {
      final user = await DatabaseService.getUserByUsername(username);
      if (user == null) return false;

      if (email != null) user.email = email;
      if (phone != null) user.phone = phone;
      if (password != null) user.password = password;

      await DatabaseService.updateUser(username, user);
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  // Get all users by role
  static Future<List<User>> getUsersByRole(String role) async {
    try {
      final allUsers = await DatabaseService.getAllUsers();
      return allUsers.where((user) => user.role == role).toList();
    } catch (e) {
      print('Get users by role error: $e');
      return [];
    }
  }
}
