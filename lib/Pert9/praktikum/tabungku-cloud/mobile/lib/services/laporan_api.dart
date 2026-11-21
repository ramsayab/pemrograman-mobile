import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/laporan.dart';
import 'api_exception.dart';

class LaporanApi {
  LaporanApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri(String path, Map<String, String> query) {
    final base = apiUrl.replaceFirst(RegExp(r'/+$'), '');
    return Uri.parse('$base$path').replace(queryParameters: query);
  }

  Future<http.Response> _get(Uri uri) async {
    final response = await _client.get(uri).timeout(batasWaktu);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException.dariRespons(response);
    }
    return response;
  }

  Future<LaporanHarian> harian(DateTime tanggal) async {
    final response = await _get(_uri('/laporan/harian', {
      'tanggal': _formatTanggal(tanggal),
    }));
    return LaporanHarian.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<LaporanRentang> rentang(DateTime mulai, DateTime sampai) async {
    final response = await _get(_uri('/laporan/rentang', {
      'mulai': _formatTanggal(mulai),
      'sampai': _formatTanggal(sampai),
    }));
    return LaporanRentang.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  String _formatTanggal(DateTime tanggal) =>
      tanggal.toIso8601String().substring(0, 10);

  void close() => _client.close();
}
