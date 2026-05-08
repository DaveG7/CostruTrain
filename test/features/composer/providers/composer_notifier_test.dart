import 'package:costrutrain/core/models/exercise.dart';
import 'package:costrutrain/core/models/step_mode.dart';
import 'package:costrutrain/core/models/workout.dart';
import 'package:costrutrain/core/models/workout_step.dart';
import 'package:costrutrain/data/repositories/drift_workout_repository.dart';
import 'package:costrutrain/data/repositories/workout_repository.dart';
import 'package:costrutrain/features/composer/providers/composer_notifier.dart';
import 'package:costrutrain/features/settings/providers/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Minimal in-memory repo for notifier tests
class _FakeRepo implements WorkoutRepository {
  final Map<String, Workout> store = {};

  @override
  Future<List<Workout>> getAll() async => store.values.toList();

  @override
  Future<Workout?> getById(String id) async => store[id];

  @override
  Future<Workout> save(Workout w) async {
    store[w.id] = w;
    return w;
  }

  @override
  Future<void> delete(String id) async => store.remove(id);
}

// Fake SettingsNotifier for tests
class _FakeSettingsNotifier extends SettingsNotifier {
  @override
  SettingsState build() => const SettingsState(
        audioCuesEnabled: true,
        hapticsEnabled: true,
        defaultRestTime: 60,
      );
}

Exercise _exercise({String id = 'ex1', String bodyPart = 'back'}) => Exercise(
      id: id,
      source: 'exercisedb',
      name: 'Pull-up',
      bodyPart: bodyPart,
      targetPrimary: 'lats',
      equipment: 'body weight',
    );

ProviderContainer _container(_FakeRepo repo) => ProviderContainer(
      overrides: [
        workoutRepositoryProvider.overrideWithValue(repo),
        settingsNotifierProvider.overrideWith(
          () => _FakeSettingsNotifier(),
        ),
      ],
    );

void main() {
  group('ComposerNotifier', () {
    test('addExerciseStep non-cardio: mode=reps, sets=3, reps=10, rest=60', () {
      final c = _container(_FakeRepo());
      addTearDown(c.dispose);
      c.read(composerNotifierProvider.notifier).addExerciseStep(_exercise());
      final step = c.read(composerNotifierProvider).draft.steps.first as ExerciseStep;
      expect(step.mode, StepMode.reps);
      expect(step.sets, 3);
      expect(step.reps, 10);
      expect(step.restSeconds, 60);
      expect(step.isConfigured, false);
    });

    test('addExerciseStep cardio: mode=timed, work=60, rest=30', () {
      final c = _container(_FakeRepo());
      addTearDown(c.dispose);
      c.read(composerNotifierProvider.notifier).addExerciseStep(_exercise(bodyPart: 'cardio'));
      final step = c.read(composerNotifierProvider).draft.steps.first as ExerciseStep;
      expect(step.mode, StepMode.timed);
      expect(step.workSeconds, 60);
      expect(step.restSeconds, 30);
    });

    test('addRestStep appends a RestStep', () {
      final c = _container(_FakeRepo());
      addTearDown(c.dispose);
      c.read(composerNotifierProvider.notifier).addRestStep();
      expect(c.read(composerNotifierProvider).draft.steps.first, isA<RestStep>());
    });

    test('removeStep removes by id and marks isDirty', () {
      final c = _container(_FakeRepo());
      addTearDown(c.dispose);
      c.read(composerNotifierProvider.notifier).addRestStep();
      final id = c.read(composerNotifierProvider).draft.steps.first.id;
      c.read(composerNotifierProvider.notifier).removeStep(id);
      expect(c.read(composerNotifierProvider).draft.steps, isEmpty);
      expect(c.read(composerNotifierProvider).isDirty, true);
    });

    test('wrapInCircuit wraps contiguous ExerciseSteps', () {
      final c = _container(_FakeRepo());
      addTearDown(c.dispose);
      final n = c.read(composerNotifierProvider.notifier);
      n.addExerciseStep(_exercise(id: 'ex1'));
      n.addExerciseStep(_exercise(id: 'ex2'));
      n.wrapInCircuit(0, 1, 3);
      final steps = c.read(composerNotifierProvider).draft.steps;
      expect(steps.length, 1);
      expect(steps.first, isA<CircuitBlock>());
      expect((steps.first as CircuitBlock).rounds, 3);
      expect((steps.first as CircuitBlock).steps.length, 2);
    });

    test('wrapInCircuit throws if any step is not ExerciseStep', () {
      final c = _container(_FakeRepo());
      addTearDown(c.dispose);
      final n = c.read(composerNotifierProvider.notifier);
      n.addExerciseStep(_exercise());
      n.addRestStep();
      expect(() => n.wrapInCircuit(0, 1, 3), throwsA(isA<ArgumentError>()));
    });

    test('reorderSteps moves step to new position', () {
      final c = _container(_FakeRepo());
      addTearDown(c.dispose);
      final n = c.read(composerNotifierProvider.notifier);
      n.addExerciseStep(_exercise(id: 'ex1'));
      n.addRestStep();
      n.reorderSteps(0, 2); // move first to end
      final steps = c.read(composerNotifierProvider).draft.steps;
      expect(steps.first, isA<RestStep>());
    });

    test('discardDraft resets to clean state', () {
      final c = _container(_FakeRepo());
      addTearDown(c.dispose);
      final n = c.read(composerNotifierProvider.notifier);
      n.addRestStep();
      expect(c.read(composerNotifierProvider).isDirty, true);
      n.discardDraft();
      expect(c.read(composerNotifierProvider).draft.steps, isEmpty);
      expect(c.read(composerNotifierProvider).isDirty, false);
    });

    test('save() persists draft and reloads canonical, clears isDirty', () async {
      final repo = _FakeRepo();
      final c = _container(repo);
      addTearDown(c.dispose);
      final n = c.read(composerNotifierProvider.notifier);
      n.updateMeta(name: 'Morning WOD');
      await n.save();
      expect(c.read(composerNotifierProvider).isDirty, false);
      expect(c.read(composerNotifierProvider).draft.name, 'Morning WOD');
      expect(repo.store.length, 1);
    });
  });
}
