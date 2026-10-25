import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import 'beranda_page.dart';
import 'form_kegiatan_page.dart';
import 'laporan_page.dart';
import 'pengaturan_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});
  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  final db = DbHelper();
  final settings = PengaturanState();
  int index = 0;

  @override
  void initState() {
    super.initState();
    db.init().then((_) {
      if (mounted) setState(() {});
    });
    settings.load();
  }

  void toggle(Kegiatan item) => setState(() {
    item.done = !item.done;
    db.update(item);
  });
  Future<void> remove(Kegiatan item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus kegiatan?'),
        content: Text('Kegiatan "${item.title}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true) setState(() => db.delete(item));
  }

  Future<void> edit(Kegiatan item) async {
    final result = await Navigator.push<Kegiatan>(
      context,
      MaterialPageRoute(builder: (_) => FormKegiatanPage(initial: item)),
    );
    if (result != null) setState(() => db.update(result));
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: settings,
    builder: (context, _) => Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.seedColor,
          brightness: settings.themeMode == ThemeMode.dark
              ? Brightness.dark
              : Brightness.light,
        ),
        useMaterial3: true,
      ),
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: index == 0
              ? BerandaPage(
                  key: const ValueKey('home'),
                  db: db,
                  target: settings.target,
                  onToggle: toggle,
                  onDelete: remove,
                  onEdit: edit,
                )
              : index == 1
              ? LaporanPage(
                  key: const ValueKey('report'),
                  db: db,
                  target: settings.target,
                )
              : PengaturanPage(
                  key: const ValueKey('settings'),
                  settings: settings,
                ),
        ),
        floatingActionButton: index == 0
            ? FloatingActionButton.extended(
                onPressed: () async {
                  final result = await Navigator.push<Kegiatan>(
                    context,
                    MaterialPageRoute(builder: (_) => const FormKegiatanPage()),
                  );
                  if (result != null) setState(() => db.insert(result));
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.checklist_rtl),
              label: 'Aktivitas',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              label: 'Laporan',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: 'Pengaturan',
            ),
          ],
        ),
      ),
    ),
  );
}
