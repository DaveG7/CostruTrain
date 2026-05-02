import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/core/models/exercise.dart';
import 'package:costrutrain/shared/widgets/ct_exercise_card.dart';
import 'package:costrutrain/shared/theme/app_theme.dart';

void main() {
  const exercise = Exercise(
    id: '1',
    source: 'exercisedb',
    name: 'Barbell Curl',
    bodyPart: 'upper arms',
    targetPrimary: 'biceps',
    equipment: 'barbell',
  );

  testWidgets('displays exercise name, bodyPart, and equipment', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: CTExerciseCard(
          exercise: exercise,
          onTap: () {},
        ),
      ),
    ));

    expect(find.text('Barbell Curl'), findsOneWidget);
    expect(find.text('upper arms'), findsOneWidget);
    expect(find.text('barbell'), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: CTExerciseCard(
          exercise: exercise,
          onTap: () => tapped = true,
        ),
      ),
    ));

    await tester.tap(find.byType(CTExerciseCard));
    expect(tapped, isTrue);
  });
}
