import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chesswar_mobile/main.dart';

void main() {
  testWidgets('Chess War mobile prototype opens home and navigates tabs',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const ChessWarApp());
    await tester.pumpAndSettle();

    // Verify Home screen is visible
    expect(find.text('Halo, Asep'), findsOneWidget);
    expect(find.text('RESUME GAME'), findsOneWidget);
    expect(find.text('MAIN SEKARANG'), findsOneWidget);

    // Tap on Arena in navbar
    await tester.tap(find.widgetWithText(InkWell, 'Arena'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih tingkat bot'), findsOneWidget);

    // Tap on LANJUT KE DRAFT
    final lanjutBtn = find.text('LANJUT KE DRAFT');
    await tester.dragUntilVisible(
      lanjutBtn,
      find.byType(ListView),
      const Offset(0, -100),
    );
    await tester.tap(lanjutBtn);
    await tester.pumpAndSettle();
    expect(find.text('PILIH 1 KARTU KEKUATAN'), findsOneWidget);

    // Tap on UNGKAP KEKUATAN
    final ungkapBtn = find.text('UNGKAP KEKUATAN');
    await tester.dragUntilVisible(
      ungkapBtn,
      find.byType(ListView),
      const Offset(0, -100),
    );
    await tester.tap(ungkapBtn);
    await tester.pumpAndSettle();
    expect(find.text('UNDYING KING'), findsOneWidget);

    // Tap on MULAI BERTANDING
    final mulaiBtn = find.text('MULAI BERTANDING');
    await tester.dragUntilVisible(
      mulaiBtn,
      find.byType(ListView),
      const Offset(0, -100),
    );
    await tester.tap(mulaiBtn);
    await tester.pumpAndSettle();
    expect(find.text('Medium (3)'), findsOneWidget);

    // Tap Back from Gameplay to Arena
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    // Tap on Puzzle in navbar
    await tester.tap(find.widgetWithText(InkWell, 'Puzzle'));
    await tester.pumpAndSettle();
    expect(find.text('Latihan Puzzle'), findsOneWidget);

    // Tap on Leaderboard in navbar
    await tester.tap(find.widgetWithText(InkWell, 'Leaderboard'));
    await tester.pumpAndSettle();
    expect(find.text('#42   Asep (Kamu)'), findsOneWidget);

    // Tap on Profil in navbar
    await tester.tap(find.widgetWithText(InkWell, 'Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Asep Surasep'), findsOneWidget);
    expect(find.text('Panel Admin'), findsOneWidget);

    // Tap on Panel Admin
    await tester.tap(find.text('Panel Admin'));
    await tester.pumpAndSettle();
    expect(find.text('AI Puzzle Generator'), findsOneWidget);

    // Tap on AI Puzzle Generator
    await tester.tap(find.text('AI Puzzle Generator'));
    await tester.pumpAndSettle();
    expect(find.text('AI GENERATE PUZZLE'), findsOneWidget);
  });
}
