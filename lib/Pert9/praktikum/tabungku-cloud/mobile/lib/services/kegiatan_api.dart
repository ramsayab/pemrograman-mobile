import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/kegiatan.dart';
import 'api_exception.dart';

class KegiatanApi {
  KegiatanApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _jsonHeaders = {'Content-Type': 'application/json'};

  Uri _uri(String path, [Map<String, String>? query]) {
    final uri = Uri.parse('${apiUrl.replaceFirst(RegExp(r'/+$'), '')}$path');
    return query == null || query.isEmpty
        ? uri
        : uri.replace(queryParameters: query);
  }

  http.Response _cek(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException.dariRespons(response);
    }
    return response;
  }

  Future<List<Kegiatan>> daftar({String? tanggal}) async {
    final query = <String, String>{};
    if (tanggal != null) query['tanggal'] = tanggal;
    final response = _cek(
      await _client.get(_uri('/kegiatan', query)).timeout(batasWaktu),
    );
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => Kegiatan.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Kegiatan> tambah(Kegiatan kegiatan) async {
    final response = _cek(
      await _client
          .post(
            _uri('/kegiatan'),
            headers: _jsonHeaders,
            body: jsonEncode(kegiatan.toJson()),
          )
          .timeout(batasWaktu),
    );
    return Kegiatan.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Kegiatan> ubah(int id, Kegiatan kegiatan) async {
    final response = _cek(
      await _client
          .put(
            _uri('/kegiatan/$id'),
            headers: _jsonHeaders,
            body: jsonEncode(kegiatan.toJson()),
          )
          .timeout(batasWaktu),
    );
    return Kegiatan.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Kegiatan> setSelesai(int id, bool selesai) async {
    final response = _cek(
      await _client
          .patch(
            _uri('/kegiatan/$id'),
            headers: _jsonHeaders,
            body: jsonEncode({'selesai': selesai}),
          )
          .timeout(batasWaktu),
    );
    return Kegiatan.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> hapus(int id) async {
    _cek(await _client.delete(_uri('/kegiatan/$id')).timeout(batasWaktu));
  }

  void close() => _client.close();
}
