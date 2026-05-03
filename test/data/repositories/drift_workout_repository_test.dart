import 'package:costrutrain/core/models/step_mode.dart';
import 'package:costrutrain/core/models/workout.dart';
import 'package:costrutrain/core/models/workout_step.dart';
import 'package:costrutrain/data/local/app_database.dart';
import 'package:costrutrain/data/repositories/drift_workout_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

Workout _basicWorkout({String id = 'w1', String name = 'Test Workout'}) => Workout(
      id: id,
      name: name,
      tags: const ['CrossFit'],
      steps: const [],
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

void main() {
  late AppDatabase db;
  late DriftWorkoutRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftWorkoutRepository(db);
  });

  tearDown(() => db.close());

  test('save and getById round-trip preserves name and tags', () async {
    await repo.save(_basicWorkout());
    final loaded = await repo.getById('w1');
    expect(loaded?.name, 'Test Workout');
    expect(loaded?.tags, ['CrossFit']);
  });

  test('save is an upsert — second save updates name', () async {
    await repo.save(_basicWorkout());
    await repo.save(_basicWorkout(name: 'Updated'));
    final loaded = await repo.getById('w1');
    expect(loaded?.name, 'Updated');
  });

  test('getAll returns all saved workouts', () async {
    await repo.save(_basicWorkout(id: 'w1', name: 'A'));
    await repo.save(_basicWorkout(id: 'w2', name: 'B'));
    final all = await repo.getAll();
    expect(all.length, 2);
  });

  test('save with ExerciseStep round-trips step fields', () async {
    const step = ExerciseStep(
      id: 's1', orderIndex: 0, exerciseId: 'ex1',
      mode: StepMode.reps, sets: 3, reps: 10, restSeconds: 60,
    );
    await repo.save(_basicWorkout().copyWith(steps: [step]));
    final loaded = await repo.getById('w1');
    final loadedStep = loaded!.steps.first as ExerciseStep;
    expect(loadedStep.mode, StepMode.reps);
    expect(loadedStep.reps, 10);
    expect(loadedStep.sets, 3);
  });

  test('save replaces steps on second save', () async {
    const s1 = ExerciseStep(
      id: 's1', orderIndex: 0, exerciseId: 'ex1',
      mode: StepMode.reps, reps: 10, restSeconds: 60,
    );
    await repo.save(_basicWorkout().copyWith(steps: [s1]));
    await repo.save(_basicWorkout().copyWith(steps: const []));
    final loaded = await repo.getById('w1');
    expect(loaded!.steps, isEmpty);
  });

  test('delete removes workout', () async {
    await repo.save(_basicWorkout());
    await repo.delete('w1');
    expect(await repo.getById('w1'), isNull);
  });

  test('getById returns null for unknown id', () async {
    expect(await repo.getById('nope'), isNull);
  });
}
