import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/data/local/app_database.dart';
import 'package:costrutrain/data/repositories/bundled_json_exercise_repository.dart';
import 'package:costrutrain/data/seed/seed_service.dart';

import '../../helpers/test_database.dart';

const _seedJson = '''
[
  {"id": "001", "name": "Barbell Curl", "bodyPart": "upper arms", "target": "biceps", "equipment": "barbell", "gifUrl": null},
  {"id": "002", "name": "Push-up", "bodyPart": "chest", "target": "pectorals", "equipment": "body weight", "gifUrl": null},
  {"id": "003", "name": "Barbell Squat", "bodyPart": "upper legs", "target": "quads", "equipment": "barbell", "gifUrl": null},
  {"id": "004", "name": "Cable Row", "bodyPart": "back", "target": "lats", "equipment": "cable", "gifUrl": null}
]
''';

void main() {
  late AppDatabase db;
  late BundledJsonExerciseRepository repo;

  setUp(() async {
    db = createTestDatabase();
    repo = BundledJsonExerciseRepository(db);
    await const OverridableSeedService(json: _seedJson).run(db: db);
  });

  tearDown(() => db.close());

  group('search()', () {
    test('empty search returns all exercises ordered by name', () async {
      final results = await repo.search();
      expect(results.length, 4);
      expect(results.map((e) => e.name).toList(),
          ['Barbell Curl', 'Barbell Squat', 'Cable Row', 'Push-up']);
    });

    test('FTS query returns matching exercises', () async {
      final results = await repo.search(query: 'barbell');
      expect(results.length, 2);
      expect(results.map((e) => e.name),
          containsAll(['Barbell Curl', 'Barbell Squat']));
    });

    test('FTS query with no matches returns empty list', () async {
      final results = await repo.search(query: 'deadlift');
      expect(results, isEmpty);
    });

    test('bodyPart filter returns matching exercises', () async {
      final results = await repo.search(bodyPart: 'chest');
      expect(results.length, 1);
      expect(results.first.name, 'Push-up');
    });

    test('muscleGroup filter returns matching exercises', () async {
      final results = await repo.search(muscleGroup: 'lats');
      expect(results.length, 1);
      expect(results.first.name, 'Cable Row');
    });

    test('query + bodyPart AND logic returns intersection', () async {
      final results = await repo.search(query: 'barbell', bodyPart: 'upper arms');
      expect(results.length, 1);
      expect(results.first.name, 'Barbell Curl');
    });

    test('filter with no matches returns empty list', () async {
      final results = await repo.search(bodyPart: 'neck');
      expect(results, isEmpty);
    });
  });
}
