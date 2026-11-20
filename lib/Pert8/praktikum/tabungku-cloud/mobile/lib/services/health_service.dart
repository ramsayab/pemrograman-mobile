import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class StatusServer {
  final bool apiHidup;
  final bool databaseHidup;
  final String waktuServer;
  final String? versiMysql;
  final String? pesan;
  final Duration latensi;

  const StatusServer({
    required this.apiHidup,
    required this.databaseHidup,
    required this.waktuServer,
    required this.latensi,
    this.versiMysql,
    this.pesan,
  });
}

/// Memanggil GET /health. HTTP 503 berarti API hidup, tetapi database mati.
Future<StatusServer> cekServer({http.Client? client}) async {
  final c = client ?? http.Client();
  final jam = Stopwatch()..start();
  try {
    final res = await c.get(Uri.parse('$apiUrl/health')).timeout(batasWaktu);
    jam.stop();
    final data = jsonDecode(res.body) as Map<String, dynamic>;

    if (res.statusCode == 503) {
      final detail = data['detail'];
      return StatusServer(
        apiHidup: true,
        databaseHidup: false,
        waktuServer: detail is Map<String, dynamic>
            ? (detail['waktu_server'] as String? ?? '')
            : '',
        pesan: detail is Map<String, dynamic>
            ? (detail['pesan'] as String? ?? detail.toString())
            : detail?.toString(),
        latensi: jam.elapsed,
      );
    }
    if (res.statusCode != 200) {
      throw Exception('Server membalas kode ${res.statusCode}');
    }

    return StatusServer(
      apiHidup: true,
      databaseHidup: data['database'] == 'ok',
      waktuServer: data['waktu_server'] as String? ?? '',
      versiMysql: data['mysql_version'] as String?,
      latensi: jam.elapsed,
    );
  } finally {
    if (client == null) c.close();
  }
}
