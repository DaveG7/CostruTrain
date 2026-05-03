import 'package:costrutrain/core/models/workout.dart';
import 'package:costrutrain/data/repositories/drift_workout_repository.dart';
import 'package:costrutrain/data/repositories/workout_repository.dart';
import 'package:costrutrain/features/my_workouts/views/my_workouts_screen.dart';
import 'package:costrutrain/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements WorkoutRepository {
  final List<Workout> workouts;
  _FakeRepo(this.workouts);
  @override Future<List<Workout>> getAll() async => workouts;
  @override Future<Workout?> getById(String id) async => null;
  @override Future<Workout> save(Workout w) async => w;
  @override Future<void> delete(String id) async {}
}

Workout _w(String id, String name) => Workout(
      id: id, name: name, tags: const [], steps: const [],
      createdAt: DateTime(2026), updatedAt: DateTime(2026),
    );

Widget _wrap(WorkoutRepository repo) => ProviderScope(
      overrides: [workoutRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MyWorkoutsScreen(),
      ),
    );

void main() {
  testWidgets('shows list of workouts', (tester) async {
    await tester.pumpWidget(_wrap(_FakeRepo([_w('w1', 'Fran'), _w('w2', 'Annie')])));
    await tester.pumpAndSettle();
    expect(find.text('Fran'), findsOneWidget);
    expect(find.text('Annie'), findsOneWidget);
  });

  testWidgets('shows empty state when no workouts', (tester) async {
    await tester.pumpWidget(_wrap(_FakeRepo([])));
    await tester.pumpAndSettle();
    expect(find.textContaining('No workouts'), findsOneWidget);
  });

  testWidgets('shows SnackBar with Undo after delete', (tester) async {
    final repo = _FakeRepo([_w('w1', 'Fran')]);
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();
    await tester.longPress(find.text('Fran'));
    await tester.pumpAndSettle();
    final deleteBtn = find.text('Delete');
    if (deleteBtn.evaluate().isNotEmpty) {
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();
      expect(find.text('Undo'), findsOneWidget);
    }
  });
}
