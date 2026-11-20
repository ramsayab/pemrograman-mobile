# TabungKu Cloud

Kerangka Flutter dan FastAPI untuk praktikum Flutter Pertemuan 8.

## Menjalankan backend

1. Pastikan Docker Desktop aktif.
2. Dari folder ini, salin `.env.example` menjadi `.env` (PowerShell: `Copy-Item .env.example .env`).
3. Jalankan `docker compose up -d --build`.
4. Periksa layanan dengan `docker compose ps`. Tunggu MySQL berstatus `healthy`.
5. Buka `http://localhost:9000/health`, `http://localhost:9000/docs`, dan Adminer di `http://localhost:8081`.

Login Adminer: sistem **MySQL**, server **mysql**, pengguna/password dari `.env`, database sesuai `MYSQL_DATABASE`.

Hentikan layanan dengan `docker compose down`. Data database tersimpan di volume Compose; `docker compose down -v` menghapus volume itu.

## Menjalankan Flutter

Dari folder `mobile`:

```powershell
flutter pub get
flutter run --dart-define=API_URL=http://10.0.2.2:9000
```

Alamat tersebut untuk emulator Android. Simulator iOS memakai `http://localhost:9000`; HP fisik memakai alamat IP laptop di jaringan Wi-Fi yang sama, misalnya `http://192.168.1.10:9000`. Alamat API juga dapat diubah dan disimpan dari **Pengaturan** di aplikasi.

Jalankan unit test tanpa server aktif:

```powershell
flutter test
```

## Bukti pengumpulan

Ambil tangkapan layar `docker compose ps`, Swagger `/docs`, Adminer setelah login, Status Server saat API dan MySQL sehat, serta Status Server setelah `docker compose stop mysql`. Jangan sertakan berkas `.env` dalam pengumpulan.
