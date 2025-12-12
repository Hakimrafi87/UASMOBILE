# Sistem Informasi Akademik Sekolah - Flutter

Aplikasi Flutter untuk mengelola data akademik sekolah dengan fitur lengkap untuk Admin, Guru, dan Siswa.

## Fitur Utama

### 1. **Autentikasi & Role-Based Access**
- 3 role pengguna: Admin, Guru, Siswa
- Login dengan username dan password
- Registrasi akun baru (Guru dan Siswa)
- Admin adalah superuser yang membuat akun pertama
- Default admin account: `username: admin`, `password: admin123`

### 2. **Admin Dashboard**
- **Manajemen Data Siswa**: CRUD operasi untuk NIS, Nama, Kelas, Jurusan
- **Manajemen Data Guru**: CRUD operasi untuk NIP, Nama, Mata Pelajaran
- **Manajemen Jadwal**: CRUD jadwal pelajaran per hari, jam, kelas, guru pengampu
- **Manajemen Pengumuman**: Buat, edit, hapus pengumuman untuk seluruh sekolah
- **Dashboard Statistik**: Tampilan ringkas data siswa, guru, jadwal, dan pengumuman

### 3. **Guru Dashboard**
- **Input Nilai Siswa**: Input nilai tugas (30%), UTS (30%), UAS (40%)
- **Perhitungan Otomatis**: Sistem menghitung nilai akhir dengan formula
- **Konversi Predikat**: Nilai dikonversi ke predikat (A, B, C, D)
- **Lihat Pengumuman**: Guru dapat membaca pengumuman dari admin

### 4. **Siswa Dashboard**
- **Lihat Rapor**: Melihat nilai per mata pelajaran
- **Detail Nilai**: Tugas, UTS, UAS, Nilai Akhir, dan Predikat
- **Export PDF**: Export rapor ke file PDF
- **Lihat Jadwal**: Melihat jadwal pelajaran
- **Lihat Pengumuman**: Membaca pengumuman dari admin

### 5. **Data Lokal**
- Menggunakan Hive sebagai local database
- Data disimpan secara offline
- Tidak memerlukan koneksi internet untuk operasi data

## Struktur Project

```
lib/
├── models/              # Data models dengan Hive annotations
│   ├── user.dart
│   ├── student.dart
│   ├── teacher.dart
│   ├── schedule.dart
│   ├── grade.dart
│   └── announcement.dart
├── services/            # Business logic services
│   ├── auth_service.dart
│   └── database_service.dart
├── screens/             # UI screens
│   ├── login_page.dart
│   ├── admin_dashboard.dart
│   ├── teacher_dashboard.dart
│   └── student_dashboard.dart
├── utils/               # Utility functions dan themes
│   ├── app_theme.dart
│   └── helpers.dart
└── main.dart            # App entry point
```

## Instalasi & Setup

### 1. **Install Dependencies**
```bash
flutter pub get
```

### 2. **Generate Hive Adapters**
```bash
flutter pub run build_runner build
```
Atau untuk development dengan auto-regenerate:
```bash
flutter pub run build_runner watch
```

### 3. **Run Aplikasi**
```bash
flutter run
```

## Rumus Perhitungan Nilai

```
Nilai Akhir = (Tugas × 30%) + (UTS × 30%) + (UAS × 40%)
```

### Konversi Predikat
- **A**: ≥ 85
- **B**: 75 – 84
- **C**: 65 – 74
- **D**: < 65

## Panduan Penggunaan

### Admin
1. Login dengan `admin` / `admin123`
2. Di Dashboard, bisa mengakses menu:
   - Data Siswa: Tambah, edit, hapus siswa
   - Data Guru: Tambah, edit, hapus guru
   - Jadwal: Tambah jadwal pelajaran
   - Pengumuman: Buat dan kelola pengumuman

### Guru
1. Daftar sebagai Guru di halaman login
2. Login dengan akun guru
3. Pilih menu "Input Nilai"
4. Pilih siswa dan input nilai (Tugas, UTS, UAS)
5. Sistem otomatis menghitung nilai akhir
6. Lihat pengumuman di menu "Pengumuman"

### Siswa
1. Daftar sebagai Siswa di halaman login
2. Login dengan akun siswa
3. Akses menu "Rapor Saya" untuk melihat nilai
4. Klik tombol download untuk export PDF
5. Lihat jadwal pelajaran dan pengumuman

## Access Control

| Fitur | Admin | Guru | Siswa |
|-------|-------|------|-------|
| CRUD Data Siswa | ✓ | ✗ | ✗ |
| CRUD Data Guru | ✓ | ✗ | ✗ |
| CRUD Jadwal | ✓ | ✗ | ✗ |
| CRUD Pengumuman | ✓ | ✗ | ✗ |
| Input Nilai | ✗ | ✓ | ✗ |
| Lihat Rapor | ✗ | ✗ | ✓ |
| Export PDF Rapor | ✗ | ✗ | ✓ |
| Lihat Pengumuman | ✓ | ✓ | ✓ |
| Lihat Jadwal | ✓ | ✓ | ✓ |

## Dependencies

- `flutter`: SDK Flutter
- `hive`: Local database
- `hive_flutter`: Hive integration untuk Flutter
- `hive_generator`: Auto-generate Hive adapters
- `build_runner`: Code generation tool
- `pdf`: Membuat PDF files
- `printing`: Preview dan share PDF
- `intl`: Date/time formatting
- `provider`: State management

## Database Schema

### Users (Login & Role)
- username (primary key)
- password
- role (admin, guru, siswa)
- name
- email
- phone
- createdAt

### Students
- nis (primary key)
- name
- kelas
- jurusan
- createdAt

### Teachers
- nip (primary key)
- name
- mataPelajaran
- createdAt

### Schedules
- hari
- jamMulai
- jamSelesai
- mataPelajaran
- guruPengampu
- kelas
- createdAt

### Grades
- nisStudent (foreign key -> Students)
- mataPelajaran
- nilaiTugas
- nilaiUts
- nilaiUas
- guruInputNama
- createdAt
- updatedAt

### Announcements
- judul
- isi
- adminNama
- createdAt
- updatedAt

## Troubleshooting

### Error: "Target of URI hasn't been generated"
Jalankan: `flutter pub run build_runner build`

### Data tidak tersimpan
Pastikan Hive boxes sudah di-initialize di main.dart

### Error pada PDF export
Pastikan permission untuk write file sudah diberikan

## Kontribusi

Untuk pengembangan lebih lanjut:
1. Tambah fitur authentication lebih aman (hash password)
2. Tambah backup dan restore database
3. Tambah search dan filter data
4. Tambah export data ke Excel
5. Sync dengan server backend (API)

## License

MIT License - Proyek Akhir Pemrograman Mobile Menggunakan Flutter
