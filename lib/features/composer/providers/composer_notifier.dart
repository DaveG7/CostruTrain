import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/exercise.dart';
import '../../../core/models/step_mode.dart';
import '../../../core/models/workout.dart';
import '../../../core/models/workout_step.dart';
import '../../../data/repositories/drift_workout_repository.dart';
import '../../settings/providers/settings_notifier.dart';

part 'composer_notifier.g.dart';

@immutable
class ComposerState {
  final Workout draft;
  final bool isDirty;
  const ComposerState({required this.draft, required this.isDirty});
  ComposerState copyWith({Workout? draft, bool? isDirty}) =>
      ComposerState(draft: draft ?? this.draft, isDirty: isDirty ?? this.isDirty);
}

@Riverpod(keepAlive: true)
class ComposerNotifier extends _$ComposerNotifier {
  @override
  ComposerState build() {
    final now = DateTime.now();
    return ComposerState(
      draft: Workout(
        id: const Uuid().v4(),
        name: '',
        tags: const [],
        steps: const [],
        createdAt: now,
        updatedAt: now,
      ),
      isDirty: false,
    );
  }

  void loadWorkout(Workout workout) {
    state = ComposerState(draft: workout, isDirty: false);
  }

  void addExerciseStep(Exercise ex) {
    final isCardio = ex.bodyPart.toLowerCase() == 'cardio';
    final step = ExerciseStep(
      id: const Uuid().v4(),
      orderIndex: state.draft.steps.length,
      exerciseId: ex.id,
      mode: isCardio ? StepMode.timed : StepMode.reps,
      sets: isCardio ? null : 3,
      reps: isCardio ? null : 10,
      workSeconds: isCardio ? 60 : null,
      restSeconds: isCardio ? 30 : 60,
      isConfigured: false,
    );
    _patch(state.draft.copyWith(steps: [...state.draft.steps, step]));
  }

  void addRestStep() {
    final defaultRest = state.draft.globalRestSeconds ??
        ref.read(settingsNotifierProvider).defaultRestTime;
    final step = RestStep(
      id: const Uuid().v4(),
      orderIndex: state.draft.steps.length,
      durationSeconds: defaultRest,
    );
    _patch(state.draft.copyWith(steps: [...state.draft.steps, step]));
  }

  void addCountdownStep() {
    final step = CountdownStep(
      id: const Uuid().v4(),
      orderIndex: state.draft.steps.length,
      durationSeconds: 10,
    );
    _patch(state.draft.copyWith(steps: [...state.draft.steps, step]));
  }

  void wrapInCircuit(int fromIndex, int toIndex, int rounds) {
    final steps = state.draft.steps;
    final selected = steps.sublist(fromIndex, toIndex + 1);
    if (selected.any((s) => s is! ExerciseStep)) {
      throw ArgumentError('wrapInCircuit: all selected steps must be ExerciseStep');
    }
    final circuit = CircuitBlock(
      id: const Uuid().v4(),
      orderIndex: fromIndex,
      rounds: rounds,
      steps: selected.cast<ExerciseStep>(),
    );
    _patch(state.draft.copyWith(
      steps: _reindex([
        ...steps.sublist(0, fromIndex),
        circuit,
        ...steps.sublist(toIndex + 1),
      ]),
    ));
  }

  void updateStep(WorkoutStep step) {
    _patch(state.draft.copyWith(
      steps: state.draft.steps.map((s) => s.id == step.id ? step : s).toList(),
    ));
  }

  void removeStep(String id) {
    _patch(state.draft.copyWith(
      steps: _reindex(state.draft.steps.where((s) => s.id != id).toList()),
    ));
  }

  void reorderSteps(int oldIndex, int newIndex) {
    final steps = [...state.draft.steps];
    if (newIndex > oldIndex) newIndex--;
    final moved = steps.removeAt(oldIndex);
    steps.insert(newIndex, moved);
    _patch(state.draft.copyWith(steps: _reindex(steps)));
  }

  void updateMeta({
    String? name,
    String? description,
    List<String>? tags,
    int? globalRestSeconds,
  }) {
    _patch(Workout(
      id: state.draft.id,
      name: name ?? state.draft.name,
      description: description ?? state.draft.description,
      tags: tags ?? state.draft.tags,
      globalRestSeconds: globalRestSeconds ?? state.draft.globalRestSeconds,
      warmupSeconds: state.draft.warmupSeconds,
      cooldownSeconds: state.draft.cooldownSeconds,
      steps: state.draft.steps,
      createdAt: state.draft.createdAt,
      updatedAt: DateTime.now(),
    ));
  }

  Future<void> save() async {
    final repo = ref.read(workoutRepositoryProvider);
    await repo.save(state.draft);
    final canonical = await repo.getById(state.draft.id);
    state = ComposerState(draft: canonical!, isDirty: false);
  }

  void discardDraft() => state = build();

  void _patch(Workout draft) {
    state = ComposerState(draft: draft, isDirty: true);
  }

  List<WorkoutStep> _reindex(List<WorkoutStep> steps) {
    return steps.indexed
        .map((e) => switch (e.$2) {
              ExerciseStep s => s.copyWith(orderIndex: e.$1),
              RestStep s =>
                RestStep(id: s.id, orderIndex: e.$1, durationSeconds: s.durationSeconds),
              CountdownStep s =>
                CountdownStep(id: s.id, orderIndex: e.$1, durationSeconds: s.durationSeconds),
              CircuitBlock s => CircuitBlock(
                  id: s.id, orderIndex: e.$1, rounds: s.rounds, steps: s.steps),
            })
        .toList();
  }
}
