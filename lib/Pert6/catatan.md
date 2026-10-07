# Catatan Pertemuan 6: Tema, Routing dan Navigasi, serta Animasi

## Tema
- `ThemeData` menyimpan seluruh gaya aplikasi. Cukup satu seed color, Material 3 membuat seluruh palet.
- `MaterialApp`: `theme` (terang), `darkTheme` (gelap), `themeMode` (sistem/terang/gelap).
- Baca tema dengan `Theme.of(context)`, jangan menulis warna manual agar ikut berubah saat tema berganti.

```dart
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

ListenableBuilder(
  listenable: Listenable.merge([themeMode, seedColor]),
  builder: (context, _) => MaterialApp(
    theme: buatTema(seedColor.value, Brightness.light),
    darkTheme: buatTema(seedColor.value, Brightness.dark),
    themeMode: themeMode.value,
  ),
);
```
- Ubah tema lewat `themeMode.value = ...` (bukan variabel biasa), jika tidak tema tidak berubah.

## Routing
| Method | Fungsi |
|---|---|
| `pushNamed(ctx, '/detail', arguments: x)` | Buka halaman bernama, bawa argumen |
| `pop(ctx)` | Tutup halaman saat ini |
| `pushReplacementNamed(...)` | Ganti halaman saat ini (tidak bisa kembali) |
| `pushNamedAndRemoveUntil(...)` | Buka halaman baru, hapus riwayat sebelumnya |

```dart
initialRoute: '/',
routes: {'/': (_) => const ShellPage()},
onGenerateRoute: (settings) {
  if (settings.name == '/detail') {
    final item = settings.arguments as Item;
    return MaterialPageRoute(builder: (_) => DetailPage(item: item), settings: settings);
  }
  return null;
},
onUnknownRoute: (settings) => MaterialPageRoute(builder: (_) => const HalamanTidakDitemukan()),
```
- `onGenerateRoute` lebih aman karena tipe argumen dicek di satu tempat.
- Untuk aplikasi besar dengan deep link/web dipakai `go_router`.

## Navigasi tab bawah
- `NavigationBar` + `IndexedStack`: semua tab tetap hidup (state tidak hilang) saat berpindah.
- `Navigator`: membuka halaman baru di atas tumpukan, state halaman hilang saat di-pop.

## Animasi
| Jenis | Widget | Kapan dipakai |
|---|---|---|
| Implisit | `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSwitcher` | Cukup ubah nilai di `setState` |
| Hero | `Hero` | Elemen "terbang" antar halaman (tag harus sama) |
| Eksplisit | `AnimationController` + `RotationTransition` dll. | Perlu ulang, berhenti, urutan, sinkronisasi |

- `AnimatedSwitcher` butuh `key` berbeda pada anaknya (mis. `ValueKey(_hitung)`), jika tidak widget dianggap sama dan tidak beranimasi.
- `AnimatedContainer`: nilai harus berubah di dalam `setState` dan bertipe sama.
- `AnimationController` butuh `with SingleTickerProviderStateMixin` dan `vsync: this`, serta wajib di-`dispose()`.
- Tag `Hero` harus sama di dua halaman dan unik di dalam satu halaman. Tag ganda di halaman yang sama menyebabkan galat.

```dart
_putar = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
@override
void dispose() { _putar.dispose(); super.dispose(); }
```

## Latihan Mandiri (ringkas)
1. Simpan tema di `shared_preferences`: `main()` async + `WidgetsFlutterBinding.ensureInitialized()`.
2. `Drawer` pada `ShellPage` untuk berpindah tab.
3. `PageRouteBuilder` + `FadeTransition` di `onGenerateRoute`.
4. `onUnknownRoute` untuk halaman 404.
5. Demo keempat `AnimatedOpacity`.

## Tugas: Galeri Wisata Indonesia
- 3 tab: Beranda, Favorit (badge jumlah), Pengaturan.
- Named route `/detail` dengan argumen `DetailArgs` + Hero (tag dibedakan per tab: `beranda-`, `favorit-`).
- Animasi implisit (`AnimatedContainer`, `AnimatedSwitcher`) dan eksplisit (`AnimationController` untuk ikon hati berdenyut).
- Tema terang/gelap + 4 warna, tersimpan; daftar favorit juga tersimpan.
- Warna dan gaya teks dari `Theme.of(context)`.

## Catatan error yang ditemui
- `pilihanWarna` bertipe `List<MaterialColor>`, jadi `pilihanWarna.indexOf(seedColor.value)` error. Pakai `pilihanWarna.indexWhere((c) => c == seedColor.value)`.
- Dua tab di `IndexedStack` dengan tag Hero sama menyebabkan galat tag ganda. Bedakan tag per tab.

## Troubleshooting
| Masalah | Solusi |
|---|---|
| `Could not find a generator for route` | Nama rute salah ketik atau belum ditangani di `routes`/`onGenerateRoute` |
| Hero tidak beranimasi | Tag harus sama di kedua halaman dan unik di satu halaman |
| Tema tidak berubah | Bungkus `MaterialApp` dengan `ListenableBuilder`, ubah lewat `themeMode.value` |
| Sebagian warna tidak ikut mode gelap | Ganti warna manual dengan `Theme.of(context).colorScheme` |
| `vsync` / `TickerProvider` error | Tambahkan `with SingleTickerProviderStateMixin` |

## Refleksi (inti jawaban)
1. Implisit: ubah nilai via `setState`, sederhana. Eksplisit: `AnimationController`, kontrol penuh.
2. Tag Hero sama agar Flutter tahu pasangan elemennya. Tag ganda di satu halaman menyebabkan galat.
3. `Theme.of(context)` membuat warna konsisten dan otomatis mengikuti perubahan tema.
4. `IndexedStack` menjaga state semua tab di satu halaman. `Navigator` membuka halaman baru di atas tumpukan.
5. `AnimationController` di-dispose agar ticker berhenti dan tidak terjadi kebocoran memori.