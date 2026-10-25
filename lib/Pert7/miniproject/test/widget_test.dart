import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:miniproject/main.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('dashboard TabungKu menampilkan ringkasan aktivitas', (
    tester,
  ) async {
    await tester.pumpWidget(const TabungKuApp());

    expect(find.text('TabungKu'), findsWidgets);
    expect(find.text('Aktivitas hari ini'), findsOneWidget);
    expect(find.text('Saldo tercatat'), findsOneWidget);
  });

  testWidgets('pengguna dapat membuka laporan dan form aktivitas', (
    tester,
  ) async {
    await tester.pumpWidget(const TabungKuApp());

    await tester.tap(find.text('Laporan'));
    await tester.pumpAndSettle();
    expect(find.text('Pengeluaran per kategori'), findsOneWidget);

    await tester.tap(find.text('Aktivitas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah aktivitas'), findsOneWidget);
    expect(find.text('Simpan aktivitas'), findsOneWidget);
  });
}
