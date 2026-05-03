import 'package:costrutrain/core/models/step_mode.dart';
import 'package:costrutrain/core/models/workout.dart';
import 'package:costrutrain/core/models/workout_step.dart';
import 'package:costrutrain/data/repositories/workout_repository.dart';
import 'package:costrutrain/data/services/workout_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements WorkoutRepository {
  final Map<String, Workout> _store = {};

  @override
  Future<List<Workout>> getAll() async => _store.values.toList();

  @override
  Future<Workout?> getById(String id) async => _store[id];

  @override
  Future<Workout> save(Workout w) async {
    _store[w.id] = w;
    return w;
  }

  @override
  Future<void> delete(String id) async => _store.remove(id);
}

void main() {
  late _FakeRepo repo;
  late WorkoutService service;

  setUp(() {
    repo = _FakeRepo();
    service = WorkoutService(repo);
  });

  test('duplicate creates new UUID and appends (copy) to name', () async {
    final now = DateTime(2026);
    final original = Workout(
      id: 'orig', name: 'Fran', tags: const ['Classic'],
      steps: const [], createdAt: now, updatedAt: now,
    );
    await repo.save(original);

    final copy = await service.duplicate('orig');

    expect(copy.id, isNot('orig'));
    expect(copy.name, 'Fran (copy)');
    expect(copy.tags, ['Classic']);
  });

  test('duplicate deep-copies steps with new UUIDs', () async {
    final now = DateTime(2026);
    const step = ExerciseStep(
      id: 'step1', orderIndex: 0, exerciseId: 'ex1',
      mode: StepMode.reps, reps: 10, restSeconds: 60,
    );
    final original = Workout(
      id: 'orig', name: 'Workout', tags: const [],
      steps: const [step], createdAt: now, updatedAt: now,
    );
    await repo.save(original);

    final copy = await service.duplicate('orig');

    final copyStep = copy.steps.first as ExerciseStep;
    expect(copyStep.id, isNot('step1'));
    expect(copyStep.reps, 10);
  });

  test('duplicate throws StateError for unknown id', () {
    expect(() => service.duplicate('ghost'), throwsA(isA<StateError>()));
  });

  test('estimateDuration returns null (Phase 4 stub)', () {
    final now = DateTime(2026);
    final w = Workout(
      id: 'w1', name: 'W', tags: const [],
      steps: const [], createdAt: now, updatedAt: now,
    );
    expect(service.estimateDuration(w), isNull);
  });
}
