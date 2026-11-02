## Dokumentasi

- [docs/BRD_ChessWar_Mobile.pdf](docs/BRD_ChessWar_Mobile.pdf) - Business Requirement Document
- [docs/PRD_ChessWar_Mobile.pdf](docs/PRD_ChessWar_Mobile.pdf) - Product Requirement Document (termasuk wireframe)

# Chess War Mobile

Aplikasi mobile (Android dan iOS) permainan catur RPG dengan sistem **Custom Power Cards** dan lawan **bot berbasis model Machine Learning** buatan sendiri.

Sebelum pertandingan, pemain memilih satu dari enam kartu tersembunyi. Kekuatan di baliknya diundi oleh server dan mengubah aturan gerak bidak selama permainan.

## Fitur

**Pemain**
- Registrasi dan login (email/kata sandi atau Google Sign-In), sesi JWT
- Drafting 6 kartu misteri dan 6 kekuatan: Confused Pawn, Blink Knight, Super Rook, Undying King, Omni Queen, Grey Bishop
- Papan catur sentuh (tap dan drag) dengan panduan langkah (titik dan lingkaran emas)
- Bot ML 5 tingkat: Easy, Medium-Easy, Medium, Hard, Expert
- Kontrol arena: Undo, Flip, Force Move, New, Simpan dan Keluar, Menyerah
- Save, auto-save (saat aplikasi ke latar belakang), dan Resume Game
- Statistik, riwayat, XP dan Level, Leaderboard top 20
- Latihan puzzle dengan validasi langkah di server
- Daily Chess Tip

**Administrator** (modul di dalam aplikasi, akses berbasis peran)
- CRUD pengguna, pertandingan, puzzle, percobaan puzzle, dan chess tips
- RBAC granular dan audit log
- AI Puzzle Generator (Gemini API) dengan validasi ketat

## Arsitektur

```
Flutter (Android/iOS)
        |  HTTPS + JWT
        v
     Nginx  -->  FastAPI  -->  PostgreSQL
                    |
                    +--> Layanan Inferensi Bot ML (ONNX Runtime)
                    +--> Gemini API (hanya admin, dari server)
```

Prinsip utama:
- **Server otoritatif.** Validasi langkah memakai `python-chess` + lapisan custom power. Hasil pertandingan dan XP dihitung server dari riwayat langkah, bukan dilaporkan klien.
- **Bot di server.** Output model di-mask ke langkah legal sehingga tidak pernah mengembalikan langkah ilegal. Bila model gagal atau lambat, dipakai fallback heuristik.
- **Model dapat diganti tanpa rilis aplikasi.** Setiap pertandingan mencatat `bot_model_version`.

## Teknologi

| Komponen | Teknologi |
|---|---|
| Mobile | Flutter (Dart), Riverpod/Bloc, Dio, fl_chart, flutter_secure_storage, google_sign_in |
| Backend | FastAPI, Pydantic, SQLAlchemy, Alembic, python-chess, PyJWT, passlib |
| Basis data | PostgreSQL |
| Bot ML | PyTorch (pelatihan), ONNX Runtime (inferensi) |
| AI generatif | Gemini API |
| Deployment | Docker, Docker Compose, Nginx |
| Kualitas | pytest, flutter_test, ruff, black, flutter analyze |

## Struktur Repositori (usulan)

```
chess-war-mobile/
├── mobile/            # Aplikasi Flutter
├── backend/           # FastAPI, rules engine, migrasi Alembic
├── ml/                # Data, pelatihan, evaluasi, ekspor ONNX
├── infra/             # Docker Compose, konfigurasi Nginx
└── docs/              # BRD dan PRD
```

## Prasyarat

- Flutter SDK (stabil terbaru), Android Studio dan/atau Xcode
- Python 3.11+
- Docker dan Docker Compose
- Akun Google Cloud (OAuth client) dan kunci Gemini API (untuk fitur terkait)


## Variabel Lingkungan (usulan)

| Variabel | Keterangan |
|---|---|
| `APP_ENV` | `development`, `staging`, atau `production` |
| `DATABASE_URL` | Koneksi PostgreSQL |
| `JWT_SECRET` | Kunci penandatangan JWT |
| `JWT_ACCESS_TTL_MIN` | Umur access token (15-30 menit) |
| `GOOGLE_CLIENT_ID` | Untuk verifikasi Google ID token |
| `GEMINI_API_KEY` | Hanya di server, tidak pernah dikirim ke aplikasi |
| `BOT_MODEL_PATH` | Lokasi berkas model ONNX |
| `BOT_MODEL_VERSION` | Versi model aktif |

Mock Google login hanya aktif bila `APP_ENV` bukan `production`.

## Kelompok API

`/auth` · `/me` · `/games` · `/stats` · `/leaderboard` · `/puzzles` · `/tips` · `/admin`

Endpoint yang mengubah hasil atau XP bersifat idempoten agar aman dikirim ulang saat koneksi terputus.


## Target Kinerja

- Respons bot p95 maksimal 1 detik, langkah ilegal 0%
- Endpoint non-bot p95 di bawah 500 ms
- Crash-free sessions minimal 99%
- Resume game berhasil minimal 99%

## Peta Jalan

| Versi | Cakupan |
|---|---|
| 1.0 (MVP) | Auth, drafting, papan, bot ML, 6 power, save/resume, statistik, XP, Leaderboard, kelola pengguna dan pertandingan |
| 1.1 | Latihan puzzle, reward XP puzzle, Daily Chess Tip |
| 1.2 | Manajemen puzzle, AI Puzzle Generator, manajemen tips, RBAC granular, audit log |

Di luar cakupan: multiplayer real-time, chat, pembelian dalam aplikasi, turnamen, dan bot offline di perangkat.