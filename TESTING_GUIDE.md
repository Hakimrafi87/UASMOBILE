# 🧪 Quick Testing Guide

## Langkah-Langkah Testing Aplikasi

### 1. Setup Awal
```bash
cd "c:\Users\finsp\OneDrive\Documents\.UNIV S5\Prak. Mobile Programming\sistem_sekolah\sistem_sekolah"
flutter run
```

### 2. Testing Login & Admin

#### Login sebagai Admin
1. Buka aplikasi
2. Masukkan:
   - Username: `admin`
   - Password: `admin123`
3. Klik "Login"
4. ✅ Harus masuk ke Admin Dashboard

#### Testing CRUD Data Siswa (Admin)
1. Klik drawer menu → "Data Siswa"
2. Klik tombol "+" (Floating Action Button)
3. Isi data:
   - NIS: `1001`
   - Nama: `Budi Santoso`
   - Kelas: `XII IPA 1`
   - Jurusan: `IPA`
4. Klik "Simpan"
5. ✅ Data siswa muncul di list

#### Testing CRUD Data Guru (Admin)
1. Klik drawer menu → "Data Guru"
2. Klik tombol "+"
3. Isi data:
   - NIP: `2001`
   - Nama: `Pak Joko`
   - Mata Pelajaran: `Matematika`
4. Klik "Simpan"
5. ✅ Data guru muncul di list

#### Testing Jadwal (Admin)
1. Klik drawer menu → "Jadwal"
2. Klik tombol "+"
3. Isi data:
   - Hari: `Senin`
   - Jam Mulai: `08:00`
   - Jam Selesai: `09:30`
   - Mata Pelajaran: `Matematika`
   - Guru: `Pak Joko`
   - Kelas: `XII IPA 1`
4. Klik "Simpan"
5. ✅ Jadwal muncul di list

#### Testing Pengumuman (Admin)
1. Klik drawer menu → "Pengumuman"
2. Klik tombol "+"
3. Isi data:
   - Judul: `Libur Akhir Tahun`
   - Isi: `Sekolah libur tanggal 24-31 Desember 2025`
   - Nama Admin: `Administrator`
4. Klik "Simpan"
5. ✅ Pengumuman muncul di list

### 3. Testing Registrasi & Login Guru

#### Registrasi Guru
1. Logout dari admin (menu → Logout)
2. Di halaman login, klik "Daftar di sini"
3. Isi form:
   - Nama Lengkap: `Ibu Siti`
   - Username: `siti`
   - Password: `guru123`
   - Role: `Guru (Teacher)`
4. Klik "Daftar"
5. ✅ Muncul pesan "Registrasi berhasil, silakan login"

#### Login sebagai Guru
1. Form kembali ke Login
2. Masukkan:
   - Username: `siti`
   - Password: `guru123`
3. Klik "Login"
4. ✅ Masuk ke Guru Dashboard

#### Testing Input Nilai (Guru)
1. Klik drawer menu → "Input Nilai"
2. Cari siswa `Budi Santoso`
3. Klik tombol "Input Nilai"
4. Isi data:
   - Mata Pelajaran: `Matematika`
   - Nilai Tugas: `85`
   - Nilai UTS: `80`
   - Nilai UAS: `90`
5. Klik "Simpan"
6. ✅ Nilai Akhir otomatis terhitung: (85×0.3) + (80×0.3) + (90×0.4) = 85.5
7. ✅ Predikat otomatis: A (karena 85.5 ≥ 85)
8. ✅ Muncul snackbar "Nilai berhasil disimpan"

#### Testing View Pengumuman (Guru)
1. Klik drawer menu → "Pengumuman"
2. ✅ Melihat pengumuman "Libur Akhir Tahun" yang dibuat admin

### 4. Testing Registrasi & Login Siswa

#### Registrasi Siswa
1. Logout dari guru
2. Di halaman login, klik "Daftar di sini"
3. Isi form:
   - Nama Lengkap: `Budi Santoso`
   - Username: `1001` (gunakan NIS yang sama)
   - Password: `siswa123`
   - Role: `Siswa (Student)`
4. Klik "Daftar"
5. ✅ Registrasi berhasil

#### Login sebagai Siswa
1. Login dengan:
   - Username: `1001`
   - Password: `siswa123`
2. ✅ Masuk ke Siswa Dashboard

#### Testing View Rapor (Siswa)
1. Klik drawer menu → "Rapor Saya"
2. ✅ Melihat informasi siswa (Nama, NIS, Kelas, Jurusan)
3. ✅ Melihat daftar nilai:
   - Mata Pelajaran: Matematika
   - Tugas: 85.00
   - UTS: 80.00
   - UAS: 90.00
   - Nilai Akhir: 85.50
   - Predikat: A (dengan badge hijau)
   - Guru: Ibu Siti

#### Testing Export PDF (Siswa)
1. Di halaman Rapor
2. Klik icon download di AppBar (pojok kanan atas)
3. ✅ Muncul PDF preview
4. ✅ Bisa share atau save PDF
5. ✅ PDF berisi:
   - Header "LAPORAN NILAI SISWA - Sekolah XYZ"
   - Informasi Siswa
   - Tabel nilai lengkap

#### Testing View Jadwal (Siswa)
1. Klik drawer menu → "Jadwal Pelajaran"
2. ✅ Melihat jadwal Matematika:
   - Hari: Senin
   - Jam: 08:00 - 09:30
   - Guru: Pak Joko
   - Kelas: XII IPA 1

#### Testing View Pengumuman (Siswa)
1. Klik drawer menu → "Pengumuman"
2. ✅ Melihat pengumuman "Libur Akhir Tahun"

### 5. Testing Edit & Delete (Admin)

#### Edit Data Siswa
1. Login kembali sebagai admin
2. Menu → "Data Siswa"
3. Klik 3 titik (⋮) pada card siswa
4. Pilih "Edit"
5. Ubah Kelas menjadi `XII IPA 2`
6. Klik "Simpan"
7. ✅ Data berhasil diupdate

#### Delete Data
1. Klik 3 titik (⋮) pada card
2. Pilih "Hapus"
3. ✅ Data terhapus dari list

### 6. Testing Multiple Grades (Guru)

#### Input Nilai untuk Multiple Subjects
1. Login sebagai guru
2. Input nilai untuk siswa yang sama:
   - Fisika: Tugas=75, UTS=80, UAS=85
   - Kimia: Tugas=90, UTS=85, UAS=88

#### Verify di Rapor (Siswa)
1. Login sebagai siswa
2. Rapor Saya
3. ✅ Harus melihat 3 mata pelajaran:
   - Matematika (A)
   - Fisika (B)
   - Kimia (A)

### 7. Testing Data Persistence

#### Close & Reopen App
1. Close aplikasi completely
2. Reopen aplikasi
3. Login dengan akun yang sama
4. ✅ Semua data masih ada (Hive persistence works)

## ✅ Checklist Testing

### Authentication
- [ ] Login admin berhasil
- [ ] Login guru berhasil
- [ ] Login siswa berhasil
- [ ] Registrasi guru berhasil
- [ ] Registrasi siswa berhasil
- [ ] Logout berhasil
- [ ] Session persistence works

### Admin Functions
- [ ] Create siswa berhasil
- [ ] Read/view siswa berhasil
- [ ] Update siswa berhasil
- [ ] Delete siswa berhasil
- [ ] CRUD guru berhasil
- [ ] CRUD jadwal berhasil
- [ ] CRUD pengumuman berhasil
- [ ] Dashboard statistics correct

### Guru Functions
- [ ] View daftar siswa
- [ ] Input nilai berhasil
- [ ] Nilai akhir calculated correctly
- [ ] Predikat assigned correctly
- [ ] View pengumuman

### Siswa Functions
- [ ] View rapor dengan semua nilai
- [ ] Export PDF berhasil
- [ ] PDF content correct
- [ ] View jadwal
- [ ] View pengumuman
- [ ] Read-only access verified

### Formula Validation
Test dengan nilai berbeda:
- [ ] (100, 100, 100) = 100 → A ✅
- [ ] (80, 80, 80) = 80 → B ✅
- [ ] (70, 70, 70) = 70 → C ✅
- [ ] (60, 60, 60) = 60 → D ✅

### Edge Cases
- [ ] Empty database handling
- [ ] Duplicate NIS prevention
- [ ] Duplicate username prevention
- [ ] Invalid login handling
- [ ] Empty forms validation
- [ ] Update nilai for same student-subject

## 🎯 Expected Results Summary

| Test Case | Expected Result | Status |
|-----------|----------------|--------|
| Admin login | Access to all CRUD | ⏳ |
| Guru login | Access to input nilai only | ⏳ |
| Siswa login | Access to view only | ⏳ |
| Input nilai | Auto-calculate + predikat | ⏳ |
| Export PDF | Complete rapor PDF | ⏳ |
| Data persistence | All data saved locally | ⏳ |
| Role access control | Proper restrictions | ⏳ |

## 📝 Notes

- Semua data tersimpan di Hive local database
- Data akan persist bahkan setelah restart aplikasi
- Admin adalah superuser dengan full access
- Guru hanya bisa CRUD nilai
- Siswa hanya bisa view (read-only)
- PDF dapat di-share atau save ke device

---

**Happy Testing! 🎉**

Jika ada bug atau issue, catat di dokumen ini untuk perbaikan.
