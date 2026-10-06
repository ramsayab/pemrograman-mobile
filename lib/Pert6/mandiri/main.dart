import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

const pilihanWarna = [
  Colors.indigo,
  Colors.teal,
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

Future<void> muatTema() async {
  final prefs = await SharedPreferences.getInstance();
  themeMode.value =
      (prefs.getBool('gelap') ?? false) ? ThemeMode.dark : ThemeMode.light;
  final i = prefs.getInt('warna') ?? 0;
  seedColor.value =
      (i >= 0 && i < pilihanWarna.length) ? pilihanWarna[i] : pilihanWarna[0];
}

Future<void> simpanTema() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('gelap', themeMode.value == ThemeMode.dark);
  await prefs.setInt(
      'warna', pilihanWarna.indexWhere((c) => c == seedColor.value));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await muatTema();
  themeMode.addListener(simpanTema);
  seedColor.addListener(simpanTema);
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
          title: 'Praktikum 6',
          debugShowCheckedModeBanner: false,
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
          themeMode: themeMode.value,
          initialRoute: '/',
          routes: {
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final item = settings.arguments as Item;
              return PageRouteBuilder(
                settings: settings,
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (_, __, ___) => DetailPage(item: item),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => const HalamanTidakDitemukan(),
            );
          },
        );
      },
    );
  }
}

class HalamanTidakDitemukan extends StatelessWidget {
  const HalamanTidakDitemukan({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: tema.colorScheme.error),
            const SizedBox(height: 16),
            Text('404 - Halaman tidak ditemukan',
                style: tema.textTheme.titleLarge),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
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
            Text(
              'Warna tema',
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
              ],
            ),
            const Divider(height: 32),
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: const Text('Uji halaman 404'),
              onTap: () => Navigator.pushNamed(context, '/tidak-ada'),
            ),
          ],
        );
      },
    );
  }
}

class Item {
  final String nama;
  final IconData ikon;
  final Color warna;
  const Item(this.nama, this.ikon, this.warna);
}

const daftarItem = [
  Item('Flutter', Icons.flutter_dash, Colors.blue),
  Item('Musik', Icons.music_note, Colors.pink),
  Item('Kamera', Icons.camera_alt, Colors.orange),
  Item('Peta', Icons.map, Colors.green),
];

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: daftarItem.length,
      itemBuilder: (context, i) {
        final item = daftarItem[i];
        return ListTile(
          leading: Hero(
            tag: 'ikon-${item.nama}',
            child: CircleAvatar(
              backgroundColor: item.warna,
              child: Icon(item.ikon, color: Colors.white),
            ),
          ),
          title: Text(item.nama),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: item);
          },
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final Item item;
  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(item.nama)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'ikon-${item.nama}',
              child: CircleAvatar(
                radius: 64,
                backgroundColor: item.warna,
                child: Icon(item.ikon, size: 64, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(item.nama, style: tema.textTheme.headlineMedium),
            Text('Detail untuk ${item.nama}', style: tema.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class AnimasiTab extends StatefulWidget {
  const AnimasiTab({super.key});

  @override
  State<AnimasiTab> createState() => _AnimasiTabState();
}

class _AnimasiTabState extends State<AnimasiTab>
    with SingleTickerProviderStateMixin {
  bool _besar = false;
  bool _tampil = true;
  int _hitung = 0;
  late final AnimationController _putar;

  @override
  void initState() {
    super.initState();
    _putar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _putar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('1. AnimatedContainer', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _besar ? 200 : 100,
            height: 100,
            decoration: BoxDecoration(
              color: _besar ? warna.primary : warna.tertiary,
              borderRadius: BorderRadius.circular(_besar ? 50 : 8),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _besar = !_besar),
          child: const Text('Ubah bentuk'),
        ),
        const Divider(),
        Text('2. AnimatedSwitcher', style: tema.textTheme.titleMedium),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) {
              return ScaleTransition(scale: anim, child: child);
            },
            child: Text(
              '$_hitung',
              key: ValueKey(_hitung),
              style: tema.textTheme.displayMedium,
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _hitung++),
          child: const Text('Tambah'),
        ),
        const Divider(),
        Text('3. AnimationController', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: RotationTransition(
            turns: _putar,
            child: Icon(Icons.settings, size: 64, color: warna.primary),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_putar.isAnimating) {
              _putar.stop();
            } else {
              _putar.repeat();
            }
            setState(() {});
          },
          child: Text(_putar.isAnimating ? 'Berhenti' : 'Putar'),
        ),
        const Divider(),
        Text('4. AnimatedOpacity', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        AnimatedOpacity(
          opacity: _tampil ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Card(
            color: warna.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Kartu ini memudar dan muncul kembali',
                  style: tema.textTheme.bodyLarge
                      ?.copyWith(color: warna.onPrimaryContainer),
                ),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _tampil = !_tampil),
          child: Text(_tampil ? 'Pudarkan' : 'Munculkan'),
        ),
      ],
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

  static const _halaman = [BerandaTab(), AnimasiTab(), PengaturanTab()];
  static const _judul = ['Beranda', 'Animasi', 'Pengaturan'];
  static const _ikon = [Icons.home, Icons.animation, Icons.settings];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_index])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: warna.primaryContainer),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Praktikum 6',
                  style: tema.textTheme.headlineSmall
                      ?.copyWith(color: warna.onPrimaryContainer),
                ),
              ),
            ),
            for (var i = 0; i < _judul.length; i++)
              ListTile(
                leading: Icon(_ikon[i]),
                title: Text(_judul[i]),
                selected: _index == i,
                onTap: () {
                  setState(() => _index = i);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: IndexedStack(index: _index, children: _halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.animation),
            label: 'Animasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
