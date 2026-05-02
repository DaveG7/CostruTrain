import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:costrutrain/features/library/providers/library_filter_notifier.dart';

void main() {
  late ProviderContainer container;
  late LibraryFilter notifier;

  setUp(() {
    container = ProviderContainer();
    notifier = container.read(libraryFilterProvider.notifier);
  });

  tearDown(() => container.dispose());

  test('initial state has empty query and no filters', () {
    final state = container.read(libraryFilterProvider);
    expect(state.query, '');
    expect(state.bodyPart, isNull);
    expect(state.equipment, isNull);
    expect(state.muscleGroup, isNull);
    expect(state.hasActiveFilters, isFalse);
  });

  test('setBodyPart updates bodyPart immediately', () {
    notifier.setBodyPart('chest');
    expect(container.read(libraryFilterProvider).bodyPart, 'chest');
  });

  test('setBodyPart(null) clears bodyPart', () {
    notifier.setBodyPart('chest');
    notifier.setBodyPart(null);
    expect(container.read(libraryFilterProvider).bodyPart, isNull);
  });

  test('setEquipment updates equipment immediately', () {
    notifier.setEquipment('barbell');
    expect(container.read(libraryFilterProvider).equipment, 'barbell');
  });

  test('setMuscleGroup updates muscleGroup immediately', () {
    notifier.setMuscleGroup('glutes');
    expect(container.read(libraryFilterProvider).muscleGroup, 'glutes');
  });

  test('clearAll resets all state', () {
    notifier.setBodyPart('chest');
    notifier.setEquipment('barbell');
    notifier.setMuscleGroup('pectorals');
    notifier.clearAll();

    final state = container.read(libraryFilterProvider);
    expect(state.query, '');
    expect(state.bodyPart, isNull);
    expect(state.equipment, isNull);
    expect(state.muscleGroup, isNull);
  });

  test('hasActiveFilters is true when any filter is set', () {
    notifier.setBodyPart('chest');
    expect(container.read(libraryFilterProvider).hasActiveFilters, isTrue);
  });

  test('hasActiveFilters is false after clearAll', () {
    notifier.setBodyPart('chest');
    notifier.clearAll();
    expect(container.read(libraryFilterProvider).hasActiveFilters, isFalse);
  });
}
