# Catatan Praktikum Flutter - Pertemuan 4
**Mengambil Data dari REST API (HTTP, Async, FutureBuilder)**

## 1. Konsep Inti

| Konsep | Fungsi |
|---|---|
| `Future` | Objek berisi hasil yang tersedia nanti |
| `async` / `await` | `await` menunggu hasil tanpa memblokir UI; hanya di fungsi `async` |
| `http.get(uri)` | Kirim GET, hasilnya `Future<Response>` |
| `jsonDecode(body)` | Teks JSON menjadi `Map` / `List` |
| `fromJson` | Factory untuk mengubah `Map` menjadi objek model |
| `FutureBuilder` | Bangun UI dari status Future |
| `snapshot` | `connectionState`, `data`, `error` |

Kode status: **200** sukses, **404** tidak ditemukan, **500** galat server.

## 2. Alur Kerja Aplikasi

```
initState()  ->  ambilPengguna()  ->  FutureBuilder
                      |                    |
              http.get + cek 200      waiting -> loading
              jsonDecode              hasError -> pesan + Coba lagi
              fromJson                data -> ListView
```

## 3. Langkah per Bagian

- **A**: demo `Future.delayed` 2 detik, tanpa internet.
- **B**: `flutter pub add http`; izin `INTERNET` di `AndroidManifest.xml` untuk release.
- **C**: model `Pengguna` + `ambilPengguna()` (lempar `Exception` jika status bukan 200).
- **D**: `PenggunaPage` dengan 3 keadaan (loading, galat, data) + tombol refresh.
- **E**: `DetailPenggunaPage` (email, telepon, website).
- **F**: uji galat: URL `/userz` (404) dan internet dimatikan.

> C, D, E digabung dalam satu `main.dart` karena D memakai C dan memanggil E.

## 4. Aturan Penting

- Buat `Future` di **`initState()`**, bukan di `build()`.
- Selalu sediakan 3 status: **loading, error, data**.
- Periksa `statusCode` lalu `throw Exception(...)` agar masuk ke `snapshot.error`.
- Pakai `.timeout(...)` agar permintaan tidak menggantung.
- Setelah menambah paket, **restart penuh** aplikasi (bukan hot reload).

## 5. Latihan Mandiri (ringkas)

1. `username` dan `city` (`json['address']['city']`) di model dan halaman detail.
2. `RefreshIndicator` membungkus `ListView`.
3. Daftar kosong: teks "Tidak ada data".
4. Jumlah pengguna di judul AppBar: `Daftar Pengguna (10)`.

## 6. Tugas: Daftar Postingan

- Endpoint: `/posts` dan `/posts/{id}/comments`.
- Struktur: **Model** (`Post`, `Komentar`), **Service** (`PostService`), **UI** (`PostPage`, `DetailPostPage`, `ErrorView`).
- Detail postingan memakai **Future kedua** untuk komentar.
- Kumpulkan: screenshot (daftar, detail, galat) + `main.dart`.

## 7. Jawaban Refleksi (singkat)

1. **Future di `build()`**: permintaan diulang tiap rebuild, data terus dimuat ulang dan layar berkedip.
2. **`hasError` vs `statusCode`**: `hasError` menangkap exception (jaringan, timeout); `statusCode` memeriksa respons server yang gagal (404/500) yang tidak melempar exception. Keduanya perlu.
3. **Model vs `Map`**: tipe jelas, ada autocomplete, galat key/null cepat ketahuan, kode lebih rapi.
4. **Loading dan error wajib**: jaringan lambat dan bisa gagal; tanpa keduanya pengguna mengira aplikasi macet.

## 8. Troubleshooting (termasuk yang dialami)

| Masalah | Solusi |
|---|---|
| `Could not prepare isolate` | `main.dart` tidak punya `void main()` atau tidak valid. Isi harus Bagian A + C + D + E, bukan hanya snippet. |
| Garis bergelombang di import | Peringatan *unused import*; hilang setelah kode C ditempel |
| Emulator layar hitam | Ganti AVD (hindari image `gphone16k`), Graphics: Software, atau pakai HP asli |
| `Failed host lookup` / `SocketException` | Cek internet emulator; pastikan izin INTERNET |
| `type 'Null' is not a subtype` | Key JSON salah atau nilainya null; cek respons asli di browser |
| API lambat / mati | Tunggu, coba lagi, atau pakai JSON cadangan via `rootBundle` |
| Build macet di WSL | Naikkan RAM WSL di `.wslconfig`; `flutter clean` lalu `flutter pub get` |

## 9. Perintah Berguna

```bash
flutter pub add http
flutter pub get
flutter clean
flutter analyze
flutter run -d emulator-5554
```

## 10. Berkas

- `bagian_a_main.dart`, `bagian_c.dart`, `bagian_d.dart`, `bagian_e.dart`
- `latihan_mandiri_main.dart`, `tugas_postingan_main.dart`
- `Laporan_Praktikum_Pertemuan_4.docx`