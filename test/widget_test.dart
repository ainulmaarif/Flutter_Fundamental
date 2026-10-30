import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/main.dart';

void main() {
  testWidgets('Dashboard renders correctly and toggle theme works', (WidgetTester tester) async {
    await tester.pumpWidget(const DashboardApp());

    expect(find.text('Academic Overview'), findsOneWidget);
    expect(find.text('Ainul'), findsOneWidget);
    expect(find.text('NIM: 23520010 • S1 Teknik Informatika'), findsOneWidget);
    expect(find.text('IPK Kumulatif'), findsOneWidget);
    expect(find.text('3.88'), findsOneWidget);
    expect(find.text('SKS Tempuh'), findsOneWidget);
    expect(find.text('84 SKS'), findsOneWidget);
    expect(find.text('Kehadiran'), findsOneWidget);
    expect(find.text('96%'), findsOneWidget);
    expect(find.text('Tugas Selesai'), findsOneWidget);
    expect(find.text('12/12'), findsOneWidget);

    // Verify and tap CupertinoSwitch
    final switchFinder = find.byType(CupertinoSwitch);
    expect(switchFinder, findsOneWidget);

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('Responsive test: screen width below 600px (narrow mobile 360x800)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    expect(find.text('Ainul'), findsOneWidget);
    expect(find.text('IPK Kumulatif'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Responsive test: ultra-narrow screen width (320x568)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    expect(find.text('Ainul'), findsOneWidget);
    expect(find.text('IPK Kumulatif'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Responsive test: screen width above breakpoint 700px (wide desktop/tablet 1024x768)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    expect(find.text('Ainul'), findsOneWidget);
    expect(find.text('IPK Kumulatif'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Accessibility test: high text scale factor (2.0x)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    expect(find.text('Ainul'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Accessibility test: Semantics labels are properly configured', (WidgetTester tester) async {
    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    // Verify Semantics label widgets
    final profileSemantics = find.byWidgetPredicate(
      (widget) => widget is Semantics && widget.properties.label == 'Profil Mahasiswa Ainul, NIM 23520010, Teknik Informatika',
    );
    expect(profileSemantics, findsOneWidget);

    final ipkSemantics = find.byWidgetPredicate(
      (widget) => widget is Semantics && widget.properties.label == 'Informasi IPK Kumulatif adalah 3.88',
    );
    expect(ipkSemantics, findsOneWidget);

    final switchSemantics = find.byWidgetPredicate(
      (widget) => widget is Semantics && widget.properties.label == 'Toggle tema gelap dan terang',
    );
    expect(switchSemantics, findsOneWidget);
  });
}
