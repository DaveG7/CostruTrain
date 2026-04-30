import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/data/local/app_database.dart';
import '../../helpers/test_database.dart';
import 'package:costrutrain/data/repositories/bundled_json_exercise_repository.dart';

void main() {
  late AppDatabase db;
  late BundledJsonExerciseRepository repo;

  setUp(() {
    db = createTestDatabase();
    repo = BundledJsonExerciseRepository(db);
  });

  tearDown(() => db.close());

  Future<void> seedRow(String id, String name, String bodyPart) async {
    await db.into(db.exercises).insert(ExercisesCompanion.insert(
      id: id,
      source: 'exercisedb',
      name: name,
      bodyPart: bodyPart,
      targetPrimary: 'abs',
      equipment: 'body weight',
    ));
  }

  test('getAll returns all rows', () async {
    await seedRow('exercisedb_1', 'Push-up', 'chest');
    await seedRow('exercisedb_2', 'Squat', 'upper legs');
    final all = await repo.getAll();
    expect(all.length, 2);
    expect(all.map((e) => e.name), containsAll(['Push-up', 'Squat']));
  });

  test('getAll returns empty list when no rows', () async {
    final all = await repo.getAll();
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
}
