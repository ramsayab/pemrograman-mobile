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

  void _periksaLagi() => setState(() => _future = cekServer());

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

            final status = snapshot.data;
            final apiHidup = status?.apiHidup ?? false;
            final dbHidup = status?.databaseHidup ?? false;
            return ListView(
              children: [
                _BarisStatus(
                  label: 'API',
                  hidup: apiHidup,
                  offlineLabel: snapshot.hasError
                      ? 'Tidak terhubung'
                      : 'Mati',
                ),
                const SizedBox(height: 12),
                _BarisStatus(
                  label: 'Database MySQL',
                  hidup: dbHidup,
                  offlineLabel: apiHidup ? 'Mati' : 'Tidak diketahui',
                ),
                const SizedBox(height: 16),
                Text('Alamat API: $apiUrl'),
                if (status != null) ...[
                  if (status.waktuServer.isNotEmpty)
                    Text('Waktu server: ${status.waktuServer}'),
                  if (status.versiMysql != null)
                    Text('Versi MySQL: ${status.versiMysql}'),
                  Text('Latensi: ${status.latensi.inMilliseconds} ms'),
                  if (status.pesan != null) Text('Pesan: ${status.pesan}'),
                ],
                if (snapshot.hasError)
                  Text('Galat koneksi: ${snapshot.error}'),
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

class _BarisStatus extends StatelessWidget {
  const _BarisStatus({
    required this.label,
    required this.hidup,
    required this.offlineLabel,
  });

  final String label;
  final bool hidup;
  final String offlineLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          hidup ? Icons.check_circle : Icons.error,
          color: hidup ? Colors.green : Colors.red,
          size: 32,
        ),
        const SizedBox(width: 12),
        Text('$label: ${hidup ? 'Hidup' : offlineLabel}'),
      ],
    );
  }
}
