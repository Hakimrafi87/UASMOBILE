import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/student.dart';
import '../models/grade.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../utils/trading_widgets.dart';

class TeacherDashboard extends StatefulWidget {
  final User currentUser;
  final Function() onLogout;
  final VoidCallback onThemeToggle;
  final ThemeMode currentThemeMode;

  const TeacherDashboard({
    Key? key,
    required this.currentUser,
    required this.onLogout,
    required this.onThemeToggle,
    required this.currentThemeMode,
  }) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'label': 'Dashboard',
      'icon': Icons.dashboard,
    },
    {
      'label': 'Input Nilai',
      'icon': Icons.grade,
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
        title: 'Teacher Dashboard',
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
        userRole: 'GURU',
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
        return const GradeInputPage();
      case 2:
        return const AnnouncementViewPage();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return FutureBuilder(
      future: Future.wait([
        DatabaseService.getAllStudents(),
        DatabaseService.getAllGrades(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final students = snapshot.data?[0] as List? ?? [];
        final allGrades = snapshot.data?[1] as List? ?? [];

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
                    title: 'Nilai Terisi',
                    count: allGrades.length,
                    icon: Icons.grade,
                    color: Colors.orange,
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

// Grade Input Page
class GradeInputPage extends StatefulWidget {
  const GradeInputPage({Key? key}) : super(key: key);

  @override
  State<GradeInputPage> createState() => _GradeInputPageState();
}

class _GradeInputPageState extends State<GradeInputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Nilai')),
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
                  subtitle: Text('NIS: ${student.nis}'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                    ),
                    onPressed: () => _openGradeForm(context, student),
                    child: const Text('Input Nilai'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openGradeForm(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (context) => GradeFormDialog(
        student: student,
        guruNama: (context.findAncestorWidgetOfExactType<TeacherDashboard>()
                ?.currentUser
                .name) ??
            'Unknown',
        onSave: (mataPelajaran, nilaiTugas, nilaiUts, nilaiUas) async {
          await DatabaseService.createGrade(
            Grade(
              nisStudent: student.nis,
              mataPelajaran: mataPelajaran,
              nilaiTugas: nilaiTugas,
              nilaiUts: nilaiUts,
              nilaiUas: nilaiUas,
              guruInputNama: (context.findAncestorWidgetOfExactType<TeacherDashboard>()
                      ?.currentUser
                      .name) ??
                  'Unknown',
            ),
          );
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nilai berhasil disimpan')),
            );
          }
        },
      ),
    );
  }
}

class GradeFormDialog extends StatefulWidget {
  final Student student;
  final String guruNama;
  final Function(String, double, double, double) onSave;

  const GradeFormDialog({
    Key? key,
    required this.student,
    required this.guruNama,
    required this.onSave,
  }) : super(key: key);

  @override
  State<GradeFormDialog> createState() => _GradeFormDialogState();
}

class _GradeFormDialogState extends State<GradeFormDialog> {
  late TextEditingController _mataPelajaranController;
  late TextEditingController _nilaiTugasController;
  late TextEditingController _nilaiUtsController;
  late TextEditingController _nilaiUasController;

  @override
  void initState() {
    super.initState();
    _mataPelajaranController = TextEditingController();
    _nilaiTugasController = TextEditingController();
    _nilaiUtsController = TextEditingController();
    _nilaiUasController = TextEditingController();
  }

  @override
  void dispose() {
    _mataPelajaranController.dispose();
    _nilaiTugasController.dispose();
    _nilaiUtsController.dispose();
    _nilaiUasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Input Nilai - ${widget.student.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _mataPelajaranController,
              decoration: const InputDecoration(labelText: 'Mata Pelajaran'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nilaiTugasController,
              decoration: const InputDecoration(labelText: 'Nilai Tugas (0-100)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nilaiUtsController,
              decoration: const InputDecoration(labelText: 'Nilai UTS (0-100)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nilaiUasController,
              decoration: const InputDecoration(labelText: 'Nilai UAS (0-100)'),
              keyboardType: TextInputType.number,
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
          onPressed: () {
            try {
              final tugas = double.parse(_nilaiTugasController.text);
              final uts = double.parse(_nilaiUtsController.text);
              final uas = double.parse(_nilaiUasController.text);

              if (tugas < 0 || tugas > 100 || uts < 0 || uts > 100 || uas < 0 || uas > 100) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nilai harus antara 0-100')),
                );
                return;
              }

              widget.onSave(
                _mataPelajaranController.text,
                tugas,
                uts,
                uas,
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Input nilai tidak valid')),
              );
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

// Announcement View Page
class AnnouncementViewPage extends StatefulWidget {
  const AnnouncementViewPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementViewPage> createState() => _AnnouncementViewPageState();
}

class _AnnouncementViewPageState extends State<AnnouncementViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengumuman')),
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
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.judul,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(announcement.isi),
                      const SizedBox(height: 8),
                      Text(
                        'Dari: ${announcement.adminNama}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
