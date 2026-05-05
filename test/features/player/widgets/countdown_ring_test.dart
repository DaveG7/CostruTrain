import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/core/player/player_phase.dart';
import 'package:costrutrain/features/player/widgets/countdown_ring.dart';

Widget _wrap(Widget w) => MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(body: Center(child: w)),
    );

void main() {
  testWidgets('renders without error in countdown phase', (tester) async {
    await tester.pumpWidget(_wrap(
      const CountdownRing(
        phase: PlayerPhase.countdown,
        remainingSeconds: 3,
        totalSeconds: 3,
        isCountingUp: false,
      ),
    ));
    expect(find.byType(CountdownRing), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('renders mm:ss in working phase', (tester) async {
    await tester.pumpWidget(_wrap(
      const CountdownRing(
        phase: PlayerPhase.working,
        remainingSeconds: 90,
        totalSeconds: 180,
        isCountingUp: false,
      ),
    ));
    expect(find.text('1:30'), findsOneWidget);
    expect(find.text('REMAINING'), findsOneWidget);
  });

  testWidgets('shows ELAPSED label for AMRAP', (tester) async {
    await tester.pumpWidget(_wrap(
      const CountdownRing(
        phase: PlayerPhase.working,
        remainingSeconds: 45,
        totalSeconds: 0,
        isCountingUp: true,
      ),
    ));
    expect(find.text('ELAPSED'), findsOneWidget);
  });

  testWidgets('resting phase shows REMAINING label', (tester) async {
    await tester.pumpWidget(_wrap(
      const CountdownRing(
        phase: PlayerPhase.resting,
        remainingSeconds: 30,
        totalSeconds: 60,
        isCountingUp: false,
      ),
    ));
    expect(find.text('REMAINING'), findsOneWidget);
    expect(find.text('0:30'), findsOneWidget);
  });
}
