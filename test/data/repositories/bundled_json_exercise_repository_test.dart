import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/data/local/app_database.dart';
import 'package:costrutrain/data/repositories/bundled_json_exercise_repository.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late BundledJsonExerciseRepository repo;

  setUp(() {
    db = createTestDatabase();
    repo = BundledJsonExerciseRepository(db);
  });

  tearDown(() => db.close());

  Future<void> seedRow(String id, String name, String bodyPart, {String muscleGroup = 'abs'}) async {
    await db.into(db.exercises).insert(ExercisesCompanion.insert(
      id: id,
      source: 'exercisedb',
      name: name,
      bodyPart: bodyPart,
      targetPrimary: muscleGroup,
      equipment: 'body weight',
      muscleGroup: Value(muscleGroup),
    ));
  }

  test('search() returns all rows when called with no params', () async {
    await seedRow('exercisedb_1', 'Push-up', 'chest');
    await seedRow('exercisedb_2', 'Squat', 'upper legs');
    final all = await repo.search();
    expect(all.length, 2);
    expect(all.map((e) => e.name), containsAll(['Push-up', 'Squat']));
  });

  test('search() returns empty list when no rows', () async {
    final all = await repo.search();
    expect(all, isEmpty);
  });

  test('getById returns correct exercise', () async {
    await seedRow('exercisedb_42', 'Lunge', 'upper legs');
    final e = await repo.getById('exercisedb_42');
    expect(e?.name, 'Lunge');
    expect(e?.bodyPart, 'upper legs');
  });

  test('getById returns null for unknown id', () async {
    final e = await repo.getById('exercisedb_999');
    expect(e, isNull);
  });

  test('getById returns gifUrl when the row has one', () async {
    await db.into(db.exercises).insert(ExercisesCompanion.insert(
          id: 'exercisedb_gif1',
          source: 'exercisedb',
          name: 'Push-up',
          bodyPart: 'chest',
          targetPrimary: 'chest',
          equipment: 'body weight',
          gifUrl: const Value('https://static.exercisedb.dev/media/gif1.gif'),
        ));
    final e = await repo.getById('exercisedb_gif1');
    expect(e?.gifUrl, 'https://static.exercisedb.dev/media/gif1.gif');
  });

  test('search() returns gifUrl when the row has one', () async {
    await db.into(db.exercises).insert(ExercisesCompanion.insert(
          id: 'exercisedb_gif2',
          source: 'exercisedb',
          name: 'Squat',
          bodyPart: 'upper legs',
          targetPrimary: 'upper legs',
          equipment: 'body weight',
          gifUrl: const Value('https://static.exercisedb.dev/media/gif2.gif'),
        ));
    final all = await repo.search();
    expect(all.single.gifUrl, 'https://static.exercisedb.dev/media/gif2.gif');
  });
}
