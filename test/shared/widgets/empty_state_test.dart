import 'package:costrutrain/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('renders icon, message, and CTA', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(_wrap(
      EmptyState(
        icon: Icons.inbox,
        message: 'Nothing here.',
        ctaLabel: 'Do something',
        onCta: () => tapped = true,
      ),
    ));
    expect(find.byIcon(Icons.inbox), findsOneWidget);
    expect(find.text('Nothing here.'), findsOneWidget);
    expect(find.text('Do something'), findsOneWidget);
    await tester.tap(find.text('Do something'));
    expect(tapped, isTrue);
  });

  testWidgets('renders without CTA when onCta is null', (tester) async {
    await tester.pumpWidget(_wrap(
      const EmptyState(
        icon: Icons.inbox,
        message: 'Nothing here.',
      ),
    ));
    expect(find.byType(TextButton), findsNothing);
  });
}
