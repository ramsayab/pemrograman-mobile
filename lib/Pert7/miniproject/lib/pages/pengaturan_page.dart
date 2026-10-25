import 'package:flutter/material.dart';

import '../state/pengaturan.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key, required this.settings});
  final PengaturanState settings;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pengaturan')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SwitchListTile(
          title: const Text('Mode gelap'),
          value: settings.themeMode == ThemeMode.dark,
          onChanged: (_) => settings.toggleTheme(),
        ),
        const Divider(),
        ListTile(
          title: const Text('Target tabungan harian'),
          subtitle: Text('Rp ${settings.target.toStringAsFixed(0)}'),
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final controller = TextEditingController(
                text: settings.target.toStringAsFixed(0),
              );
              final value = await showDialog<double>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Ubah target'),
                  content: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(prefixText: 'Rp '),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(
                        context,
                        double.tryParse(controller.text.replaceAll('.', '')),
                      ),
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              );
              controller.dispose();
              if (value != null && value > 0) settings.saveTarget(value);
            },
          ),
        ),
        const Divider(),
        const ListTile(title: Text('Warna tema')),
        Wrap(
          spacing: 12,
          children: [
            for (final color in [
              const Color(0xff126782),
              Colors.indigo,
              Colors.teal,
              Colors.deepOrange,
            ])
              InkWell(
                onTap: () => settings.setSeedColor(color),
                borderRadius: BorderRadius.circular(30),
                child: CircleAvatar(
                  backgroundColor: color,
                  child: settings.seedColor.toARGB32() == color.toARGB32()
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
