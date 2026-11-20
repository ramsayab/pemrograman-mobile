import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tabungku/services/health_service.dart';

void main() {
  test('sehat: API dan database hidup', () async {
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

  test('503: API hidup tetapi database mati', () async {
    final client = MockClient((_) async => http.Response(
          jsonEncode({
            'detail': {
              'status': 'error',
              'waktu_server': '2026-10-06T08:00:00',
              'database': 'error',
              'pesan': 'MySQL tidak dapat dihubungi',
            },
          }),
          503,
        ));

    final status = await cekServer(client: client);

    expect(status.apiHidup, isTrue);
    expect(status.databaseHidup, isFalse);
    expect(status.pesan, 'MySQL tidak dapat dihubungi');
  });

  test('kode selain 200 dan 503 menghasilkan galat', () async {
    final client = MockClient((_) async => http.Response('Not found', 404));

    await expectLater(
      cekServer(client: client),
      throwsA(isA<Exception>().having(
        (error) => error.toString(),
        'pesan',
        contains('kode 404'),
      )),
    );
  });
}
