import 'package:flutter/material.dart';

import 'config/api_config.dart';
import 'pages/pengaturan_page.dart';
import 'pages/status_server_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await muatApiUrl();
  runApp(const TabungKuApp());
}

class TabungKuApp extends StatelessWidget {
  const TabungKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabungKu',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const BerandaPage(),
        '/status': (context) => const StatusServerPage(),
        '/pengaturan': (context) => const PengaturanPage(),
      },
    );
  }
}

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TabungKu')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_outlined),
            title: const Text('Status server'),
            subtitle: const Text('Periksa koneksi ke TabungKu API'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/status'),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Pengaturan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/pengaturan'),
          ),
        ],
      ),
    );
  }
}
