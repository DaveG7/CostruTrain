import 'package:flutter/foundation.dart';
import 'step_mode.dart';

// Sentinel for nullable copyWith fields — distinguishes "set to null" from "keep existing".
const _kKeep = Object();

sealed class WorkoutStep {
  final String id;
  final int orderIndex;
  const WorkoutStep({required this.id, required this.orderIndex});
}

@immutable
class ExerciseStep extends WorkoutStep {
  final String exerciseId;
  final StepMode mode;
  final int? sets;
  final int? reps;
  final int? workSeconds;
  final int restSeconds;
  final String? tempo;
  final bool isConfigured;

  const ExerciseStep({
    required super.id,
    required super.orderIndex,
    required this.exerciseId,
    required this.mode,
    this.sets,
    this.reps,
    this.workSeconds,
    required this.restSeconds,
    this.tempo,
    this.isConfigured = false,
  });

  ExerciseStep copyWith({
    String? id,
    int? orderIndex,
    String? exerciseId,
    StepMode? mode,
    Object? sets = _kKeep,
    Object? reps = _kKeep,
    Object? workSeconds = _kKeep,
    int? restSeconds,
    Object? tempo = _kKeep,
    bool? isConfigured,
    bool clearTempo = false,
  }) =>
      ExerciseStep(
        id: id ?? this.id,
        orderIndex: orderIndex ?? this.orderIndex,
        exerciseId: exerciseId ?? this.exerciseId,
        mode: mode ?? this.mode,
        sets: identical(sets, _kKeep) ? this.sets : sets as int?,
        reps: identical(reps, _kKeep) ? this.reps : reps as int?,
        workSeconds: identical(workSeconds, _kKeep) ? this.workSeconds : workSeconds as int?,
        restSeconds: restSeconds ?? this.restSeconds,
        tempo: clearTempo ? null : (identical(tempo, _kKeep) ? this.tempo : tempo as String?),
        isConfigured: isConfigured ?? this.isConfigured,
      );
}

@immutable
class RestStep extends WorkoutStep {
  final int durationSeconds;
  const RestStep({
    required super.id,
    required super.orderIndex,
    required this.durationSeconds,
  });
}

@immutable
class CountdownStep extends WorkoutStep {
  final int durationSeconds;
  const CountdownStep({
    required super.id,
    required super.orderIndex,
    required this.durationSeconds,
  });
}

@immutable
class CircuitBlock extends WorkoutStep {
  final int rounds;
  final List<ExerciseStep> steps;
  const CircuitBlock({
    required super.id,
    required super.orderIndex,
    required this.rounds,
    required this.steps,
  });

  CircuitBlock copyWith({int? rounds, List<ExerciseStep>? steps}) => CircuitBlock(
        id: id,
        orderIndex: orderIndex,
        rounds: rounds ?? this.rounds,
        steps: steps ?? this.steps,
      );
}
