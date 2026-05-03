import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/workout.dart';
import '../../../data/repositories/drift_workout_repository.dart';

part 'my_workouts_notifier.g.dart';

@riverpod
class MyWorkoutsNotifier extends _$MyWorkoutsNotifier {
  final Map<String, Timer> _deleteTimers = {};

  @override
  Future<List<Workout>> build() async {
    ref.onDispose(() {
      for (final t in _deleteTimers.values) {
        t.cancel();
      }
      _deleteTimers.clear();
    });
    return ref.read(workoutRepositoryProvider).getAll();
  }

  void scheduleDelete(String id) {
    state = AsyncData(state.value!.where((w) => w.id != id).toList());
    _deleteTimers[id] = Timer(
      const Duration(seconds: 4),
      () => commitPendingDelete(id),
    );
  }

  void undoDelete(String id) {
    _deleteTimers[id]?.cancel();
    _deleteTimers.remove(id);
    ref.invalidateSelf();
  }

  Future<void> commitPendingDelete(String id) async {
    _deleteTimers[id]?.cancel();
    _deleteTimers.remove(id);
    await ref.read(workoutRepositoryProvider).delete(id);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
