import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user.dart';
import 'models/student.dart';
import 'models/teacher.dart';
import 'models/schedule.dart';
import 'models/grade.dart';
import 'models/announcement.dart';
import 'services/auth_service.dart';
import 'screens/login_page.dart';
import 'screens/admin_dashboard.dart';
import 'screens/teacher_dashboard.dart';
import 'screens/student_dashboard.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters (auto-generated from build_runner)
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(TeacherAdapter());
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(GradeAdapter());
  Hive.registerAdapter(AnnouncementAdapter());
  
  // Open boxes
  await Hive.openBox<User>('users');
  await Hive.openBox<Student>('students');
  await Hive.openBox<Teacher>('teachers');
  await Hive.openBox<Schedule>('schedules');
  await Hive.openBox<Grade>('grades');
  await Hive.openBox<Announcement>('announcements');
  await Hive.openBox('currentUser');
  
  // Create default admin account if no users exist
  final usersBox = await Hive.openBox<User>('users');
  if (usersBox.isEmpty) {
    final adminUser = User(
      username: 'admin',
      password: 'admin123',
      role: 'admin',
      name: 'Administrator',
      email: 'admin@sekolah.com',
    );
    await usersBox.put('admin', adminUser);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark theme

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark 
          ? ThemeMode.light 
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SISTEM AKADEMIK',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: AppWrapper(
        onThemeToggle: _toggleTheme,
        currentThemeMode: _themeMode,
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final ThemeMode currentThemeMode;
  
  const AppWrapper({
    Key? key,
    required this.onThemeToggle,
    required this.currentThemeMode,
  }) : super(key: key);

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _isLoading = true;
  User? _currentUser;
  String? _currentRole;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    setState(() {
      _isLoading = true;
    });

    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      final user = await AuthService.getCurrentUser();
      if (mounted && user != null) {
        setState(() {
          _currentUser = user;
          _currentRole = user.role;
          _isLoading = false;
        });
        return;
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleLoginSuccess(User user, String role) {
    setState(() {
      _currentUser = user;
      _currentRole = role;
    });
  }

  void _handleLogout() {
    setState(() {
      _currentUser = null;
      _currentRole = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking login status
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'LOADING...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // If no user is logged in, show login page
    if (_currentUser == null) {
      return LoginPage(
        onLoginSuccess: _handleLoginSuccess,
        onThemeToggle: widget.onThemeToggle,
        currentThemeMode: widget.currentThemeMode,
      );
    }

    // Route to appropriate dashboard based on role
    switch (_currentRole) {
      case 'admin':
        return AdminDashboard(
          currentUser: _currentUser!,
          onLogout: _handleLogout,
          onThemeToggle: widget.onThemeToggle,
          currentThemeMode: widget.currentThemeMode,
        );
      case 'guru':
        return TeacherDashboard(
          currentUser: _currentUser!,
          onLogout: _handleLogout,
          onThemeToggle: widget.onThemeToggle,
          currentThemeMode: widget.currentThemeMode,
        );
      case 'siswa':
        return StudentDashboard(
          currentUser: _currentUser!,
          onLogout: _handleLogout,
          onThemeToggle: widget.onThemeToggle,
          currentThemeMode: widget.currentThemeMode,
        );
      default:
        return LoginPage(
          onLoginSuccess: _handleLoginSuccess,
          onThemeToggle: widget.onThemeToggle,
          currentThemeMode: widget.currentThemeMode,
        );
    }
  }
}
