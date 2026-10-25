# TabungKu

Mini project Flutter Pertemuan 7: To-Do List dan manajemen keuangan.

## Fitur

- Daftar aktivitas hari ini dengan checklist selesai.
- Tambah kegiatan dengan tanggal, jenis keuangan, nominal, kategori, dan validasi.
- Hapus kegiatan dengan konfirmasi.
- Penyimpanan SQLite pada tabel `kegiatan`.
- Ringkasan jumlah kegiatan, pemasukan, pengeluaran, saldo, target, dan progress.
- Laporan kategori dan agregasi data.
- NavigationBar tiga tab: Aktivitas, Laporan, Pengaturan.
- Mode gelap dan target tersimpan melalui `shared_preferences`.

## Struktur

```text
lib/
  main.dart
  models/kegiatan.dart
  data/db_helper.dart
  state/pengaturan.dart
  utils/format.dart
  widgets/ringkasan_card.dart
  widgets/kegiatan_tile.dart
  pages/shell_page.dart
  pages/beranda_page.dart
  pages/form_kegiatan_page.dart
  pages/laporan_page.dart
  pages/pengaturan_page.dart
```

## Menjalankan

```bash
flutter pub get
flutter run
```

## Pengembangan lanjutan yang dipilih

1. **Rencana vs realisasi**: laporan membandingkan target tabungan dengan saldo dari kegiatan yang sudah selesai.
2. **Pencarian dan filter kegiatan**: filter berdasarkan nama, jenis keuangan, kategori, dan rentang tanggal.

## Pengujian

```bash
flutter analyze
flutter test
```

Folder `build/` adalah hasil generate lokal Flutter dan tidak perlu dikumpulkan atau di-commit. Project harus tetap dapat dibuat ulang dengan `flutter pub get` dan dijalankan dengan `flutter run`.
