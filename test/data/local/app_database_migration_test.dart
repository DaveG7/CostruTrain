import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/data/local/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('exercises_fts trigger populates index on INSERT', () async {
    await db.into(db.exercises).insert(ExercisesCompanion.insert(
      id: 'test-1',
      source: 'exercisedb',
      name: 'Barbell Curl',
      bodyPart: 'upper arms',
      targetPrimary: 'biceps',
      equipment: 'barbell',
      muscleGroup: const Value('biceps'),
    ));

    final results = await db
        .customSelect(
          "SELECT exercise_id FROM exercises_fts WHERE exercises_fts MATCH 'barbell'",
        )
        .get();

    expect(results.length, 1);
    expect(results.first.read<String>('exercise_id'), 'test-1');
  });

  test('muscle_group column is writable and readable', () async {
    await db.into(db.exercises).insert(ExercisesCompanion.insert(
      id: 'test-2',
      source: 'exercisedb',
      name: 'Squat',
      bodyPart: 'upper legs',
      targetPrimary: 'quads',
      equipment: 'body weight',
      muscleGroup: const Value('quads'),
    ));

    final rows = await db.select(db.exercises).get();
    expect(rows.first.muscleGroup, 'quads');
  });

  test('v3 migration creates workouts table', () async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.customStatement(
      'INSERT INTO workouts(id, name, tags, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?)',
      ['w1', 'My Workout', '[]', 1000, 1000],
    );
    final rows = await db.customSelect('SELECT * FROM workouts').get();
    expect(rows.length, 1);
    expect(rows.first.read<String>('name'), 'My Workout');
    await db.close();
  });

  test('v3 migration creates workout_steps table', () async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.customStatement(
      'INSERT INTO workouts(id, name, tags, created_at, updated_at) VALUES (?, ?, ?, ?, ?)',
      ['w1', 'W', '[]', 1000, 1000],
    );
    await db.customStatement(
      'INSERT INTO workout_steps(id, workout_id, order_index, type, nesting_depth, is_configured) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['s1', 'w1', 0, 'rest', 0, 0],
    );
    final rows = await db.customSelect('SELECT * FROM workout_steps').get();
    expect(rows.length, 1);
    await db.close();
  });

  test('v3 adds forward-compat columns to exercises', () async {
    final db = AppDatabase(NativeDatabase.memory());
    // Should not throw — column exists
    await db.customStatement('UPDATE exercises SET default_sets = 3 WHERE id = ?', ['x']);
    await db.close();
  });
}
