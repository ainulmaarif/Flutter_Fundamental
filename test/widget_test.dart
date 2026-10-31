import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/main.dart';

void main() {
  testWidgets('Can open an item detail and return home', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);

    await tester.tap(find.text('Item 1'));
    await tester.pumpAndSettle();

    expect(find.text('Detail 1'), findsOneWidget);
    expect(find.text('Anda membuka item dengan id: 1'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
  });
}
