import 'dart:convert';

import 'package:costrutrain/core/models/step_mode.dart';
import 'package:costrutrain/core/models/workout.dart';
import 'package:costrutrain/core/models/workout_step.dart';
import 'package:costrutrain/data/local/app_database.dart';

class WorkoutMapper {
  WorkoutMapper._();

  static Workout fromRows({
    required WorkoutRow workout,
    required List<WorkoutStepRow> stepRows,
  }) {
    for (final row in stepRows) {
      if (row.nestingDepth > 1) {
        throw StateError(
          'Nested circuits not supported: step ${row.id} has nestingDepth ${row.nestingDepth}',
        );
      }
    }

    final topLevel = stepRows
        .where((r) => r.parentStepId == null)
        .toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    final byParent = <String, List<WorkoutStepRow>>{};
    for (final row in stepRows.where((r) => r.parentStepId != null)) {
      byParent.putIfAbsent(row.parentStepId!, () => []).add(row);
    }

    final topLevelIds = {for (final r in topLevel) r.id};
    for (final parentId in byParent.keys) {
      if (!topLevelIds.contains(parentId)) {
        throw StateError(
          'Orphan parentStepId: $parentId references no top-level step',
        );
      }
    }

    return Workout(
      id: workout.id,
      name: workout.name,
      description: workout.description,
      tags: (jsonDecode(workout.tags) as List<dynamic>).cast<String>(),
      globalRestSeconds: workout.globalRestS,
      warmupSeconds: workout.warmupSeconds,
      cooldownSeconds: workout.cooldownS,
      steps: topLevel.map((r) => _mapStep(r, byParent)).toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(workout.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(workout.updatedAt),
    );
  }

  static WorkoutStep _mapStep(
    WorkoutStepRow row,
    Map<String, List<WorkoutStepRow>> byParent,
  ) =>
      switch (row.type) {
        'exercise' => ExerciseStep(
            id: row.id,
            orderIndex: row.orderIndex,
            exerciseId: row.exerciseId!,
            mode: StepMode.values.byName(row.stepMode!),
            sets: row.sets,
            reps: row.reps,
            workSeconds: row.workSeconds,
            restSeconds: row.restSeconds ?? 0,
            tempo: row.tempo,
            isConfigured: row.isConfigured,
          ),
        'rest' => RestStep(
            id: row.id,
            orderIndex: row.orderIndex,
            durationSeconds: row.workSeconds ?? 0,
          ),
        'countdown' => CountdownStep(
            id: row.id,
            orderIndex: row.orderIndex,
            durationSeconds: row.workSeconds ?? 0,
          ),
        'circuit' => CircuitBlock(
            id: row.id,
            orderIndex: row.orderIndex,
            rounds: row.circuitRounds!,
            steps: ((byParent[row.id] ?? [])
                  ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex)))
                .map((c) => _mapStep(c, byParent) as ExerciseStep)
                .toList(),
          ),
        _ => throw StateError('Unknown step type: ${row.type}'),
      };

  static String encodeTags(List<String> tags) => jsonEncode(tags);
}
