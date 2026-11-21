# Praktikum Pertemuan 9

## Menjalankan backend

Salin `.env.example` menjadi `.env`, lalu dari folder ini jalankan:

```powershell
docker compose up -d --build
docker compose ps
```

Migrasi Alembic berjalan saat API mulai. Swagger tersedia di `http://localhost:9000/docs`, sedangkan Adminer tersedia di `http://localhost:8081` (server MySQL: `mysql`). Untuk melihat revisi aktif: `docker compose exec api alembic current`.

Filter daftar kegiatan mendukung `selesai=true/false` dan `urut=terbaru/terlama`. Endpoint laporan: `/laporan/harian?tanggal=YYYY-MM-DD` dan `/laporan/rentang?mulai=YYYY-MM-DD&sampai=YYYY-MM-DD`. Latihan kolom catatan menggunakan migrasi sementara `0001b`; ikuti catatan di `latihan-mandiri.md` bila ingin mencoba downgrade.

## Menjalankan Flutter

Dari folder `mobile`:

```powershell
flutter pub get
flutter test
```

API client dan tes `MockClient` berada di `lib/services/`; tes API kegiatan dan laporan berada di `test/`. Tes tidak memerlukan server aktif.
