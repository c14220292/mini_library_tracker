# 📚 Mini Library Tracker

A new Flutter project.

Aplikasi Flutter sederhana untuk mencatat dan melacak buku-buku yang sedang atau sudah dibaca oleh pengguna.

## ✨ Fitur Utama

- **Autentikasi pengguna** menggunakan Firebase Authentication (Email/Password)
- **Tambah buku** ke dalam daftar pribadi
- **Filter buku** berdasarkan status: Belum Dibaca, Sedang Dibaca, dan Selesai
- **Update status buku** dengan dropdown
- **Simpan sesi login lokal** menggunakan Hive (offline session)
- **Tampilan Get Started** untuk pengguna pertama kali

## 🚀 Langkah Instalasi & Build

- git clone https://github.com/c14220292/mini_library_tracker.git
- cd mini_library_tracker
- Install dependencies:
- flutter pub get
- Jalankan aplikasi (misal: di Chrome):
- flutter run -d chrome

## 🛠 Teknologi yang Digunakan

Flutter - Framework UI

Firebase Authentication - Untuk login/register pengguna

Firebase Firestore - Penyimpanan data buku

Hive - Untuk menyimpan status login & info sesi secara lokal (offline cache)

Provider / StatefulWidget - Untuk manajemen state

## 🧪 Dummy Akun Uji Coba

Gunakan akun berikut untuk menguji login:

Email: c14220292@john.petra.ac.id || c14220292@peter.petra.ac.id

Password: 123456 (kedua email passwordnya sama)

Jika akun belum terdaftar, kamu bisa langsung daftar dan mulai menambahkan buku.

📬 Jika ada masalah atau bug, silakan buka Issue di repo ini.
Happy coding!