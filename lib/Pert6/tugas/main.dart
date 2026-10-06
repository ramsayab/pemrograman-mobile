import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.teal);
final favorit = ValueNotifier<Set<String>>(<String>{});

const pilihanWarna = [
  Colors.teal,
  Colors.indigo,
  Colors.deepOrange,
  Colors.pink,
];

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

class Penyimpanan {
  static Future<void> muat() async {
    final prefs = await SharedPreferences.getInstance();
    themeMode.value =
        (prefs.getBool('gelap') ?? false) ? ThemeMode.dark : ThemeMode.light;
    final i = prefs.getInt('warna') ?? 0;
    seedColor.value =
        (i >= 0 && i < pilihanWarna.length) ? pilihanWarna[i] : pilihanWarna[0];
    favorit.value = (prefs.getStringList('favorit') ?? <String>[]).toSet();
  }

  static Future<void> simpanTema() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('gelap', themeMode.value == ThemeMode.dark);
    await prefs.setInt(
        'warna', pilihanWarna.indexWhere((c) => c == seedColor.value));
  }

  static Future<void> simpanFavorit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorit', favorit.value.toList());
  }
}

void ubahFavorit(String id) {
  final baru = {...favorit.value};
  if (!baru.remove(id)) baru.add(id);
  favorit.value = baru;
  Penyimpanan.simpanFavorit();
}

class Tempat {
  final String id;
  final String nama;
  final String lokasi;
  final String kategori;
  final String deskripsi;
  final IconData ikon;
  const Tempat(this.id, this.nama, this.lokasi, this.kategori, this.deskripsi,
      this.ikon);
}

const daftarTempat = [
  Tempat(
    'borobudur',
    'Candi Borobudur',
    'Magelang, Jawa Tengah',
    'Budaya',
    'Candi Buddha dari abad ke-9 yang menjadi salah satu daya tarik budaya '
        'terbesar di Indonesia.',
    Icons.account_balance,
  ),
  Tempat(
    'kuta',
    'Pantai Kuta',
    'Badung, Bali',
    'Pantai',
    'Pantai populer di Bali yang terkenal dengan ombak untuk berselancar dan '
        'pemandangan matahari terbenam.',
    Icons.beach_access,
  ),
  Tempat(
    'bromo',
    'Gunung Bromo',
    'Jawa Timur',
    'Gunung',
    'Gunung berapi aktif di kawasan Taman Nasional Bromo Tengger Semeru yang '
        'terkenal dengan pemandangan matahari terbit.',
    Icons.landscape,
  ),
  Tempat(
    'rajaampat',
    'Raja Ampat',
    'Papua Barat Daya',
    'Bahari',
    'Gugusan pulau yang terkenal dengan keanekaragaman hayati laut dan '
        'tempat menyelam.',
    Icons.sailing,
  ),
  Tempat(
    'toba',
    'Danau Toba',
    'Sumatera Utara',
    'Danau',
    'Danau vulkanik besar di Sumatera Utara dengan Pulau Samosir di '
        'tengahnya.',
    Icons.water,
  ),
  Tempat(
    'komodo',
    'Pulau Komodo',
    'Nusa Tenggara Timur',
    'Satwa',
    'Bagian dari Taman Nasional Komodo, habitat asli komodo.',
    Icons.pets,
  ),
];

class DetailArgs {
  final Tempat tempat;
  final String tagHero;
  const DetailArgs(this.tempat, this.tagHero);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Penyimpanan.muat();
  themeMode.addListener(Penyimpanan.simpanTema);
  seedColor.addListener(Penyimpanan.simpanTema);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Galeri Wisata',
          debugShowCheckedModeBanner: false,
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
          themeMode: themeMode.value,
          initialRoute: '/',
          routes: {
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail' &&
                settings.arguments is DetailArgs) {
              final args = settings.arguments as DetailArgs;
              return MaterialPageRoute(
                builder: (_) => DetailPage(args: args),
                settings: settings,
              );
            }
            return null;
          },
        );
      },
    );
  }
}

class IkonTempat extends StatelessWidget {
  final Tempat tempat;
  final double radius;
  const IkonTempat({super.key, required this.tempat, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final latar = [
      cs.primaryContainer,
      cs.secondaryContainer,
      cs.tertiaryContainer
    ];
    final isi = [
      cs.onPrimaryContainer,
      cs.onSecondaryContainer,
      cs.onTertiaryContainer
    ];
    final n = daftarTempat.indexOf(tempat) % 3;
    return CircleAvatar(
      radius: radius,
      backgroundColor: latar[n],
      child: Icon(tempat.ikon, size: radius, color: isi[n]),
    );
  }
}

class KartuTempat extends StatelessWidget {
  final Tempat tempat;
  final String prefixHero;
  const KartuTempat(
      {super.key, required this.tempat, required this.prefixHero});

  @override
  Widget build(BuildContext context) {
    final tag = '$prefixHero-${tempat.id}';
    return Card(
      child: ListTile(
        leading: Hero(tag: tag, child: IkonTempat(tempat: tempat)),
        title: Text(tempat.nama),
        subtitle: Text('${tempat.lokasi} • ${tempat.kategori}'),
        trailing: ValueListenableBuilder<Set<String>>(
          valueListenable: favorit,
          builder: (context, set, _) {
            final suka = set.contains(tempat.id);
            return Icon(
              suka ? Icons.favorite : Icons.chevron_right,
              color: suka ? Theme.of(context).colorScheme.primary : null,
            );
          },
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail',
            arguments: DetailArgs(tempat, tag),
          );
        },
      ),
    );
  }
}

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jelajahi Indonesia', style: tema.textTheme.headlineSmall),
              Text('Pilih tempat untuk melihat detailnya',
                  style: tema.textTheme.bodyMedium),
            ],
          ),
        ),
        for (final t in daftarTempat)
          KartuTempat(tempat: t, prefixHero: 'beranda'),
      ],
    );
  }
}

class FavoritTab extends StatelessWidget {
  const FavoritTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return ValueListenableBuilder<Set<String>>(
      valueListenable: favorit,
      builder: (context, set, _) {
        final daftar = daftarTempat.where((t) => set.contains(t.id)).toList();
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: daftar.isEmpty
              ? Center(
                  key: const ValueKey('kosong'),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border,
                          size: 64, color: tema.colorScheme.outline),
                      const SizedBox(height: 12),
                      Text('Belum ada favorit',
                          style: tema.textTheme.titleMedium),
                      Text('Tandai tempat dari halaman detail',
                          style: tema.textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView(
                  key: const ValueKey('isi'),
                  padding: const EdgeInsets.all(12),
                  children: [
                    for (final t in daftar)
                      KartuTempat(tempat: t, prefixHero: 'favorit'),
                  ],
                ),
        );
      },
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        final tema = Theme.of(context);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Mode gelap'),
              value: themeMode.value == ThemeMode.dark,
              onChanged: (v) {
                themeMode.value = v ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            const SizedBox(height: 8),
            Text('Warna tema', style: tema.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                for (final c in pilihanWarna)
                  GestureDetector(
                    onTap: () => seedColor.value = c,
                    child: CircleAvatar(
                      backgroundColor: c,
                      child: seedColor.value == c
                          ? Icon(Icons.check, color: tema.colorScheme.surface)
                          : null,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Pengaturan tema dan daftar favorit tersimpan otomatis.',
              style: tema.textTheme.bodySmall,
            ),
          ],
        );
      },
    );
  }
}

class DetailPage extends StatefulWidget {
  final DetailArgs args;
  const DetailPage({super.key, required this.args});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _denyut;
  late final Animation<double> _skala;

  @override
  void initState() {
    super.initState();
    _denyut = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _skala = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_denyut);
  }

  @override
  void dispose() {
    _denyut.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tempat = widget.args.tempat;
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(tempat.nama)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Hero(
              tag: widget.args.tagHero,
              child: IkonTempat(tempat: tempat, radius: 64),
            ),
          ),
          const SizedBox(height: 16),
          Text(tempat.nama,
              textAlign: TextAlign.center,
              style: tema.textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(tempat.lokasi,
              textAlign: TextAlign.center, style: tema.textTheme.bodyMedium),
          const SizedBox(height: 12),
          Center(child: Chip(label: Text(tempat.kategori))),
          const SizedBox(height: 12),
          Text(tempat.deskripsi, style: tema.textTheme.bodyLarge),
          const SizedBox(height: 24),
          ValueListenableBuilder<Set<String>>(
            valueListenable: favorit,
            builder: (context, set, _) {
              final suka = set.contains(tempat.id);
              return Center(
                child: GestureDetector(
                  onTap: () {
                    ubahFavorit(tempat.id);
                    _denyut.forward(from: 0);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: suka ? cs.primaryContainer : cs.secondaryContainer,
                      borderRadius: BorderRadius.circular(suka ? 32 : 12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(
                          scale: _skala,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) =>
                                ScaleTransition(scale: anim, child: child),
                            child: Icon(
                              suka ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey(suka),
                              color: cs.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          suka ? 'Favorit' : 'Tambah ke favorit',
                          style: tema.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  static const _halaman = [BerandaTab(), FavoritTab(), PengaturanTab()];
  static const _judul = ['Beranda', 'Favorit', 'Pengaturan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_index])),
      body: IndexedStack(index: _index, children: _halaman),
      bottomNavigationBar: ValueListenableBuilder<Set<String>>(
        valueListenable: favorit,
        builder: (context, set, _) {
          return NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: set.isNotEmpty,
                  label: Text('${set.length}'),
                  child: const Icon(Icons.favorite_border),
                ),
                selectedIcon: Badge(
                  isLabelVisible: set.isNotEmpty,
                  label: Text('${set.length}'),
                  child: const Icon(Icons.favorite),
                ),
                label: 'Favorit',
              ),
              const NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Pengaturan',
              ),
            ],
          );
        },
      ),
    );
  }
}
