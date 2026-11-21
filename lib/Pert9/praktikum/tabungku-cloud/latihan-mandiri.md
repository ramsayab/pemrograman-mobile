# Latihan Mandiri Pertemuan 9

1. **Filter selesai:** `GET /kegiatan?selesai=true` menampilkan kegiatan yang sudah selesai; `false` menampilkan yang belum selesai.
2. **Urutan tanggal:** `GET /kegiatan?urut=terbaru` mengurutkan tanggal terbaru dahulu. Gunakan `urut=terlama` untuk urutan sebaliknya. Nilai lain dibalas `422`.
3. **Kolom catatan:** model dan revisi Alembic `0001b_tambah_catatan` menambahkan kolom `catatan` bertipe `TEXT` yang boleh kosong. Perubahan diterapkan saat API mulai. Untuk mengamati downgrade: `docker compose exec api alembic downgrade -1`, lalu periksa tabel `kegiatan` di Adminer. Karena model masih memuat kolom ini, jalankan kembali `docker compose exec api alembic upgrade head` setelah pengamatan.
4. **Tanggal `06-10-2026`:** FastAPI membalas `422 Unprocessable Entity`, sebab format tanggal yang diterima adalah ISO `YYYY-MM-DD`, misalnya `2026-10-06`. Detail respons menunjukkan galat validasi pada parameter `tanggal`.
