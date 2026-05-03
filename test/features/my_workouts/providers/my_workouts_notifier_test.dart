import 'package:costrutrain/core/models/workout.dart';
import 'package:costrutrain/data/repositories/drift_workout_repository.dart';
import 'package:costrutrain/data/repositories/workout_repository.dart';
import 'package:costrutrain/features/my_workouts/providers/my_workouts_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements WorkoutRepository {
  final List<Workout> initial;
  final deletedIds = <String>[];

  _FakeRepo(this.initial);

  @override Future<List<Workout>> getAll() async => initial;
  @override Future<Workout?> getById(String id) async =>
      initial.firstWhere((w) => w.id == id, orElse: () => throw StateError(''));
  @override Future<Workout> save(Workout w) async {
    initial.add(w); return w;
  }
  @override Future<void> delete(String id) async => deletedIds.add(id);
}

Workout _w(String id, String name) => Workout(
      id: id, name: name, tags: const [], steps: const [],
      createdAt: DateTime(2026), updatedAt: DateTime(2026),
    );

ProviderContainer _container(_FakeRepo repo) => ProviderContainer(
      overrides: [workoutRepositoryProvider.overrideWithValue(repo)],
    );

void main() {
  group('MyWorkoutsNotifier', () {
    test('initial load returns all workouts', () async {
      final repo = _FakeRepo([_w('w1', 'A'), _w('w2', 'B')]);
      final c = _container(repo);
      addTearDown(c.dispose);
      final state = await c.read(myWorkoutsNotifierProvider.future);
      expect(state.length, 2);
    });

    test('scheduleDelete removes workout from list immediately', () async {
      final repo = _FakeRepo([_w('w1', 'A')]);
      final c = _container(repo);
      addTearDown(c.dispose);
      await c.read(myWorkoutsNotifierProvider.future);
      c.read(myWorkoutsNotifierProvider.notifier).scheduleDelete('w1');
      final state = c.read(myWorkoutsNotifierProvider).value!;
      expect(state, isEmpty);
      expect(repo.deletedIds, isEmpty); // not committed yet
    });

    test('undoDelete restores workout before timer fires', () async {
      final repo = _FakeRepo([_w('w1', 'A')]);
      final c = _container(repo);
      addTearDown(c.dispose);
      await c.read(myWorkoutsNotifierProvider.future);
      c.read(myWorkoutsNotifierProvider.notifier).scheduleDelete('w1');
      c.read(myWorkoutsNotifierProvider.notifier).undoDelete('w1');
      expect(repo.deletedIds, isEmpty);
    });

    test('commitPendingDelete calls repo.delete', () async {
      final repo = _FakeRepo([_w('w1', 'A')]);
      final c = _container(repo);
      addTearDown(c.dispose);
      await c.read(myWorkoutsNotifierProvider.future);
      c.read(myWorkoutsNotifierProvider.notifier).scheduleDelete('w1');
      // Simulate timer expiry by calling commit directly
      await c.read(myWorkoutsNotifierProvider.notifier).commitPendingDelete('w1');
      expect(repo.deletedIds, contains('w1'));
    });
  });
}
