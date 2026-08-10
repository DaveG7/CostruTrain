import 'package:costrutrain/core/models/step_mode.dart';
import 'package:costrutrain/core/models/workout_step.dart';
import 'package:costrutrain/features/composer/widgets/step_config_sheet.dart';
import 'package:costrutrain/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: ThemeData.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

const _baseStep = ExerciseStep(
  id: 's1', orderIndex: 0, exerciseId: 'ex1',
  mode: StepMode.reps, sets: 3, reps: 10, restSeconds: 60,
);

void main() {
  testWidgets('REPS mode shows Sets, Reps, Rest fields', (tester) async {
    await tester.pumpWidget(_wrap(StepConfigSheet(
      step: _baseStep,
      exerciseName: 'Pull-up',
      onSave: (_) {},
    )));
    expect(find.text('Sets'), findsOneWidget);
    expect(find.text('Reps'), findsOneWidget);
    expect(find.text('Rest'), findsOneWidget);
    expect(find.text('Duration'), findsNothing);
  });

  testWidgets('switching to TIMED mode shows Duration field', (tester) async {
    await tester.pumpWidget(_wrap(StepConfigSheet(
      step: _baseStep,
      exerciseName: 'Pull-up',
      onSave: (_) {},
    )));
    await tester.tap(find.text('Timed'));
    await tester.pumpAndSettle();
    expect(find.text('Duration'), findsOneWidget);
    expect(find.text('Sets'), findsNothing);
  });

  testWidgets('tempo expansion shows 3 separate fields', (tester) async {
    await tester.pumpWidget(_wrap(StepConfigSheet(
      step: _baseStep,
      exerciseName: 'Pull-up',
      onSave: (_) {},
    )));
    await tester.tap(find.text('Tempo'));
    await tester.pumpAndSettle();
    expect(find.text('Eccentric'), findsOneWidget);
    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('Concentric'), findsOneWidget);
  });

  testWidgets('save callback returns updated ExerciseStep with isConfigured=true', (tester) async {
    WorkoutStep? saved;
    await tester.pumpWidget(_wrap(StepConfigSheet(
      step: _baseStep,
      exerciseName: 'Pull-up',
      onSave: (s) => saved = s,
    )));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(saved, isA<ExerciseStep>());
    expect((saved as ExerciseStep).isConfigured, isTrue);
  });

  testWidgets('tempo composed to 3-1-2 string on save', (tester) async {
    WorkoutStep? saved;
    await tester.pumpWidget(_wrap(StepConfigSheet(
      step: _baseStep,
      exerciseName: 'Pull-up',
      onSave: (s) => saved = s,
    )));
    await tester.tap(find.text('Tempo'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Eccentric'), '3');
    await tester.enterText(find.widgetWithText(TextField, 'Pause'), '1');
    await tester.enterText(find.widgetWithText(TextField, 'Concentric'), '2');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect((saved as ExerciseStep).tempo, '3-1-2');
  });
}
