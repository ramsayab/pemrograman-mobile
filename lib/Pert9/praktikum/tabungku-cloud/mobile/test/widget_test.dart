import 'package:flutter_test/flutter_test.dart';
import 'package:tabungku/main.dart';

void main() {
  testWidgets('beranda menampilkan tautan status dan pengaturan', (tester) async {
    await tester.pumpWidget(const TabungKuApp());

    expect(find.text('TabungKu'), findsOneWidget);
    expect(find.text('Status server'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);
  });
}
