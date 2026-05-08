import 'package:costrutrain/core/models/step_mode.dart';
import 'package:costrutrain/core/models/workout.dart';
import 'package:costrutrain/core/models/workout_step.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseStep.copyWith', () {
    test('preserves unchanged fields', () {
      const step = ExerciseStep(
        id: 'e1', orderIndex: 0, exerciseId: 'ex1',
        mode: StepMode.reps, reps: 10, restSeconds: 60,
      );
      final updated = step.copyWith(reps: 12);
      expect(updated.reps, 12);
      expect(updated.id, 'e1');
      expect(updated.mode, StepMode.reps);
    });

    test('copyWith can clear tempo to null', () {
      const step = ExerciseStep(
        id: 'e1', orderIndex: 0, exerciseId: 'ex1',
        mode: StepMode.reps, reps: 10, restSeconds: 60, tempo: '3-1-2',
      );
      final updated = step.copyWith(tempo: null, clearTempo: true);
      expect(updated.tempo, isNull);
    });
  });

  group('Workout.copyWith', () {
    test('replaces steps, preserves other fields', () {
      final now = DateTime(2026);
      final w = Workout(
        id: 'w1', name: 'Test', tags: const [],
        steps: const [], createdAt: now, updatedAt: now,
      );
      const rest = RestStep(id: 'r1', orderIndex: 0, durationSeconds: 30);
      final updated = w.copyWith(steps: [rest]);
      expect(updated.steps, [rest]);
      expect(updated.name, 'Test');
    });
  });

  group('CircuitBlock', () {
    test('steps are typed as List<ExerciseStep>', () {
      const step = ExerciseStep(
        id: 's1', orderIndex: 0, exerciseId: 'ex1',
        mode: StepMode.reps, reps: 10, restSeconds: 60,
      );
      const circuit = CircuitBlock(id: 'c1', orderIndex: 0, rounds: 3, steps: [step]);
      expect(circuit.steps.first, isA<ExerciseStep>());
    });
  });

  group('Workout.isTemplate and templateId', () {
    test('isTemplate defaults to false', () {
      final w = Workout(
        id: 'w1',
        name: 'Test',
        tags: const [],
        steps: const [],
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      expect(w.isTemplate, isFalse);
      expect(w.templateId, isNull);
    });

    test('copyWith preserves isTemplate when not specified', () {
      final w = Workout(
        id: 'w1',
        name: 'Test',
        tags: const [],
        steps: const [],
        isTemplate: true,
        templateId: 'fran',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      final copy = w.copyWith(name: 'Updated');
      expect(copy.isTemplate, isTrue);
      expect(copy.templateId, 'fran');
    });

    test('copyWith can override isTemplate', () {
      final w = Workout(
        id: 'w1',
        name: 'Test',
        tags: const [],
        steps: const [],
        isTemplate: true,
        templateId: 'fran',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      final copy = w.copyWith(isTemplate: false);
      expect(copy.isTemplate, isFalse);
      expect(copy.templateId, 'fran'); // templateId preserved
    });
  });
}
