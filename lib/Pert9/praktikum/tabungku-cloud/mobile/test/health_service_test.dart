import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tabungku/services/health_service.dart';

void main() {
  test('health menampilkan API dan MySQL hidup', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/health');
      return http.Response(
        jsonEncode({
          'status': 'ok',
          'waktu_server': '2026-10-06T08:00:00',
          'database': 'ok',
          'mysql_version': '8.4.0',
        }),
        200,
      );
    });

    final status = await cekServer(client: client);
    expect(status.apiHidup, isTrue);
    expect(status.databaseHidup, isTrue);
    expect(status.versiMysql, '8.4.0');
  });
}
