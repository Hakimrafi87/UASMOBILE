import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/schedule.dart';
import '../models/announcement.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../utils/trading_widgets.dart';

class AdminDashboard extends StatefulWidget {
  final User currentUser;
  final Function() onLogout;
  final VoidCallback onThemeToggle;
  final ThemeMode currentThemeMode;

  const AdminDashboard({
    Key? key,
    required this.currentUser,
    required this.onLogout,
    required this.onThemeToggle,
    required this.currentThemeMode,
  }) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'label': 'Dashboard',
      'icon': Icons.dashboard,
    },
    {
      'label': 'Data Siswa',
      'icon': Icons.person,
    },
    {
      'label': 'Data Guru',
      'icon': Icons.school,
    },
    {
      'label': 'Jadwal',
      'icon': Icons.schedule,
    },
    {
      'label': 'Pengumuman',
      'icon': Icons.notifications,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TradingAppBar(
        title: 'Admin Dashboard',
        userName: widget.currentUser.name,
        onLogout: () {
          AuthService.logout();
          widget.onLogout();
        },
        onThemeToggle: widget.onThemeToggle,
        currentThemeMode: widget.currentThemeMode,
      ),
      drawer: TradingDrawer(
        userName: widget.currentUser.name,
        userRole: 'ADMIN',
        selectedIndex: _selectedIndex,
        menuItems: _menuItems,
        onMenuItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return const StudentManagementPage();
      case 2:
        return const TeacherManagementPage();
      case 3:
        return const ScheduleManagementPage();
      case 4:
        return const AnnouncementManagementPage();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return FutureBuilder(
      future: Future.wait([
        DatabaseService.getAllStudents(),
        DatabaseService.getAllTeachers(),
        DatabaseService.getAllSchedules(),
        DatabaseService.getAllAnnouncements(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final students = snapshot.data?[0] as List? ?? [];
        final teachers = snapshot.data?[1] as List? ?? [];
        final schedules = snapshot.data?[2] as List? ?? [];
        final announcements = snapshot.data?[3] as List? ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${widget.currentUser.name}!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildStatCard(
                    title: 'Total Siswa',
                    count: students.length,
                    icon: Icons.person,
                    color: Colors.blue,
                  ),
                  _buildStatCard(
                    title: 'Total Guru',
                    count: teachers.length,
                    icon: Icons.school,
                    color: Colors.orange,
                  ),
                  _buildStatCard(
                    title: 'Jadwal',
                    count: schedules.length,
                    icon: Icons.schedule,
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    title: 'Pengumuman',
                    count: announcements.length,
                    icon: Icons.notifications,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Student Management Page
class StudentManagementPage extends StatefulWidget {
  const StudentManagementPage({Key? key}) : super(key: key);

  @override
  State<StudentManagementPage> createState() => _StudentManagementPageState();
}

class _StudentManagementPageState extends State<StudentManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Data Siswa')),
      body: FutureBuilder(
        future: DatabaseService.getAllStudents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data ?? [];

          if (students.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data siswa',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(student.nis[0]),
                  ),
                  title: Text(student.name),
                  subtitle: Text('${student.kelas} - ${student.jurusan}'),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () => _editStudent(context, student),
                      ),
                      PopupMenuItem(
                        child: const Text('Hapus'),
                        onTap: () => _deleteStudent(student.nis),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addStudent(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addStudent(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StudentFormDialog(
        student: null, // Explicitly set to null for add mode
        onSave: (nis, name, kelas, jurusan, username, password) async {
          // Validasi field kosong
          if (nis.isEmpty || name.isEmpty || kelas.isEmpty || jurusan.isEmpty ||
              username.isEmpty || password.isEmpty) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua field harus diisi'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
            return;
          }
          
          // Validasi password minimal 6 karakter
          if (password.length < 6) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password minimal 6 karakter'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
            return;
          }
          
          // Buat student
          await DatabaseService.createStudent(
            Student(
              nis: nis,
              name: name,
              kelas: kelas,
              jurusan: jurusan,
            ),
          );
          
          // Buat user account untuk siswa
          await AuthService.registerUser(
            username: username,
            password: password,
            role: 'siswa',
            name: name,
            email: '',
            phone: '',
          );
          
          setState(() {});
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Siswa $name berhasil ditambahkan dengan username: $username')),
            );
          }
        },
      ),
    );
  }

  void _editStudent(BuildContext context, dynamic student) {
    showDialog(
      context: context,
      builder: (context) => StudentFormDialog(
        student: student,
        onSave: (nis, name, kelas, jurusan) async {
          await DatabaseService.updateStudent(
            student.nis,
            Student(
              nis: nis,
              name: name,
              kelas: kelas,
              jurusan: jurusan,
            ),
          );
          setState(() {});
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteStudent(String nis) async {
    await DatabaseService.deleteStudent(nis);
    setState(() {});
  }
}

class StudentFormDialog extends StatefulWidget {
  final dynamic student;
  final Function onSave;

  const StudentFormDialog({
    Key? key,
    this.student,
    required this.onSave,
  }) : super(key: key);

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  late TextEditingController _nisController;
  late TextEditingController _nameController;
  late TextEditingController _kelasController;
  late TextEditingController _jurusanController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nisController = TextEditingController(text: widget.student?.nis ?? '');
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _kelasController = TextEditingController(text: widget.student?.kelas ?? '');
    _jurusanController = TextEditingController(text: widget.student?.jurusan ?? '');
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nisController.dispose();
    _nameController.dispose();
    _kelasController.dispose();
    _jurusanController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.student == null ? 'Tambah Siswa' : 'Edit Siswa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nisController,
              decoration: const InputDecoration(labelText: 'NIS'),
              enabled: widget.student == null,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _kelasController,
              decoration: const InputDecoration(labelText: 'Kelas'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jurusanController,
              decoration: const InputDecoration(labelText: 'Jurusan'),
            ),
            if (widget.student == null) ...[  
              const Divider(height: 24),
              const Text(
                'Data Login Siswa',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Untuk login siswa',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Minimal 6 karakter',
                ),
                obscureText: true,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.student == null) {
              // Add mode - include username/password
              widget.onSave(
                _nisController.text.trim(),
                _nameController.text.trim(),
                _kelasController.text.trim(),
                _jurusanController.text.trim(),
                _usernameController.text.trim(),
                _passwordController.text,
              );
            } else {
              // Edit mode - no username/password
              widget.onSave(
                _nisController.text.trim(),
                _nameController.text.trim(),
                _kelasController.text.trim(),
                _jurusanController.text.trim(),
              );
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

// Teacher Management Page
class TeacherManagementPage extends StatefulWidget {
  const TeacherManagementPage({Key? key}) : super(key: key);

  @override
  State<TeacherManagementPage> createState() => _TeacherManagementPageState();
}

class _TeacherManagementPageState extends State<TeacherManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Data Guru')),
      body: FutureBuilder(
        future: DatabaseService.getAllTeachers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final teachers = snapshot.data ?? [];

          if (teachers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data guru',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final teacher = teachers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(teacher.nip[0]),
                  ),
                  title: Text(teacher.name),
                  subtitle: Text(teacher.mataPelajaran),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () => _editTeacher(context, teacher),
                      ),
                      PopupMenuItem(
                        child: const Text('Hapus'),
                        onTap: () => _deleteTeacher(teacher.nip),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTeacher(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTeacher(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TeacherFormDialog(
        onSave: (nip, name, mataPelajaran, username, password) async {
          // Validasi
          if (nip.isEmpty || name.isEmpty || mataPelajaran.isEmpty ||
              username.isEmpty || password.isEmpty) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua field harus diisi')),
              );
            }
            return;
          }
          
          // Buat teacher
          await DatabaseService.createTeacher(
            Teacher(
              nip: nip,
              name: name,
              mataPelajaran: mataPelajaran,
            ),
          );
          
          // Buat user account untuk guru
          await AuthService.registerUser(
            username: username,
            password: password,
            role: 'guru',
            name: name,
            email: '',
            phone: '',
          );
          
          setState(() {});
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Guru $name berhasil ditambahkan dengan username: $username')),
            );
          }
        },
      ),
    );
  }

  void _editTeacher(BuildContext context, dynamic teacher) {
    showDialog(
      context: context,
      builder: (context) => TeacherFormDialog(
        teacher: teacher,
        onSave: (nip, name, mataPelajaran) async {
          await DatabaseService.updateTeacher(
            teacher.nip,
            Teacher(
              nip: nip,
              name: name,
              mataPelajaran: mataPelajaran,
            ),
          );
          setState(() {});
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteTeacher(String nip) async {
    await DatabaseService.deleteTeacher(nip);
    setState(() {});
  }
}

class TeacherFormDialog extends StatefulWidget {
  final dynamic teacher;
  final Function onSave;

  const TeacherFormDialog({
    Key? key,
    this.teacher,
    required this.onSave,
  }) : super(key: key);

  @override
  State<TeacherFormDialog> createState() => _TeacherFormDialogState();
}

class _TeacherFormDialogState extends State<TeacherFormDialog> {
  late TextEditingController _nipController;
  late TextEditingController _nameController;
  late TextEditingController _mataPelajaranController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nipController = TextEditingController(text: widget.teacher?.nip ?? '');
    _nameController = TextEditingController(text: widget.teacher?.name ?? '');
    _mataPelajaranController =
        TextEditingController(text: widget.teacher?.mataPelajaran ?? '');
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nipController.dispose();
    _nameController.dispose();
    _mataPelajaranController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.teacher == null ? 'Tambah Guru' : 'Edit Guru'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nipController,
              decoration: const InputDecoration(labelText: 'NIP'),
              enabled: widget.teacher == null,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _mataPelajaranController,
              decoration: const InputDecoration(labelText: 'Mata Pelajaran'),
            ),
            if (widget.teacher == null) ...[  
              const Divider(height: 24),
              const Text(
                'Data Login Guru',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Untuk login guru',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password login guru',
                ),
                obscureText: true,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.teacher == null) {
              // Add mode - include username/password
              widget.onSave(
                _nipController.text,
                _nameController.text,
                _mataPelajaranController.text,
                _usernameController.text,
                _passwordController.text,
              );
            } else {
              // Edit mode - no username/password
              widget.onSave(
                _nipController.text,
                _nameController.text,
                _mataPelajaranController.text,
              );
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

// Schedule Management
class ScheduleManagementPage extends StatefulWidget {
  const ScheduleManagementPage({Key? key}) : super(key: key);

  @override
  State<ScheduleManagementPage> createState() => _ScheduleManagementPageState();
}

class _ScheduleManagementPageState extends State<ScheduleManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Jadwal')),
      body: FutureBuilder(
        future: DatabaseService.getAllSchedules(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final schedules = snapshot.data ?? [];

          if (schedules.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada jadwal',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(schedule.mataPelajaran),
                  subtitle: Text(
                    '${schedule.hari} | ${schedule.jamMulai} - ${schedule.jamSelesai}\nKelas: ${schedule.kelas} | Guru: ${schedule.guruPengampu}',
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () => _editSchedule(context, index, schedule),
                      ),
                      PopupMenuItem(
                        child: const Text('Hapus'),
                        onTap: () => _deleteSchedule(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSchedule(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addSchedule(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ScheduleFormDialog(
        onSave: (hari, jamMulai, jamSelesai, mataPelajaran, guruPengampu, kelas) async {
          await DatabaseService.createSchedule(
            Schedule(
              hari: hari,
              jamMulai: jamMulai,
              jamSelesai: jamSelesai,
              mataPelajaran: mataPelajaran,
              guruPengampu: guruPengampu,
              kelas: kelas,
            ),
          );
          setState(() {});
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }

  void _editSchedule(BuildContext context, int index, dynamic schedule) {
    showDialog(
      context: context,
      builder: (context) => ScheduleFormDialog(
        schedule: schedule,
        onSave: (hari, jamMulai, jamSelesai, mataPelajaran, guruPengampu, kelas) async {
          await DatabaseService.updateSchedule(
            index,
            Schedule(
              hari: hari,
              jamMulai: jamMulai,
              jamSelesai: jamSelesai,
              mataPelajaran: mataPelajaran,
              guruPengampu: guruPengampu,
              kelas: kelas,
            ),
          );
          setState(() {});
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteSchedule(int index) async {
    await DatabaseService.deleteSchedule(index);
    setState(() {});
  }
}

class ScheduleFormDialog extends StatefulWidget {
  final dynamic schedule;
  final Function(String, String, String, String, String, String) onSave;

  const ScheduleFormDialog({
    Key? key,
    this.schedule,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ScheduleFormDialog> createState() => _ScheduleFormDialogState();
}

class _ScheduleFormDialogState extends State<ScheduleFormDialog> {
  late TextEditingController _hariController;
  late TextEditingController _jamMulaiController;
  late TextEditingController _jamSelesaiController;
  late TextEditingController _mataPelajaranController;
  late TextEditingController _guruController;
  late TextEditingController _kelasController;

  final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

  @override
  void initState() {
    super.initState();
    _hariController = TextEditingController(text: widget.schedule?.hari ?? 'Senin');
    _jamMulaiController = TextEditingController(text: widget.schedule?.jamMulai ?? '');
    _jamSelesaiController = TextEditingController(text: widget.schedule?.jamSelesai ?? '');
    _mataPelajaranController =
        TextEditingController(text: widget.schedule?.mataPelajaran ?? '');
    _guruController = TextEditingController(text: widget.schedule?.guruPengampu ?? '');
    _kelasController = TextEditingController(text: widget.schedule?.kelas ?? '');
  }

  @override
  void dispose() {
    _hariController.dispose();
    _jamMulaiController.dispose();
    _jamSelesaiController.dispose();
    _mataPelajaranController.dispose();
    _guruController.dispose();
    _kelasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.schedule == null ? 'Tambah Jadwal' : 'Edit Jadwal'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _hariController.text,
              decoration: const InputDecoration(labelText: 'Hari'),
              items: days.map((day) {
                return DropdownMenuItem(value: day, child: Text(day));
              }).toList(),
              onChanged: (value) {
                if (value != null) _hariController.text = value;
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jamMulaiController,
              decoration: const InputDecoration(labelText: 'Jam Mulai (HH:MM)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jamSelesaiController,
              decoration: const InputDecoration(labelText: 'Jam Selesai (HH:MM)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _mataPelajaranController,
              decoration: const InputDecoration(labelText: 'Mata Pelajaran'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _guruController,
              decoration: const InputDecoration(labelText: 'Nama Guru Pengampu'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _kelasController,
              decoration: const InputDecoration(labelText: 'Kelas'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => widget.onSave(
            _hariController.text,
            _jamMulaiController.text,
            _jamSelesaiController.text,
            _mataPelajaranController.text,
            _guruController.text,
            _kelasController.text,
          ),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

// Announcement Management
class AnnouncementManagementPage extends StatefulWidget {
  const AnnouncementManagementPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementManagementPage> createState() =>
      _AnnouncementManagementPageState();
}

class _AnnouncementManagementPageState extends State<AnnouncementManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Pengumuman')),
      body: FutureBuilder(
        future: DatabaseService.getAllAnnouncements(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final announcements = snapshot.data ?? [];

          if (announcements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada pengumuman',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(announcement.judul),
                  subtitle: Text(
                    announcement.isi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () => _editAnnouncement(context, index, announcement),
                      ),
                      PopupMenuItem(
                        child: const Text('Hapus'),
                        onTap: () => _deleteAnnouncement(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addAnnouncement(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addAnnouncement(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AnnouncementFormDialog(
        onSave: (judul, isi, adminNama) async {
          await DatabaseService.createAnnouncement(
            Announcement(
              judul: judul,
              isi: isi,
              adminNama: adminNama,
            ),
          );
          setState(() {});
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }

  void _editAnnouncement(BuildContext context, int index, dynamic announcement) {
    showDialog(
      context: context,
      builder: (context) => AnnouncementFormDialog(
        announcement: announcement,
        onSave: (judul, isi, adminNama) async {
          await DatabaseService.updateAnnouncement(
            index,
            Announcement(
              judul: judul,
              isi: isi,
              adminNama: adminNama,
            ),
          );
          setState(() {});
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteAnnouncement(int index) async {
    await DatabaseService.deleteAnnouncement(index);
    setState(() {});
  }
}

class AnnouncementFormDialog extends StatefulWidget {
  final dynamic announcement;
  final Function(String, String, String) onSave;

  const AnnouncementFormDialog({
    Key? key,
    this.announcement,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AnnouncementFormDialog> createState() => _AnnouncementFormDialogState();
}

class _AnnouncementFormDialogState extends State<AnnouncementFormDialog> {
  late TextEditingController _judulController;
  late TextEditingController _isiController;
  late TextEditingController _adminNamaController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.announcement?.judul ?? '');
    _isiController = TextEditingController(text: widget.announcement?.isi ?? '');
    _adminNamaController =
        TextEditingController(text: widget.announcement?.adminNama ?? '');
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    _adminNamaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.announcement == null ? 'Tambah Pengumuman' : 'Edit Pengumuman'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _isiController,
              decoration: const InputDecoration(labelText: 'Isi'),
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _adminNamaController,
              decoration: const InputDecoration(labelText: 'Nama Admin'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => widget.onSave(
            _judulController.text,
            _isiController.text,
            _adminNamaController.text,
          ),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}