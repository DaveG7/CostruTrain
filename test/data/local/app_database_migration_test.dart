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
}
