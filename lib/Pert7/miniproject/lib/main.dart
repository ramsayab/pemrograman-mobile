import 'package:flutter/material.dart';

import 'pages/form_kegiatan_page.dart';
import 'pages/shell_page.dart';

void main() => runApp(const TabungKuApp());

class TabungKuApp extends StatelessWidget {
  const TabungKuApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'TabungKu',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff126782)),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xfff5f7f5),
    ),
    routes: {'/add': (_) => const FormKegiatanPage()},
    home: const ShellPage(),
  );
}
