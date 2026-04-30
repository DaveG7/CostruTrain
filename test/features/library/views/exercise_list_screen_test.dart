import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:costrutrain/core/models/exercise.dart';
import 'package:costrutrain/features/library/providers/exercises_provider.dart';
import 'package:costrutrain/features/library/views/exercise_list_screen.dart';
import 'package:costrutrain/generated/l10n/app_localizations.dart';

Widget _wrap(Widget child, List<Override> overrides) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );

final _fakeExercises = [
  const Exercise(
      id: '1',
      source: 'exercisedb',
      name: 'Push-up',
      bodyPart: 'chest',
      targetPrimary: 'pectorals',
      equipment: 'body weight'),
  const Exercise(
      id: '2',
      source: 'exercisedb',
      name: 'Squat',
      bodyPart: 'upper legs',
      targetPrimary: 'quads',
      equipment: 'body weight'),
];

void main() {
  testWidgets('renders exercise names and bodyPart chips', (tester) async {
    await tester.pumpWidget(_wrap(
      const ExerciseListScreen(),
      [exercisesProvider.overrideWith((ref) async => _fakeExercises)],
    ));
    await tester.pump();
    expect(find.text('Push-up'), findsOneWidget);
    expect(find.text('Squat'), findsOneWidget);
    expect(find.text('chest'), findsOneWidget);
    expect(find.text('upper legs'), findsOneWidget);
  });

  testWidgets('shows empty state when list is empty', (tester) async {
    await tester.pumpWidget(_wrap(
      const ExerciseListScreen(),
      [exercisesProvider.overrideWith((ref) async => [])],
    ));
    await tester.pump();
    expect(find.byType(ListView), findsNothing);
  });
}
