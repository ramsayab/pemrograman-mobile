# Catatan Mini Project TabungKu

## Konsep yang Dipelajari

- Membuat aplikasi gabungan to-do list dan manajemen keuangan.
- Memisahkan kode menggunakan model, data, state, widget, dan pages.
- Mengelola data kegiatan dengan operasi CRUD: tambah, baca, ubah, dan hapus.
- Menyimpan data secara permanen menggunakan SQLite.
- Menggunakan state reaktif agar perubahan data langsung terlihat di halaman lain.
- Membuat form dengan validasi input, date picker, kategori, dan jenis keuangan.
- Menggunakan NavigationBar tiga tab dan named route.
- Membuat laporan pemasukan, pengeluaran, kategori, tanggal, dan tujuh hari terakhir.
- Menyimpan pengaturan mode gelap, warna tema, dan target menggunakan SharedPreferences.

## Fungsi/API Baru

- `Future`, `async`, dan `await` untuk proses database.
- `openDatabase()`, `db.insert()`, `db.query()`, `db.update()`, dan `db.delete()`.
- `Form`, `TextFormField`, `validator`, dan `GlobalKey<FormState>`.
- `showDatePicker()` untuk memilih tanggal kegiatan.
- `Navigator.push()`, `Navigator.pop()`, dan named routes.
- `ChangeNotifier`, `notifyListeners()`, dan `AnimatedBuilder` untuk state pengaturan.
- `SharedPreferences` untuk menyimpan preferensi aplikasi.
- Query SQL `COUNT`, `SUM`, `CASE WHEN`, dan `GROUP BY` untuk laporan.
