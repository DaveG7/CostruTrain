import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../core/models/workout.dart';
import '../../core/models/workout_step.dart';
import '../repositories/drift_workout_repository.dart';
import '../repositories/workout_repository.dart';

part 'workout_service.g.dart';

class WorkoutService {
  const WorkoutService(this._repo);
  final WorkoutRepository _repo;

  Future<Workout> duplicate(String id) async {
    final source = await _repo.getById(id);
    if (source == null) throw StateError('Workout $id not found');
    final now = DateTime.now();
    final copy = Workout(
      id: const Uuid().v4(),
      name: '${source.name} (copy)',
      description: source.description,
      tags: List.unmodifiable(source.tags),
      globalRestSeconds: source.globalRestSeconds,
      warmupSeconds: source.warmupSeconds,
      cooldownSeconds: source.cooldownSeconds,
      steps: _cloneSteps(source.steps),
      createdAt: now,
      updatedAt: now,
    );
    return _repo.save(copy);
  }

  // Phase 4: full time estimation. Returns null until then.
  int? estimateDuration(Workout workout) => null;

  List<WorkoutStep> _cloneSteps(List<WorkoutStep> steps) =>
      steps.map((s) => switch (s) {
            ExerciseStep() => s.copyWith(id: const Uuid().v4()),
            RestStep() => RestStep(
                id: const Uuid().v4(),
                orderIndex: s.orderIndex,
                durationSeconds: s.durationSeconds,
              ),
            CountdownStep() => CountdownStep(
                id: const Uuid().v4(),
                orderIndex: s.orderIndex,
                durationSeconds: s.durationSeconds,
              ),
            CircuitBlock() => CircuitBlock(
                id: const Uuid().v4(),
                orderIndex: s.orderIndex,
                rounds: s.rounds,
                steps: s.steps
                    .map((c) => c.copyWith(id: const Uuid().v4()))
                    .toList(),
              ),
          }).toList();
}

@Riverpod(keepAlive: true)
WorkoutService workoutService(WorkoutServiceRef ref) =>
    WorkoutService(ref.read(workoutRepositoryProvider));
