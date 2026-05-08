import 'package:costrutrain/core/models/workout_step.dart';
import 'package:costrutrain/data/local/app_database.dart';
import 'package:costrutrain/data/repositories/workout_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

WorkoutRow _workout({String tags = '[]'}) => WorkoutRow(
      id: 'w1',
      name: 'Test',
      description: null,
      tags: tags,
      globalRestS: null,
      warmupSeconds: null,
      cooldownS: null,
      createdAt: 1000,
      updatedAt: 1000,
      templateId: null,
      isTemplate: false,
    );

WorkoutStepRow _exerciseRow({
  String id = 's1',
  int orderIndex = 0,
  String? parentStepId,
  int nestingDepth = 0,
}) =>
    WorkoutStepRow(
      id: id,
      workoutId: 'w1',
      orderIndex: orderIndex,
      type: 'exercise',
      exerciseId: 'ex1',
      stepMode: 'reps',
      sets: 3,
      reps: 10,
      workSeconds: null,
      restSeconds: 60,
      tempo: null,
      isConfigured: false,
      circuitRounds: null,
      parentStepId: parentStepId,
      nestingDepth: nestingDepth,
    );

WorkoutStepRow _circuitRow({String id = 'c1', int orderIndex = 0}) => WorkoutStepRow(
      id: id,
      workoutId: 'w1',
      orderIndex: orderIndex,
      type: 'circuit',
      exerciseId: null,
      stepMode: null,
      sets: null,
      reps: null,
      workSeconds: null,
      restSeconds: null,
      tempo: null,
      isConfigured: false,
      circuitRounds: 3,
      parentStepId: null,
      nestingDepth: 0,
    );

void main() {
  group('WorkoutMapper.fromRows', () {
    test('flat exercise rows reconstruct in order', () {
      final rows = [
        _exerciseRow(id: 's2', orderIndex: 1),
        _exerciseRow(id: 's1', orderIndex: 0),
      ];
      final w = WorkoutMapper.fromRows(workout: _workout(), stepRows: rows);
      expect(w.steps.length, 2);
      expect(w.steps[0].id, 's1');
      expect(w.steps[1].id, 's2');
    });

    test('circuit rows attach children in order', () {
      final rows = [
        _circuitRow(),
        _exerciseRow(id: 'child2', orderIndex: 1, parentStepId: 'c1', nestingDepth: 1),
        _exerciseRow(id: 'child1', orderIndex: 0, parentStepId: 'c1', nestingDepth: 1),
      ];
      final w = WorkoutMapper.fromRows(workout: _workout(), stepRows: rows);
      expect(w.steps.length, 1);
      final circuit = w.steps.first as CircuitBlock;
      expect(circuit.rounds, 3);
      expect(circuit.steps.length, 2);
      expect(circuit.steps[0].id, 'child1');
      expect(circuit.steps[1].id, 'child2');
    });

    test('empty CircuitBlock reconstructs with empty steps list', () {
      final w = WorkoutMapper.fromRows(workout: _workout(), stepRows: [_circuitRow()]);
      expect((w.steps.first as CircuitBlock).steps, isEmpty);
    });

    test('tags JSON round-trip', () {
      final w = WorkoutMapper.fromRows(
        workout: _workout(tags: '["CrossFit","Benchmark"]'),
        stepRows: [],
      );
      expect(w.tags, ['CrossFit', 'Benchmark']);
    });

    test('nestingDepth > 1 throws StateError', () {
      final rows = [_exerciseRow(nestingDepth: 2, parentStepId: 'c1')];
      expect(
        () => WorkoutMapper.fromRows(workout: _workout(), stepRows: rows),
        throwsA(isA<StateError>()),
      );
    });

    test('orphan parentStepId throws StateError', () {
      final rows = [
        _exerciseRow(id: 's1', parentStepId: 'ghost', nestingDepth: 1),
      ];
      expect(
        () => WorkoutMapper.fromRows(workout: _workout(), stepRows: rows),
        throwsA(isA<StateError>()),
      );
    });

    test('fromRows maps isTemplate and templateId', () {
      const row = WorkoutRow(
        id: 'w1',
        name: 'Fran',
        description: null,
        tags: '[]',
        globalRestS: null,
        warmupSeconds: null,
        cooldownS: null,
        createdAt: 0,
        updatedAt: 0,
        isTemplate: true,
        templateId: 'fran',
      );
      final workout = WorkoutMapper.fromRows(workout: row, stepRows: const []);
      expect(workout.isTemplate, isTrue);
      expect(workout.templateId, 'fran');
    });

    test('fromRows defaults isTemplate to false when not set', () {
      const row = WorkoutRow(
        id: 'w1',
        name: 'My WOD',
        description: null,
        tags: '[]',
        globalRestS: null,
        warmupSeconds: null,
        cooldownS: null,
        createdAt: 0,
        updatedAt: 0,
        isTemplate: false,
        templateId: null,
      );
      final workout = WorkoutMapper.fromRows(workout: row, stepRows: const []);
      expect(workout.isTemplate, isFalse);
      expect(workout.templateId, isNull);
    });
  });
}
