# Catatan Pertemuan 5: Penyimpanan Lokal (SharedPreferences dan SQLite)

## Konsep
- Data di memori (variabel/State) hilang saat aplikasi ditutup. Agar bertahan, simpan di penyimpanan perangkat (persistence).

| Pilihan | Cocok untuk | Paket |
|---|---|---|
| Key-value | Pengaturan kecil (tema, nama, status login) | `shared_preferences` |
| SQLite | Data terstruktur dan banyak (catatan, transaksi) | `sqflite`, `path` |
| Berkas | Dokumen, gambar, ekspor/impor | `path_provider`, `dart:io` |

## Instalasi
```
flutter pub add shared_preferences
flutter pub add sqflite path
```

## SharedPreferences
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString('nama', 'Ramsay');   // tulis
final nama = prefs.getString('nama') ?? ''; // baca, beri nilai bawaan
```
- Tipe: `String`, `bool`, `int`, `double`, `List<String>`.
- Selalu pakai nilai bawaan (`??`) karena hasil baca bisa `null`.

## SQLite (sqflite)
| CRUD | SQL | Method |
|---|---|---|
| Create | INSERT | `db.insert()` |
| Read | SELECT | `db.query()` |
| Update | UPDATE | `db.update()` |
| Delete | DELETE | `db.delete()` |

```dart
db.query('catatan', where: 'judul LIKE ?', whereArgs: ['%$kata%'], orderBy: 'id DESC');
db.update('catatan', c.toMap(), where: 'id = ?', whereArgs: [c.id]);
db.delete('catatan', where: 'id = ?', whereArgs: [id]);
```
- Pakai placeholder `?` + `whereArgs`, jangan menyambung teks pengguna (cegah SQL injection).
- `id` bernilai `null` saat data baru, diisi otomatis oleh `AUTOINCREMENT`.
- `onCreate`: dijalankan sekali saat database baru dibuat.
- `onUpgrade`: dijalankan saat `version` dinaikkan, misalnya `ALTER TABLE catatan ADD COLUMN dibuat TEXT`.
- `version` tidak dinaikkan setelah skema berubah menyebabkan galat `no such column`.

## Pola UI
- `FutureBuilder` menampilkan hasil query. Atur empat kondisi: memuat, galat, kosong, dan data.
- Satu form dipakai untuk tambah dan ubah: `catatan == null` berarti tambah, selain itu ubah.
- Setelah kembali dari form: `await Navigator.push(...)` lalu `_muat()` agar daftar diperbarui.
- Setelah setiap `await`, cek `if (!mounted) return;` sebelum memakai `context` atau `setState`.

## Latihan Mandiri (ringkas)
1. `AlertDialog` konfirmasi sebelum hapus.
2. Pencarian dengan `LIKE`.
3. Kolom `dibuat` + `version: 2` + `onUpgrade`.
4. Pilihan urutan disimpan di `shared_preferences`, diterapkan pada `orderBy`.

## Tugas: Pencatat Pengeluaran
- Tabel: `id`, `nama`, `jumlah` (int), `kategori`, `tanggal`.
- Validasi: nama wajib, jumlah angka bulat lebih dari 0, kategori dari dropdown.
- Total: `SELECT SUM(jumlah) AS total FROM pengeluaran`.
- Pengaturan: mode gelap (`modeGelap`) di `shared_preferences`.

## Troubleshooting
| Masalah | Solusi |
|---|---|
| `MissingPluginException` | Stop aplikasi sepenuhnya, lalu `flutter run` ulang |
| Data baru tidak muncul | Panggil `_muat()` setelah tambah/ubah/hapus |
| `no such table/column` | Naikkan `version`, atau uninstall/Clear data saat pengembangan |
| `sqflite` tidak jalan di web/desktop | Pakai emulator Android atau `sqflite_common_ffi` |

## Refleksi (inti jawaban)
1. `shared_preferences` tidak mendukung query/pencarian/struktur tabel, jadi gunakan SQLite untuk data banyak.
2. Placeholder `?` membuat input diperlakukan sebagai data, bukan perintah SQL.
3. `FutureBuilder` tidak tahu database berubah, jadi `_future` perlu diisi ulang lewat `_muat()`.
4. `onCreate` saat database pertama dibuat; `onUpgrade` saat `version` lebih tinggi dari database lama.