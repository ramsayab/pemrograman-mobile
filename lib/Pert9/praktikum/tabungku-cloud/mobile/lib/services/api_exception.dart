import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.pesan, {this.kode});

  final int? kode;
  final String pesan;

  factory ApiException.dariRespons(http.Response response) {
    var pesan = 'Server membalas kode ${response.statusCode}';
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final detail = body['detail'];
      if (detail is String) {
        pesan = detail;
      } else if (detail is List) {
        pesan = detail
            .map((item) => (item['msg'] as String)
                .replaceFirst('Value error, ', ''))
            .join('\n');
      }
    } catch (_) {
      // Respons mungkin bukan JSON, misalnya halaman galat dari proxy.
    }
    return ApiException(pesan, kode: response.statusCode);
  }

  @override
  String toString() => pesan;
}
