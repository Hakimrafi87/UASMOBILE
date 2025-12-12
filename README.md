# 📱 Sistem Informasi Sekolah (Mobile App)

Aplikasi mobile manajemen data akademik sekolah yang dibangun menggunakan **Flutter**. Aplikasi ini dirancang untuk memfasilitasi interaksi antara Admin, Guru, dan Siswa dengan fokus pada manajemen nilai, jadwal, dan pengumuman secara efisien menggunakan penyimpanan data lokal.

## 🌟 Fitur Utama

Aplikasi ini memiliki sistem **Role-Based Access Control (RBAC)** dengan 3 peran pengguna:

### 1. 🛡️ Admin (Administrator)
* **Manajemen Pengguna:** Membuat akun untuk Guru dan Siswa (Username & Password).
* **Master Data:** CRUD (Create, Read, Update, Delete) data Siswa dan Guru.
* **Manajemen Jadwal:** Mengatur jadwal mata pelajaran per kelas.
* **Pengumuman:** Membuat informasi yang akan tampil di dashboard Guru dan Siswa.
* **Dashboard Statistik:** Melihat ringkasan jumlah siswa, guru, dan aktivitas.

### 2. 👨‍🏫 Guru (Teacher)
* **Input Nilai:** Memasukkan nilai Tugas, UTS, dan UAS untuk siswa.
* **Kalkulasi Otomatis:** Sistem menghitung Nilai Akhir dan Predikat (A/B/C/D) secara real-time.
* **Akses Data:** Melihat daftar siswa yang diajar.
* **Informasi:** Menerima pengumuman dari Admin.

### 3. 👨‍🎓 Siswa (Student)
* **Rapor Digital:** Melihat hasil nilai akademik dan predikat secara detail.
* **Export PDF:** Mengunduh laporan nilai (Rapor) dalam format PDF.
* **Jadwal Pelajaran:** Melihat jadwal kelas pribadi.
* **Informasi:** Menerima pengumuman sekolah.

---

## 🛠️ Teknologi yang Digunakan

* **Framework:** [Flutter](https://flutter.dev) (Dart SDK >=3.9.0)
* **Database Lokal:** [Hive](https://pub.dev/packages/hive) (NoSQL cepat & ringan, tanpa koneksi internet).
* **State Management:** `setState` & `FutureBuilder` (Native).
* **PDF Generation:** `pdf` & `printing`.
* **UI/UX:** Custom Theme terinspirasi dari aplikasi Trading/Fintech (Mode Gelap & Terang).

---

## 📡 Daftar Layanan Data (Internal API Endpoints)

Aplikasi ini bersifat **Offline-First** dan menggunakan **Database Service** sebagai jembatan data. Berikut adalah daftar fungsi internal yang bertindak sebagai "Endpoint" untuk memanipulasi data di Hive Box:

### 🔐 Authentication Service (`AuthService`)
| Fungsi / Aksi | Deskripsi | Parameter |
| :--- | :--- | :--- |
| `login` | Autentikasi user | `username`, `password` |
| `registerUser` | Mendaftarkan akun baru (Admin Only) | `username`, `password`, `role`, `name`, dll |
| `isLoggedIn` | Cek status sesi login | - |
| `logout` | Menghapus sesi aktif | - |

### 👤 User & Data Service (`DatabaseService`)

#### 1. Data Siswa (Students)
| Aksi (CRUD) | Fungsi Internal | Keterangan |
| :--- | :--- | :--- |
| **GET** | `getAllStudents()` | Mengambil seluruh daftar siswa |
| **GET** | `getStudentByNis(nis)` | Mengambil detail siswa berdasarkan NIS |
| **POST** | `createStudent(student)` | Menambah data siswa baru |
| **PUT** | `updateStudent(nis, student)` | Memperbarui data siswa |
| **DELETE** | `deleteStudent(nis)` | Menghapus data siswa |

#### 2. Data Guru (Teachers)
| Aksi (CRUD) | Fungsi Internal | Keterangan |
| :--- | :--- | :--- |
| **GET** | `getAllTeachers()` | Mengambil seluruh daftar guru |
| **POST** | `createTeacher(teacher)` | Menambah data guru baru |
| **PUT** | `updateTeacher(nip, teacher)` | Memperbarui data guru |
| **DELETE** | `deleteTeacher(nip)` | Menghapus data guru |

#### 3. Nilai Akademik (Grades)
| Aksi (CRUD) | Fungsi Internal | Keterangan |
| :--- | :--- | :--- |
| **POST** | `createGrade(grade)` | Input nilai (Logika: Update jika ada, Create jika baru) |
| **GET** | `getGradesByStudent(nis)` | Mengambil semua nilai milik satu siswa |
| **GET** | `getAllGrades()` | Mengambil semua rekap nilai (untuk Admin/Guru) |

#### 4. Jadwal (Schedules) & Pengumuman (Announcements)
| Aksi (CRUD) | Fungsi Internal | Keterangan |
| :--- | :--- | :--- |
| **POST** | `createSchedule(schedule)` | Membuat jadwal pelajaran baru |
| **GET** | `getAllSchedules()` | Melihat semua jadwal |
| **POST** | `createAnnouncement(data)` | Membuat pengumuman baru |
| **GET** | `getAllAnnouncements()` | Mengambil daftar pengumuman (LIFO) |

---

## 🚀 Cara Instalasi dan Menjalankan Aplikasi

Ikuti langkah-langkah berikut untuk menjalankan proyek ini di mesin lokal Anda:

### Prasyarat
1.  Pastikan **Flutter SDK** sudah terinstal.
2.  Code Editor (VS Code atau Android Studio).
3.  Emulator Android/iOS atau Device fisik.

### Langkah 1: Clone atau Extract Project
Simpan folder proyek di direktori komputer Anda.

### Langkah 2: Install Dependencies
Buka terminal di folder root proyek dan jalankan:
```bash
flutter pub get
