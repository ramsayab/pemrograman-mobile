import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tabungku/models/kegiatan.dart';
import 'package:tabungku/services/api_exception.dart';
import 'package:tabungku/services/kegiatan_api.dart';

Map<String, dynamic> kegiatanJson({int id = 3, bool selesai = false}) => {
      'id': id,
      'judul': 'Makan siang',
      'tanggal': '2026-10-06',
      'selesai': selesai,
      'tipe': 'pengeluaran',
      'nominal': 15000,
      'kategori': 'Makan',
      'catatan': null,
      'created_at': '2026-10-06T08:00:00',
      'updated_at': '2026-10-06T08:00:00',
    };

void main() {
  test('Kegiatan dapat dikonversi ke dan dari JSON', () {
    final kegiatan = Kegiatan.fromJson(kegiatanJson());

    expect(kegiatan.id, 3);
    expect(kegiatan.tipe, Tipe.pengeluaran);
    expect(kegiatan.toJson(), {
      'judul': 'Makan siang',
      'tanggal': '2026-10-06',
      'selesai': false,
      'tipe': 'pengeluaran',
      'nominal': 15000,
      'kategori': 'Makan',
      'catatan': null,
    });
  });

  test('daftar mengirim filter tanggal di URL', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/kegiatan');
      expect(request.url.queryParameters['tanggal'], '2026-10-06');
      return http.Response(jsonEncode([kegiatanJson()]), 200);
    });

    final hasil = await KegiatanApi(client: client).daftar(tanggal: '2026-10-06');
    expect(hasil.single.id, 3);
  });

  test('tambah mengirim body JSON', () async {
    final client = MockClient((request) async {
      expect(request.method, 'POST');
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['judul'], 'Makan siang');
      expect(body['selesai'], isFalse);
      expect(body.containsKey('id'), isFalse);
      return http.Response(jsonEncode(kegiatanJson()), 201);
    });
    final kegiatan = Kegiatan(
      judul: 'Makan siang',
      tanggal: DateTime(2026, 10, 6),
      tipe: Tipe.pengeluaran,
      nominal: 15000,
      kategori: 'Makan',
    );

    expect((await KegiatanApi(client: client).tambah(kegiatan)).id, 3);
  });

  test('PATCH hanya mengirim field selesai', () async {
    final client = MockClient((request) async {
      expect(request.method, 'PATCH');
      expect(request.url.path, '/kegiatan/3');
      expect(jsonDecode(request.body), {'selesai': true});
      return http.Response(jsonEncode(kegiatanJson(selesai: true)), 200);
    });

    expect((await KegiatanApi(client: client).setSelesai(3, true)).selesai, isTrue);
  });

  test('detail validasi 422 menjadi pesan ApiException', () async {
    final client = MockClient((_) async => http.Response(
          jsonEncode({
            'detail': [
              {'loc': ['body', 'judul'], 'msg': 'Value error, judul wajib diisi'}
            ]
          }),
          422,
        ));
    final kegiatan = Kegiatan(judul: '', tanggal: DateTime(2026, 10, 6));

    await expectLater(
      KegiatanApi(client: client).tambah(kegiatan),
      throwsA(isA<ApiException>()
          .having((error) => error.kode, 'kode', 422)
          .having((error) => error.pesan, 'pesan', 'judul wajib diisi')),
    );
  });
}
