import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:costrutrain/data/local/app_database.dart';
import '../../helpers/test_database.dart';
import 'package:costrutrain/data/local/shared_prefs_provider.dart';
import 'package:costrutrain/data/seed/seed_notifier.dart';
import 'package:costrutrain/data/seed/seed_service.dart';

Map<String, dynamic> _fakeExercise(String id) => {
      'id': id, 'name': 'Ex $id', 'bodyPart': 'chest',
      'target': 'pectorals', 'equipment': 'body weight', 'gifUrl': null,
    };

ProviderContainer _makeContainer({
  required SharedPreferences prefs,
  required AppDatabase db,
  String? json,
}) =>
    ProviderContainer(overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
      appDatabaseProvider.overrideWithValue(db),
      seedServiceProvider.overrideWithValue(
        OverridableSeedService(json: json ?? jsonEncode([_fakeExercise('1')])),
      ),
    ]);

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() => db.close());

  test('fast path — returns isDone immediately when already seeded', () async {
    SharedPreferences.setMockInitialValues({'seeded': true});
    final prefs = await SharedPreferences.getInstance();
    final container = _makeContainer(prefs: prefs, db: db);
    addTearDown(container.dispose);

    final state = await container.read(seedNotifierProvider.future);
    expect(state.isDone, isTrue);
  });

  test('seeding path — seeds exercises and writes flag', () async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(List.generate(3, (i) => _fakeExercise('$i')));
    final container = _makeContainer(prefs: prefs, db: db, json: json);
    addTearDown(container.dispose);

    final state = await container.read(seedNotifierProvider.future);
    expect(state.isDone, isTrue);
    expect(prefs.getBool('seeded'), isTrue);
    final rows = await db.select(db.exercises).get();
    expect(rows.length, 3);
  });
}
