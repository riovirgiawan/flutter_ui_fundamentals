# flutter_ui_fundamentals

Aplikasi Course Explorer merupakan aplikasi Flutter untuk menampilkan informasi mata kuliah dan mengelola daftar favorit.

## Getting Started

This project is a starting point for a Flutter application.

Beberapa sumber untuk mempelajari Flutter:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
- [Flutter Documentation](https://docs.flutter.dev/)

## Struktur Folder dan Tanggung Jawab

Proyek Course Explorer menggunakan arsitektur berlapis untuk memisahkan tanggung jawab setiap bagian aplikasi.

- **models/**: Menyimpan model data, seperti `Course`, untuk merepresentasikan data mata kuliah.
- **services/**: Bertanggung jawab mengambil dan membaca data, termasuk memuat file JSON dari assets.
- **repositories/**: Mengatur akses data dari service dan menyediakan data untuk Provider.
- **providers/**: Mengelola state aplikasi, seperti daftar mata kuliah, status loading, error, dan favorit.
- **screens/**: Menyimpan halaman utama aplikasi, seperti Home Page dan Course Detail Page.
- **widgets/**: Menyimpan komponen UI yang dapat digunakan kembali pada beberapa halaman.

Struktur ini bertujuan memisahkan logika pengambilan data, pengelolaan state, dan tampilan agar kode lebih terorganisasi serta mudah dikembangkan.

## Dokumentasi REST API

**Nama API:** Course API - Pertemuan 7

**Base URL:** `https://course-api-pearl.vercel.app`

**Endpoint:** `/courses`

**HTTP Method:** GET

**Status Code:** 200 OK

**Resource:** Courses

**Format Response:** JSON Array

**Struktur Data:** `id`, `code`, `title`, `credits`, `status`, dan `created_at`.

**Hasil Pengujian:** Request GET berhasil mengambil 18 data course. Response berbentuk array JSON dan setiap objek memiliki field utama yang dibutuhkan oleh aplikasi, yaitu id, code, title, credits, dan status. Pengujian Postman menunjukkan status 200 dan struktur response sesuai dengan yang diharapkan.