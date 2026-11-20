import 'package:flutter/material.dart';

import '../config/api_config.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  Future<void> _ubahAlamatApi() async {
    final controller = TextEditingController(text: apiUrl);
    final formKey = GlobalKey<FormState>();
    final url = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alamat API'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'URL API',
              hintText: 'http://192.168.1.10:8000',
            ),
            validator: (value) {
              if (value == null || !urlApiValid(value.trim())) {
                return 'Masukkan URL http:// atau https:// yang valid';
              }
              return null;
            },
            onFieldSubmitted: (_) {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (url == null) return;
    await simpanApiUrl(url);
    if (mounted) setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat API berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_outlined),
            title: const Text('Alamat API'),
            subtitle: Text(apiUrl),
            trailing: const Icon(Icons.edit),
            onTap: _ubahAlamatApi,
          ),
        ],
      ),
    );
  }
}
