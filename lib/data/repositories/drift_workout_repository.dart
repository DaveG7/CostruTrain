import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/workout.dart';
import '../../core/models/workout_step.dart';
import '../local/app_database.dart';
import 'workout_mapper.dart';
import 'workout_repository.dart';

part 'drift_workout_repository.g.dart';

class DriftWorkoutRepository implements WorkoutRepository {
  const DriftWorkoutRepository(this._db);
  final AppDatabase _db;

  @override
  Future<List<Workout>> getAll() async {
    final rows = await _db.select(_db.workouts).get();
    return Future.wait(rows.map(_loadWorkout));
  }

  @override
  Future<Workout?> getById(String id) async {
    final row = await (_db.select(_db.workouts)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return _loadWorkout(row);
  }

  Future<Workout> _loadWorkout(WorkoutRow row) async {
    final steps = await (_db.select(_db.workoutSteps)
          ..where((t) => t.workoutId.equals(row.id)))
        .get();
    return WorkoutMapper.fromRows(workout: row, stepRows: steps);
  }

  @override
  Future<Workout> save(Workout workout) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.transaction(() async {
      await _db.into(_db.workouts).insertOnConflictUpdate(WorkoutsCompanion(
            id: Value(workout.id),
            name: Value(workout.name),
            description: Value(workout.description),
            tags: Value(jsonEncode(workout.tags)),
            globalRestS: Value(workout.globalRestSeconds),
            warmupSeconds: Value(workout.warmupSeconds),
            cooldownS: Value(workout.cooldownSeconds),
            createdAt: Value(workout.createdAt.millisecondsSinceEpoch),
            updatedAt: Value(now),
          ));
      await (_db.delete(_db.workoutSteps)
            ..where((t) => t.workoutId.equals(workout.id)))
          .go();
      for (final c in _flattenSteps(workout.id, workout.steps)) {
        await _db.into(_db.workoutSteps).insert(c);
      }
    });
    return (await getById(workout.id))!;
  }

  @override
  Future<void> delete(String id) =>
      (_db.delete(_db.workouts)..where((t) => t.id.equals(id))).go();

  List<WorkoutStepsCompanion> _flattenSteps(
    String workoutId,
    List<WorkoutStep> steps, {
    String? parentStepId,
    int depth = 0,
  }) {
    final result = <WorkoutStepsCompanion>[];
    for (final step in steps) {
      result.add(_toCompanion(workoutId, step, parentStepId: parentStepId, depth: depth));
      if (step is CircuitBlock) {
        result.addAll(_flattenSteps(workoutId, step.steps,
            parentStepId: step.id, depth: depth + 1));
      }
    }
    return result;
  }

  WorkoutStepsCompanion _toCompanion(
    String workoutId,
    WorkoutStep step, {
    String? parentStepId,
    int depth = 0,
  }) =>
      switch (step) {
        ExerciseStep() => WorkoutStepsCompanion(
            id: Value(step.id),
            workoutId: Value(workoutId),
            orderIndex: Value(step.orderIndex),
            type: const Value('exercise'),
            exerciseId: Value(step.exerciseId),
            stepMode: Value(step.mode.name),
            sets: Value(step.sets),
            reps: Value(step.reps),
            workSeconds: Value(step.workSeconds),
            restSeconds: Value(step.restSeconds),
            tempo: Value(step.tempo),
            isConfigured: Value(step.isConfigured),
            parentStepId: Value(parentStepId),
            nestingDepth: Value(depth),
          ),
        RestStep() => WorkoutStepsCompanion(
            id: Value(step.id),
            workoutId: Value(workoutId),
            orderIndex: Value(step.orderIndex),
            type: const Value('rest'),
            workSeconds: Value(step.durationSeconds),
            parentStepId: Value(parentStepId),
            nestingDepth: Value(depth),
          ),
        CountdownStep() => WorkoutStepsCompanion(
            id: Value(step.id),
            workoutId: Value(workoutId),
            orderIndex: Value(step.orderIndex),
            type: const Value('countdown'),
            workSeconds: Value(step.durationSeconds),
            parentStepId: Value(parentStepId),
            nestingDepth: Value(depth),
          ),
        CircuitBlock() => WorkoutStepsCompanion(
            id: Value(step.id),
            workoutId: Value(workoutId),
            orderIndex: Value(step.orderIndex),
            type: const Value('circuit'),
            circuitRounds: Value(step.rounds),
            parentStepId: Value(parentStepId),
            nestingDepth: Value(depth),
          ),
      };
}

@Riverpod(keepAlive: true)
WorkoutRepository workoutRepository(WorkoutRepositoryRef ref) =>
    DriftWorkoutRepository(ref.read(appDatabaseProvider));
