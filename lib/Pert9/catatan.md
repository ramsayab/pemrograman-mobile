# Catatan Pertemuan 9: REST API dan Laporan TabungKu

## Konsep yang dipelajari

- **REST API:** resource diakses lewat URL dan method HTTP. `GET` membaca, `POST` membuat (201), `PUT` mengganti seluruh data, `PATCH` mengubah sebagian, dan `DELETE` menghapus (204). Data dikirim dalam format JSON.
- **ORM SQLAlchemy:** kelas `Kegiatan` dipetakan ke tabel MySQL. ORM membentuk query dan operasi data tanpa menulis SQL `INSERT` secara langsung.
- **Migrasi Alembic:** perubahan skema disimpan sebagai revisi berurutan. `alembic upgrade head` menerapkan migrasi terbaru, sedangkan `downgrade -1` membatalkan satu revisi.
- **Validasi Pydantic:** memeriksa tipe dan aturan bisnis pada data masuk. FastAPI membalas `422` bila data tidak valid; endpoint mengembalikan `404` bila data tidak ditemukan.
- **Session per request:** dependency `get_db()` menyediakan session database untuk satu request dan menutupnya setelah selesai.
- **Agregasi SQL:** `COUNT`, `SUM`, `CASE`, `COALESCE`, dan `GROUP BY` menghitung statistik langsung di database.

## Endpoint dan metode

- `GET /kegiatan`: daftar dengan filter tanggal, tipe, status selesai, pencarian judul, pagination (`limit`, `offset`), urutan (`terbaru`/`terlama`), dan header `X-Total-Count`.
- `GET /kegiatan/{id}`: mengambil satu kegiatan.
- `POST /kegiatan`, `PUT /kegiatan/{id}`, `PATCH /kegiatan/{id}`, `DELETE /kegiatan/{id}`: operasi CRUD. PATCH menggabungkan perubahan dengan data lama lalu memvalidasi ulang aturan bisnis.
- `GET /laporan/harian?tanggal=YYYY-MM-DD`: menghitung jumlah kegiatan, yang selesai, pemasukan, pengeluaran, tabungan, dan total pengeluaran per kategori.
- `GET /laporan/rentang?mulai=...&sampai=...`: memberi ringkasan per hari termasuk hari tanpa kegiatan; rentang dibatasi maksimal 31 hari.

## Fungsi di Flutter

- `Kegiatan.toJson()` dan `Kegiatan.fromJson()` mengubah model ke/dari JSON API.
- `ApiException.dariRespons()` mengubah detail error FastAPI menjadi pesan yang mudah dibaca.
- `KegiatanApi` menyediakan `daftar`, `tambah`, `ubah`, `setSelesai`, dan `hapus`.
- `Ringkasan.fromJson()` dan `LaporanHarian.fromJson()` membaca data laporan; `LaporanApi.harian()` dan `LaporanApi.rentang()` mengambilnya dari backend.
- `MockClient` mensimulasikan HTTP untuk unit test tanpa menjalankan server.
