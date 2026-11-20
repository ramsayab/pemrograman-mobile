import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../services/health_service.dart';

class StatusServerPage extends StatefulWidget {
  const StatusServerPage({super.key});

  @override
  State<StatusServerPage> createState() => _StatusServerPageState();
}

class _StatusServerPageState extends State<StatusServerPage> {
  late Future<StatusServer> _future;

  @override
  void initState() {
    super.initState();
    _future = cekServer();
  }

  void _periksaLagi() {
    setState(() {
      _future = cekServer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status server')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<StatusServer>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final berhasil = snapshot.hasData;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      berhasil ? Icons.check_circle : Icons.error,
                      color: berhasil ? Colors.green : Colors.red,
                      size: 40,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      berhasil ? 'Server terhubung' : 'Server tidak terhubung',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Alamat API: $apiUrl'),
                if (berhasil) ...[
                  const SizedBox(height: 8),
                  Text('Waktu server: ${snapshot.data!.waktuServer}'),
                  const SizedBox(height: 8),
                  Text('Latensi: ${snapshot.data!.latensi.inMilliseconds} ms'),
                ] else ...[
                  const SizedBox(height: 8),
                  Text('${snapshot.error}'),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _periksaLagi,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Periksa lagi'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}