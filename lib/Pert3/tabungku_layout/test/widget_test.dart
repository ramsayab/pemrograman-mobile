import 'package:flutter_test/flutter_test.dart';

import 'package:tabungku_layout/main.dart';

void main() {
  testWidgets('menampilkan ringkasan tabungan', (WidgetTester tester) async {
    await tester.pumpWidget(const TabungKuApp());

    expect(find.text('Ringkasan Tabungan'), findsOneWidget);
    expect(find.text('Tabungan Kuliah'), findsOneWidget);
    expect(find.text('Transaksi Terbaru'), findsOneWidget);
    expect(find.text('Menabung rutin'), findsNWidgets(2));
    expect(find.text('Beli buku kuliah'), findsOneWidget);
  });
}
