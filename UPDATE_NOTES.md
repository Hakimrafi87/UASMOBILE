# 🔄 Update Notes - Konfigurasi Ulang Sistem

**Tanggal:** 12 Desember 2025  
**Versi:** 2.0

## 📋 Perubahan Besar

### 1. ✅ Admin Membuat Akun Guru & Siswa

**SEBELUMNYA:**
- Guru dan siswa daftar sendiri via halaman registrasi
- Admin hanya mengelola data guru/siswa tanpa username/password

**SEKARANG:**
- Admin menambah guru → otomatis buat username & password
- Admin menambah siswa → otomatis buat username & password
- Tidak ada halaman registrasi lagi
- Semua akun dibuat oleh admin

#### Cara Admin Menambah Guru:
1. Login sebagai admin
2. Menu → "Data Guru"
3. Klik tombol "+" (FAB)
4. Isi form:
   - **NIP:** (ID guru)
   - **Nama:** (Nama lengkap)
   - **Mata Pelajaran:** (Mapel yang diajar)
   - **Username:** (Untuk login guru) ← BARU!
   - **Password:** (Password login guru) ← BARU!
5. Klik "Simpan"
6. ✅ Guru berhasil ditambahkan dengan akun login

#### Cara Admin Menambah Siswa:
1. Login sebagai admin
2. Menu → "Data Siswa"
3. Klik tombol "+" (FAB)
4. Isi form:
   - **NIS:** (ID siswa)
   - **Nama:** (Nama lengkap)
   - **Kelas:** (Contoh: XII IPA 1)
   - **Jurusan:** (Contoh: IPA)
   - **Username:** (Untuk login siswa) ← BARU!
   - **Password:** (Password login siswa) ← BARU!
5. Klik "Simpan"
6. ✅ Siswa berhasil ditambahkan dengan akun login

### 2. ✅ Hapus Fitur Registrasi

**SEBELUMNYA:**
- Ada toggle Login/Register
- User bisa daftar sendiri

**SEKARANG:**
- Halaman login saja (no register)
- Pesan: "Hubungi admin untuk membuat akun"
- Semua akun dibuat melalui admin dashboard

### 3. ✅ Guru Input Nilai ke Murid

**SUDAH BENAR SEJAK AWAL:**
- Dashboard guru menampilkan daftar **semua siswa**
- Guru bisa input nilai untuk **siswa mana saja**
- Guru tidak input nilai untuk dirinya sendiri

#### Workflow Input Nilai (Guru):
1. Login sebagai guru
2. Menu → "Input Nilai"
3. Lihat daftar semua siswa
4. Pilih siswa → Klik "Input Nilai"
5. Isi form:
   - Mata Pelajaran
   - Nilai Tugas (0-100)
   - Nilai UTS (0-100)
   - Nilai UAS (0-100)
6. Sistem auto-calculate Nilai Akhir & Predikat
7. Simpan

## 🔧 File yang Diubah

### 1. `lib/screens/admin_dashboard.dart`

#### StudentFormDialog
```dart
// TAMBAHAN: Field username & password
TextField(
  controller: _usernameController,
  decoration: const InputDecoration(
    labelText: 'Username',
    hintText: 'Untuk login siswa',
  ),
),
TextField(
  controller: _passwordController,
  decoration: const InputDecoration(
    labelText: 'Password',
    hintText: 'Password login siswa',
  ),
  obscureText: true,
),
```

#### TeacherFormDialog
```dart
// TAMBAHAN: Field username & password
TextField(
  controller: _usernameController,
  decoration: const InputDecoration(
    labelText: 'Username',
    hintText: 'Untuk login guru',
  ),
),
TextField(
  controller: _passwordController,
  decoration: const InputDecoration(
    labelText: 'Password',
    hintText: 'Password login guru',
  ),
  obscureText: true,
),
```

#### _addStudent & _addTeacher
```dart
// TAMBAHAN: Otomatis buat user account
await AuthService.registerUser(
  username: username,
  password: password,
  role: 'siswa', // atau 'guru'
  name: name,
  email: '',
  phone: '',
);
```

### 2. `lib/screens/login_page.dart`

#### Perubahan
```dart
// HAPUS: bool _isLogin, _nameController, _selectedRole
// HAPUS: _handleRegister() function
// HAPUS: _buildRegisterForm() function
// HAPUS: Toggle "Daftar di sini"

// TAMBAH: Pesan untuk hubungi admin
Center(
  child: Text(
    'Hubungi admin untuk membuat akun',
    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
  ),
),
```

### 3. `lib/screens/teacher_dashboard.dart`

**TIDAK ADA PERUBAHAN** - Sudah benar dari awal!
- GradeInputPage menampilkan semua siswa via `DatabaseService.getAllStudents()`
- Guru pilih siswa mana yang mau diberi nilai

## 🧪 Testing Update

### Test 1: Admin Menambah Guru dengan Akun
1. Login: admin/admin123
2. Menu → Data Guru → Klik "+"
3. Isi:
   - NIP: `2002`
   - Nama: `Bu Ani`
   - Mata Pelajaran: `Bahasa Inggris`
   - Username: `ani_teacher`
   - Password: `ani123`
4. Simpan
5. ✅ Muncul notifikasi: "Guru Bu Ani berhasil ditambahkan dengan username: ani_teacher"
6. Logout
7. Login dengan `ani_teacher` / `ani123`
8. ✅ Masuk ke Guru Dashboard

### Test 2: Admin Menambah Siswa dengan Akun
1. Login: admin/admin123
2. Menu → Data Siswa → Klik "+"
3. Isi:
   - NIS: `1002`
   - Nama: `Siti Rahayu`
   - Kelas: `XII IPA 1`
   - Jurusan: `IPA`
   - Username: `siti1002`
   - Password: `siti123`
4. Simpan
5. ✅ Muncul notifikasi: "Siswa Siti Rahayu berhasil ditambahkan dengan username: siti1002"
6. Logout
7. Login dengan `siti1002` / `siti123`
8. ✅ Masuk ke Siswa Dashboard

### Test 3: Halaman Login Tanpa Registrasi
1. Buka aplikasi
2. ✅ Hanya ada form login
3. ✅ Tidak ada tombol "Daftar"
4. ✅ Ada pesan: "Hubungi admin untuk membuat akun"

### Test 4: Guru Input Nilai ke Siswa
1. Login sebagai guru (ani_teacher/ani123)
2. Menu → "Input Nilai"
3. ✅ Melihat daftar SEMUA siswa:
   - Budi Santoso (1001)
   - Siti Rahayu (1002)
4. Klik "Input Nilai" pada Siti Rahayu
5. Isi nilai Bahasa Inggris
6. ✅ Nilai tersimpan untuk siswa Siti

### Test 5: Validasi Field Required
1. Login admin
2. Coba tambah guru tanpa isi username/password
3. ✅ Muncul error: "Semua field harus diisi"
4. Coba tambah siswa tanpa isi username/password
5. ✅ Muncul error: "Semua field harus diisi"

## ⚠️ Breaking Changes

### 1. Tidak Ada Registrasi Publik
- User tidak bisa daftar sendiri lagi
- Semua akun harus dibuat oleh admin

### 2. Format Function Signature Berubah

**StudentFormDialog.onSave:**
```dart
// SEBELUM
Function(String nis, String name, String kelas, String jurusan)

// SESUDAH
Function(String nis, String name, String kelas, String jurusan, String username, String password)
```

**TeacherFormDialog.onSave:**
```dart
// SEBELUM
Function(String nip, String name, String mataPelajaran)

// SESUDAH
Function(String nip, String name, String mataPelajaran, String username, String password)
```

## 📚 Data Flow Baru

### Alur Pembuatan Akun Siswa
```
Admin Dashboard
    ↓
Tambah Siswa (Form dengan username/password)
    ↓
DatabaseService.createStudent()
    ↓
AuthService.registerUser(role: 'siswa')
    ↓
✅ Student data + User account created
```

### Alur Pembuatan Akun Guru
```
Admin Dashboard
    ↓
Tambah Guru (Form dengan username/password)
    ↓
DatabaseService.createTeacher()
    ↓
AuthService.registerUser(role: 'guru')
    ↓
✅ Teacher data + User account created
```

### Alur Input Nilai
```
Guru Login
    ↓
Menu "Input Nilai"
    ↓
Lihat Daftar SEMUA Siswa (DatabaseService.getAllStudents())
    ↓
Pilih Siswa → Klik "Input Nilai"
    ↓
Form Input (Mapel, Tugas, UTS, UAS)
    ↓
DatabaseService.createGrade(nisStudent, ...)
    ↓
✅ Nilai tersimpan untuk siswa tersebut
```

## 🎯 Checklist Update

- [x] Admin bisa menambah guru dengan username/password
- [x] Admin bisa menambah siswa dengan username/password
- [x] Otomatis buat user account saat tambah guru/siswa
- [x] Hapus fitur registrasi dari login page
- [x] Tampilkan pesan "Hubungi admin"
- [x] Validasi field required untuk username/password
- [x] Notifikasi sukses dengan username yang dibuat
- [x] Guru tetap input nilai ke siswa (bukan diri sendiri)
- [x] Update dokumentasi

## 🚀 Migration Guide

### Untuk Admin Existing
1. Login dengan akun admin lama (admin/admin123)
2. Buat ulang akun untuk semua guru dan siswa dengan username/password baru
3. Informasikan username/password ke masing-masing guru/siswa

### Untuk User Existing
1. Data guru dan siswa masih ada di database
2. Namun akun login lama tidak bisa digunakan
3. Minta admin untuk buat akun baru dengan username/password

## 💡 Rekomendasi Penggunaan

### Username Convention
- **Guru:** `[nama_depan]_teacher` (contoh: `ani_teacher`, `joko_teacher`)
- **Siswa:** `[nama_depan][nis]` (contoh: `budi1001`, `siti1002`)

### Password Policy
- Minimal 6 karakter
- Kombinasi huruf dan angka
- Admin bisa set default password (contoh: `guru123`, `siswa123`)
- User bisa ganti password nanti (fitur future)

### Best Practice
1. Admin buat akun langsung saat menambah guru/siswa
2. Catat username/password di tempat aman
3. Berikan username/password ke user via cara aman (email, WA pribadi)
4. Sarankan user untuk mengingat/mencatat username/password mereka

---

**Konklusi:** Sistem sekarang lebih terpusat dan aman dengan admin sebagai satu-satunya yang bisa membuat akun. Guru fokus ke input nilai siswa, dan siswa fokus ke lihat rapor mereka sendiri. 🎓
