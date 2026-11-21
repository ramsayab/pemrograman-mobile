# Catatan Pertemuan 8

- **Docker:** mempelajari image sebagai cetakan aplikasi dan container sebagai aplikasi yang berjalan. Volume menyimpan data, sedangkan network menghubungkan container. Dockerfile dan Docker Compose digunakan untuk membangun serta menjalankan layanan.
- **Konfigurasi layanan:** kredensial disimpan di `.env`. Port menghubungkan layanan container ke laptop, healthcheck memeriksa kesiapan MySQL, dan `depends_on` memastikan API menunggu database siap.
- **Backend FastAPI:** membuat endpoint `/` dan `/health`. FastAPI menyediakan dokumentasi interaktif otomatis di `/docs`.
- **Database MySQL:** MySQL dijalankan sebagai container dengan volume agar datanya bertahan saat container dihentikan. Adminer dapat dipakai untuk melihat database melalui browser.
- **Flutter dan API:** alamat API berbeda menurut perangkat—emulator Android memakai `10.0.2.2`, sedangkan HP fisik memakai IP laptop. Aplikasi dapat menampilkan status API dan database.
- **Pengujian:** `MockClient` dari paket `http` memungkinkan respons API diuji tanpa menjalankan server, termasuk kondisi sehat, database mati (503), dan kode respons lain.
