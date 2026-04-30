import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/data/local/app_database.dart';
import '../../helpers/test_database.dart';
import 'package:costrutrain/data/seed/seed_service.dart';

Map<String, dynamic> _fakeExercise(String id) => {
      'id': id,
      'name': 'Exercise $id',
      'bodyPart': 'chest',
      'target': 'pectorals',
      'equipment': 'body weight',
      'gifUrl': null,
    };

void main() {
  late AppDatabase db;
  late SeedService service;

  setUp(() {
    db = createTestDatabase();
    service = const SeedService();
  });

  tearDown(() => db.close());

  test('inserts all exercises from JSON', () async {
    final json = jsonEncode(List.generate(5, (i) => _fakeExercise('$i')));
    await service.runWithJson(db: db, json: json, chunkSize: 3);
    final rows = await db.select(db.exercises).get();
    expect(rows.length, 5);
  });

  test('calls onProgress for each chunk', () async {
    final json = jsonEncode(List.generate(10, (i) => _fakeExercise('$i')));
    final progress = <int>[];
    await service.runWithJson(
      db: db,
      json: json,
      chunkSize: 3,
      onProgress: (done, total) => progress.add(done),
    );
    // 10 exercises / 3 per chunk = 4 chunks
    expect(progress, [1, 2, 3, 4]);
  });

  test('total is computed, not hardcoded', () async {
    final json = jsonEncode(List.generate(7, (i) => _fakeExercise('$i')));
    final totals = <int>[];
    await service.runWithJson(
      db: db,
      json: json,
      chunkSize: 3,
      onProgress: (done, total) => totals.add(total),
    );
    // ceil(7/3) = 3
    expect(totals.toSet(), {3});
  });

  test('is idempotent — duplicate inserts do not throw', () async {
    final json = jsonEncode([_fakeExercise('dup')]);
    await service.runWithJson(db: db, json: json);
    await service.runWithJson(db: db, json: json);
    final rows = await db.select(db.exercises).get();
    expect(rows.length, 1);
  });
}
