import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tabungku/services/laporan_api.dart';

void main() {
  test('harian mengirim tanggal dan membaca ringkasan serta kategori', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/laporan/harian');
      expect(request.url.queryParameters['tanggal'], '2026-10-06');
      return http.Response(
        jsonEncode({
          'tanggal': '2026-10-06',
          'jumlah_kegiatan': 4,
          'selesai': 2,
          'pemasukan': 50000,
          'pengeluaran': 25000,
          'tabungan': 25000,
          'per_kategori': [
            {'kategori': 'Makan', 'total': 15000},
            {'kategori': 'Transport', 'total': 10000},
          ],
        }),
        200,
      );
    });

    final laporan = await LaporanApi(client: client).harian(DateTime(2026, 10, 6));

    expect(laporan.jumlahKegiatan, 4);
    expect(laporan.selesai, 2);
    expect(laporan.tabungan, 25000);
    expect(laporan.perKategori.first.kategori, 'Makan');
    expect(laporan.perKategori.first.total, 15000);
  });

  test('rentang mengirim tanggal awal dan akhir serta membaca hari kosong', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/laporan/rentang');
      expect(request.url.queryParameters, {
        'mulai': '2026-10-06',
        'sampai': '2026-10-07',
      });
      return http.Response(
        jsonEncode({
          'mulai': '2026-10-06',
          'sampai': '2026-10-07',
          'harian': [
            {
              'tanggal': '2026-10-06',
              'jumlah_kegiatan': 1,
              'selesai': 1,
              'pemasukan': 50000,
              'pengeluaran': 0,
              'tabungan': 50000,
            },
            {
              'tanggal': '2026-10-07',
              'jumlah_kegiatan': 0,
              'selesai': 0,
              'pemasukan': 0,
              'pengeluaran': 0,
              'tabungan': 0,
            },
          ],
        }),
        200,
      );
    });

    final laporan = await LaporanApi(client: client).rentang(
      DateTime(2026, 10, 6),
      DateTime(2026, 10, 7),
    );

    expect(laporan.harian, hasLength(2));
    expect(laporan.harian.last.jumlahKegiatan, 0);
    expect(laporan.harian.last.tabungan, 0);
  });
}
