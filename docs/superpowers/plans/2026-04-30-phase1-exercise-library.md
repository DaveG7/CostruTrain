# Phase 1 — Exercise Library Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a fully-featured exercise browser — search, filter, and GIF preview for all 1300 exercises.

**Architecture:** FTS5 virtual table (schema v2) with an AFTER INSERT trigger keeps the search index in sync automatically. A keepAlive `LibraryFilterNotifier` owns debounced query state; an autoDispose `exerciseSearchResultsProvider` drives the list. GIFs load only on the detail screen via `CachedNetworkImage`.

**Tech Stack:** Drift FTS5, Riverpod (Notifier + FutureProvider), lucide_icons, cached_network_image, shimmer, google_fonts.

> **WSL PATH note:** Always use `/home/dave/flutter/bin/flutter` and `/home/dave/flutter/bin/dart` — the Flutter binary is not on PATH in subagent shells.

---

## File Map

| Status | Path | Role |
|--------|------|------|
| Modify | `pubspec.yaml` | Add Phase 1 deps |
| Modify | `lib/core/models/exercise.dart` | Add `muscleGroup` field |
| Modify | `lib/data/local/app_database.dart` | Add `muscleGroup` column, schemaVersion 2, MigrationStrategy |
| Modify | `lib/data/seed/seed_service.dart` | Write `muscleGroup` in `_toCompanion` |
| Modify | `lib/data/repositories/exercise_repository.dart` | Add `search()`, keep `getAll()` until Task 11 |
| Modify | `lib/data/repositories/bundled_json_exercise_repository.dart` | Implement `search()` with FTS JOIN + plain WHERE |
| Modify | `lib/shared/theme/app_theme.dart` | Add `CTColors` ThemeExtension |
| Modify | `lib/core/router.dart` | Add `/library/:exerciseId` OUTSIDE ShellRoute |
| Modify | `lib/l10n/app_en.arb` | Add search/filter strings |
| Modify | `lib/features/library/views/exercise_list_screen.dart` | Full rebuild |
| Modify | `test/data/repositories/bundled_json_exercise_repository_test.dart` | Replace getAll tests → search tests |
| Modify | `test/features/library/views/exercise_list_screen_test.dart` | Rebuild for new screen |
| Create | `lib/shared/theme/ct_colors.dart` | CTColors ThemeExtension |
| Create | `lib/shared/widgets/ct_filter_chip.dart` | Selectable chip component |
| Create | `lib/shared/widgets/ct_search_bar.dart` | Debounce-ready search field |
| Create | `lib/shared/widgets/ct_gif_placeholder.dart` | Shimmer placeholder |
| Create | `lib/shared/widgets/ct_exercise_card.dart` | Exercise list card |
| Create | `lib/features/library/providers/library_filter_notifier.dart` | Filter state + Timer debounce |
| Create | `lib/features/library/providers/exercise_search_results_provider.dart` | FutureProvider driving list |
| Create | `lib/features/library/views/exercise_detail_screen.dart` | Detail screen with GIF |
| Create | `lib/features/library/widgets/filter_sheet.dart` | Filter bottom sheet |
| Create | `test/data/local/app_database_migration_test.dart` | FTS + muscle_group migration tests |
| Create | `test/features/library/providers/library_filter_notifier_test.dart` | Notifier unit tests |
| Delete | `lib/features/library/providers/exercises_provider.dart` | Replaced by search provider (Task 11) |
| Delete | `lib/features/library/providers/exercises_provider.g.dart` | Generated — deleted with parent (Task 11) |

---

## Task 1: Add Phase 1 dependencies

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add deps to pubspec.yaml**

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^14.2.0
  drift: ^2.20.2
  drift_flutter: ^0.2.1
  shared_preferences: ^2.3.0
  flutter_cache_manager: ^3.4.1
  cached_network_image: ^3.4.1
  intl: ^0.20.0
  flutter_native_splash: ^2.4.1
  lucide_icons: ^0.257.0
  shimmer: ^3.0.0
  google_fonts: ^6.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.12
  drift_dev: ^2.20.2
  riverpod_generator: ^2.4.3
  riverpod_lint: ^2.3.13
  custom_lint: ^0.7.6
```

- [ ] **Step 2: Run pub get**

```bash
/home/dave/flutter/bin/flutter pub get
```

Expected: resolves cleanly, no version conflicts.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "feat: add Phase 1 deps — lucide, cached_network_image, shimmer, google_fonts"
```

---

## Task 2: Add muscleGroup to Exercise model + Drift table

**Files:**
- Modify: `lib/core/models/exercise.dart`
- Modify: `lib/data/local/app_database.dart`
- Modify: `lib/data/seed/seed_service.dart`
- Modify: `test/data/repositories/bundled_json_exercise_repository_test.dart`

- [ ] **Step 1: Add `muscleGroup` to the Exercise domain model**

Replace `lib/core/models/exercise.dart` with:

```dart
class Exercise {
  final String id;
  final String? externalId;
  final String source;
  final String name;
  final String bodyPart;
  final String targetPrimary;
  final String equipment;
  final String? gifUrl;
  final String? muscleGroup;

  const Exercise({
    required this.id,
    this.externalId,
    required this.source,
    required this.name,
    required this.bodyPart,
    required this.targetPrimary,
    required this.equipment,
    this.gifUrl,
    this.muscleGroup,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: 'exercisedb_${json['id'] as String}',
        externalId: json['id'] as String,
        source: 'exercisedb',
        name: json['name'] as String,
        bodyPart: json['bodyPart'] as String,
        targetPrimary: json['target'] as String,
        muscleGroup: json['target'] as String?,
        equipment: json['equipment'] as String,
        gifUrl: json['gifUrl'] as String?,
      );
}
```

- [ ] **Step 2: Add `muscleGroup` column to the Drift Exercises table**

Replace `lib/data/local/app_database.dart` with:

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get externalId => text().nullable()();
  TextColumn get source => text()();
  TextColumn get name => text()();
  TextColumn get bodyPart => text()();
  TextColumn get targetPrimary => text()();
  TextColumn get equipment => text()();
  TextColumn get gifUrl => text().nullable()();
  TextColumn get muscleGroup => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Exercises])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ??
            driftDatabase(
              name: 'costrutrain',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ));

  @override
  int get schemaVersion => 1;
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
```

Note: `schemaVersion` stays at `1` here — it moves to `2` in Task 3 when the MigrationStrategy is added.

- [ ] **Step 3: Regenerate Drift code**

```bash
/home/dave/flutter/bin/dart run build_runner build --delete-conflicting-outputs
```

Expected: `app_database.g.dart` regenerated with `muscleGroup` column in `ExercisesCompanion`.

- [ ] **Step 4: Update SeedService to write muscleGroup**

In `lib/data/seed/seed_service.dart`, replace `_toCompanion`:

```dart
ExercisesCompanion _toCompanion(model.Exercise e) => ExercisesCompanion.insert(
      id: e.id,
      externalId: Value(e.externalId),
      source: e.source,
      name: e.name,
      bodyPart: e.bodyPart,
      targetPrimary: e.targetPrimary,
      equipment: e.equipment,
      gifUrl: Value(e.gifUrl),
      muscleGroup: Value(e.muscleGroup),
    );
```

- [ ] **Step 5: Update the seedRow helper in the repository test**

In `test/data/repositories/bundled_json_exercise_repository_test.dart`, update `seedRow` to include the new column (otherwise the insert will fail with a NOT NULL violation if Drift enforces it — it won't since `muscleGroup` is nullable, but updating keeps tests current):

```dart
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
```

- [ ] **Step 6: Run existing tests to confirm nothing broke**

```bash
/home/dave/flutter/bin/flutter test test/data/repositories/bundled_json_exercise_repository_test.dart --reporter=expanded
```

Expected: all 4 tests pass.

- [ ] **Step 7: Commit**

```bash
git add lib/core/models/exercise.dart lib/data/local/app_database.dart lib/data/local/app_database.g.dart lib/data/seed/seed_service.dart test/data/repositories/bundled_json_exercise_repository_test.dart
git commit -m "feat: add muscleGroup field to Exercise model and Exercises table"
```

---

## Task 3: Schema migration v1 → v2 (FTS5 + trigger + muscle_group)

**Files:**
- Modify: `lib/data/local/app_database.dart`
- Create: `test/data/local/app_database_migration_test.dart`

- [ ] **Step 1: Write the failing migration test**

Create `test/data/local/app_database_migration_test.dart`:

```dart
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
```

- [ ] **Step 2: Run the test to confirm it fails**

```bash
/home/dave/flutter/bin/flutter test test/data/local/app_database_migration_test.dart --reporter=expanded
```

Expected: FAIL — `no such table: exercises_fts` (FTS5 table doesn't exist yet).

- [ ] **Step 3: Add MigrationStrategy and bump schemaVersion to 2**

Replace the full `app_database.dart` with:

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get externalId => text().nullable()();
  TextColumn get source => text()();
  TextColumn get name => text()();
  TextColumn get bodyPart => text()();
  TextColumn get targetPrimary => text()();
  TextColumn get equipment => text()();
  TextColumn get gifUrl => text().nullable()();
  TextColumn get muscleGroup => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Exercises])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ??
            driftDatabase(
              name: 'costrutrain',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createFts();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(exercises, exercises.muscleGroup);
            await customStatement(
                'UPDATE exercises SET muscle_group = target_primary');
            await _createFts();
            // Bulk-populate FTS for existing rows (trigger only fires on future INSERTs).
            await customStatement(
                'INSERT INTO exercises_fts(name, exercise_id) SELECT name, id FROM exercises');
          }
        },
      );

  Future<void> _createFts() async {
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS exercises_fts
        USING fts5(name, exercise_id UNINDEXED)
    ''');
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS exercises_ai
        AFTER INSERT ON exercises BEGIN
          INSERT INTO exercises_fts(name, exercise_id)
          VALUES (new.name, new.id);
        END
    ''');
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
```

- [ ] **Step 4: Run the migration tests**

```bash
/home/dave/flutter/bin/flutter test test/data/local/app_database_migration_test.dart --reporter=expanded
```

Expected: both tests PASS.

- [ ] **Step 5: Run the full test suite to confirm no regressions**

```bash
/home/dave/flutter/bin/flutter test --reporter=expanded
```

Expected: all existing tests pass.

- [ ] **Step 6: Commit**

```bash
git add lib/data/local/app_database.dart test/data/local/app_database_migration_test.dart
git commit -m "feat: schema v2 — FTS5 index + trigger + muscle_group column"
```

---

## Task 4: ExerciseRepository.search() interface + implementation

**Files:**
- Modify: `lib/data/repositories/exercise_repository.dart`
- Modify: `lib/data/repositories/bundled_json_exercise_repository.dart`
- Create: `test/data/repositories/bundled_json_exercise_repository_search_test.dart`

- [ ] **Step 1: Add `search()` to the repository interface**

Replace `lib/data/repositories/exercise_repository.dart`:

```dart
import 'package:costrutrain/core/models/exercise.dart';

abstract interface class ExerciseRepository {
  // getAll() is Phase 0 only — removed in Task 11.
  Future<List<Exercise>> getAll();
  Future<Exercise?> getById(String id);

  /// Search exercises by full-text query and/or filters.
  /// All non-null parameters are combined with AND logic.
  /// [query] runs against the FTS5 index (exercise names).
  /// [bodyPart], [equipment], [muscleGroup] are exact-match filters.
  Future<List<Exercise>> search({
    String? query,
    String? bodyPart,
    String? equipment,
    String? muscleGroup,
  });
}
```

- [ ] **Step 2: Write the failing search tests**

Create `test/data/repositories/bundled_json_exercise_repository_search_test.dart`:

```dart
import 'dart:convert';

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
    await OverridableSeedService(json: _seedJson).run(db: db);
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
```

- [ ] **Step 3: Run the tests to confirm they fail**

```bash
/home/dave/flutter/bin/flutter test test/data/repositories/bundled_json_exercise_repository_search_test.dart --reporter=expanded
```

Expected: all FAIL — `search()` not yet implemented.

- [ ] **Step 4: Implement `search()` in BundledJsonExerciseRepository**

Replace `lib/data/repositories/bundled_json_exercise_repository.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/exercise.dart' as model;
import '../local/app_database.dart';
import 'exercise_repository.dart';

part 'bundled_json_exercise_repository.g.dart';

class BundledJsonExerciseRepository implements ExerciseRepository {
  const BundledJsonExerciseRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<model.Exercise>> getAll() async {
    final rows = await _db.select(_db.exercises).get();
    return rows.map(_fromData).toList();
  }

  @override
  Future<model.Exercise?> getById(String id) async {
    final row = await (_db.select(_db.exercises)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromData(row);
  }

  @override
  Future<List<model.Exercise>> search({
    String? query,
    String? bodyPart,
    String? equipment,
    String? muscleGroup,
  }) async {
    if (query != null && query.isNotEmpty) {
      return _searchWithFts(
        query,
        bodyPart: bodyPart,
        equipment: equipment,
        muscleGroup: muscleGroup,
      );
    }
    return _filterOnly(
      bodyPart: bodyPart,
      equipment: equipment,
      muscleGroup: muscleGroup,
    );
  }

  Future<List<model.Exercise>> _searchWithFts(
    String query, {
    String? bodyPart,
    String? equipment,
    String? muscleGroup,
  }) async {
    // The (col = ? OR ? IS NULL) pattern makes each filter optional:
    // when NULL is bound, the condition is always true (no filtering).
    const sql = '''
      SELECT e.id, e.external_id, e.source, e.name, e.body_part,
             e.target_primary, e.equipment, e.gif_url, e.muscle_group
      FROM exercises e
      INNER JOIN exercises_fts fts ON fts.exercise_id = e.id
      WHERE exercises_fts MATCH ?
        AND (e.body_part = ? OR ? IS NULL)
        AND (e.equipment = ? OR ? IS NULL)
        AND (e.muscle_group = ? OR ? IS NULL)
      ORDER BY fts.rank
    ''';

    final vars = [
      Variable.withString(query),
      bodyPart != null ? Variable.withString(bodyPart) : const Variable<String>(null),
      bodyPart != null ? Variable.withString(bodyPart) : const Variable<String>(null),
      equipment != null ? Variable.withString(equipment) : const Variable<String>(null),
      equipment != null ? Variable.withString(equipment) : const Variable<String>(null),
      muscleGroup != null ? Variable.withString(muscleGroup) : const Variable<String>(null),
      muscleGroup != null ? Variable.withString(muscleGroup) : const Variable<String>(null),
    ];

    final rows = await _db.customSelect(sql, variables: vars).get();
    return rows.map(_fromRow).toList();
  }

  Future<List<model.Exercise>> _filterOnly({
    String? bodyPart,
    String? equipment,
    String? muscleGroup,
  }) async {
    final rows = await (_db.select(_db.exercises)
          ..where((e) {
            Expression<bool> w = const Constant(true);
            if (bodyPart != null) w = w & e.bodyPart.equals(bodyPart);
            if (equipment != null) w = w & e.equipment.equals(equipment);
            if (muscleGroup != null) w = w & e.muscleGroup.equals(muscleGroup);
            return w;
          })
          ..orderBy([(e) => OrderingTerm.asc(e.name)]))
        .get();
    return rows.map(_fromData).toList();
  }

  model.Exercise _fromData(Exercise data) => model.Exercise(
        id: data.id,
        externalId: data.externalId,
        source: data.source,
        name: data.name,
        bodyPart: data.bodyPart,
        targetPrimary: data.targetPrimary,
        equipment: data.equipment,
        gifUrl: data.gifUrl,
        muscleGroup: data.muscleGroup,
      );

  model.Exercise _fromRow(QueryRow row) => model.Exercise(
        id: row.read<String>('id'),
        externalId: row.readNullable<String>('external_id'),
        source: row.read<String>('source'),
        name: row.read<String>('name'),
        bodyPart: row.read<String>('body_part'),
        targetPrimary: row.read<String>('target_primary'),
        equipment: row.read<String>('equipment'),
        gifUrl: row.readNullable<String>('gif_url'),
        muscleGroup: row.readNullable<String>('muscle_group'),
      );
}

@Riverpod(keepAlive: true)
ExerciseRepository exerciseRepository(ExerciseRepositoryRef ref) {
  return BundledJsonExerciseRepository(ref.watch(appDatabaseProvider));
}
```

- [ ] **Step 5: Run the search tests**

```bash
/home/dave/flutter/bin/flutter test test/data/repositories/bundled_json_exercise_repository_search_test.dart --reporter=expanded
```

Expected: all 7 tests PASS.

- [ ] **Step 6: Run the full test suite**

```bash
/home/dave/flutter/bin/flutter test --reporter=expanded
```

Expected: all tests pass.

- [ ] **Step 7: Commit**

```bash
git add lib/data/repositories/exercise_repository.dart lib/data/repositories/bundled_json_exercise_repository.dart lib/data/repositories/bundled_json_exercise_repository.g.dart test/data/repositories/bundled_json_exercise_repository_search_test.dart
git commit -m "feat: ExerciseRepository.search() with FTS5 JOIN + filter-only paths"
```

---

## Task 5: LibraryFilterNotifier + exerciseSearchResultsProvider

**Files:**
- Create: `lib/features/library/providers/library_filter_notifier.dart`
- Create: `lib/features/library/providers/exercise_search_results_provider.dart`
- Create: `test/features/library/providers/library_filter_notifier_test.dart`

- [ ] **Step 1: Write the failing notifier tests**

Create `test/features/library/providers/library_filter_notifier_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:costrutrain/features/library/providers/library_filter_notifier.dart';

void main() {
  late ProviderContainer container;
  late LibraryFilterNotifier notifier;

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
```

Note: `setQuery()` debounce (Timer-based) is not testable synchronously without fake async — omit from unit tests. The debounce is tested implicitly by the integration behavior.

- [ ] **Step 2: Run the tests to confirm they fail**

```bash
/home/dave/flutter/bin/flutter test test/features/library/providers/library_filter_notifier_test.dart --reporter=expanded
```

Expected: FAIL — `libraryFilterProvider` does not exist.

- [ ] **Step 3: Create LibraryFilterState + LibraryFilterNotifier**

Create `lib/features/library/providers/library_filter_notifier.dart`:

```dart
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_filter_notifier.g.dart';

class LibraryFilterState {
  const LibraryFilterState({
    this.query = '',
    this.bodyPart,
    this.equipment,
    this.muscleGroup,
  });

  final String query;
  final String? bodyPart;
  final String? equipment;
  final String? muscleGroup;

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      bodyPart != null ||
      equipment != null ||
      muscleGroup != null;

  LibraryFilterState copyWith({
    String? query,
    Object? bodyPart = _sentinel,
    Object? equipment = _sentinel,
    Object? muscleGroup = _sentinel,
  }) =>
      LibraryFilterState(
        query: query ?? this.query,
        bodyPart: bodyPart == _sentinel ? this.bodyPart : bodyPart as String?,
        equipment: equipment == _sentinel ? this.equipment : equipment as String?,
        muscleGroup: muscleGroup == _sentinel ? this.muscleGroup : muscleGroup as String?,
      );
}

const _sentinel = Object();

@Riverpod(keepAlive: true)
class LibraryFilterNotifier extends _$LibraryFilterNotifier {
  Timer? _debounce;

  @override
  LibraryFilterState build() => const LibraryFilterState();

  /// Debounced — state.query updates 300ms after the last call.
  void setQuery(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      state = state.copyWith(query: value);
    });
  }

  void setBodyPart(String? value) => state = state.copyWith(bodyPart: value);
  void setEquipment(String? value) => state = state.copyWith(equipment: value);
  void setMuscleGroup(String? value) => state = state.copyWith(muscleGroup: value);

  void clearAll() {
    _debounce?.cancel();
    state = const LibraryFilterState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
```

- [ ] **Step 4: Create exerciseSearchResultsProvider**

Create `lib/features/library/providers/exercise_search_results_provider.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/exercise.dart';
import '../../../data/repositories/bundled_json_exercise_repository.dart';
import 'library_filter_notifier.dart';

part 'exercise_search_results_provider.g.dart';

/// Drives the exercise list. autoDispose tears it down on tab switch.
/// Debounce lives in LibraryFilterNotifier.setQuery() — no Future.delayed here.
@riverpod
Future<List<Exercise>> exerciseSearchResults(ExerciseSearchResultsRef ref) {
  final filter = ref.watch(libraryFilterProvider);
  return ref.watch(exerciseRepositoryProvider).search(
        query: filter.query.isEmpty ? null : filter.query,
        bodyPart: filter.bodyPart,
        equipment: filter.equipment,
        muscleGroup: filter.muscleGroup,
      );
}
```

- [ ] **Step 5: Run build_runner**

```bash
/home/dave/flutter/bin/dart run build_runner build --delete-conflicting-outputs
```

Expected: generates `library_filter_notifier.g.dart` and `exercise_search_results_provider.g.dart`.

- [ ] **Step 6: Run the notifier tests**

```bash
/home/dave/flutter/bin/flutter test test/features/library/providers/library_filter_notifier_test.dart --reporter=expanded
```

Expected: all 7 tests PASS.

- [ ] **Step 7: Run the full test suite**

```bash
/home/dave/flutter/bin/flutter test --reporter=expanded
```

Expected: all tests pass.

- [ ] **Step 8: Commit**

```bash
git add lib/features/library/providers/ test/features/library/providers/
git commit -m "feat: LibraryFilterNotifier (Timer debounce) + exerciseSearchResultsProvider"
```

---

## Task 6: CTColors ThemeExtension + AppTheme update

**Files:**
- Create: `lib/shared/theme/ct_colors.dart`
- Modify: `lib/shared/theme/app_theme.dart`

- [ ] **Step 1: Create CTColors ThemeExtension**

Create `lib/shared/theme/ct_colors.dart`:

```dart
import 'package:flutter/material.dart';

@immutable
class CTColors extends ThemeExtension<CTColors> {
  const CTColors({
    required this.bg,
    required this.surface,
    required this.elevated,
    required this.accent,
    required this.red,
    required this.amber,
    required this.green,
    required this.blue,
  });

  final Color bg;
  final Color surface;
  final Color elevated;
  final Color accent;
  final Color red;
  final Color amber;
  final Color green;
  final Color blue;

  @override
  CTColors copyWith({
    Color? bg,
    Color? surface,
    Color? elevated,
    Color? accent,
    Color? red,
    Color? amber,
    Color? green,
    Color? blue,
  }) =>
      CTColors(
        bg: bg ?? this.bg,
        surface: surface ?? this.surface,
        elevated: elevated ?? this.elevated,
        accent: accent ?? this.accent,
        red: red ?? this.red,
        amber: amber ?? this.amber,
        green: green ?? this.green,
        blue: blue ?? this.blue,
      );

  @override
  CTColors lerp(CTColors? other, double t) {
    if (other is! CTColors) return this;
    return CTColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      elevated: Color.lerp(elevated, other.elevated, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      red: Color.lerp(red, other.red, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      green: Color.lerp(green, other.green, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
    );
  }

  static const dark = CTColors(
    bg: Color(0xFF0F0F0F),
    surface: Color(0xFF1A1A1A),
    elevated: Color(0xFF242424),
    accent: Color(0xFFE8FF00),
    red: Color(0xFFE84040),
    amber: Color(0xFFF5A623),
    green: Color(0xFF4CAF50),
    blue: Color(0xFF3D8BFF),
  );
}

extension CTColorsX on BuildContext {
  CTColors get ct => Theme.of(this).extension<CTColors>()!;
}
```

- [ ] **Step 2: Wire CTColors into AppTheme**

Replace `lib/shared/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ct_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: CTColors.dark.bg,
        colorScheme: ColorScheme.dark(
          primary: CTColors.dark.accent,
          secondary: CTColors.dark.accent,
          surface: CTColors.dark.surface,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        extensions: const [CTColors.dark],
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: CTColors.dark.surface,
          indicatorColor: CTColors.dark.accent.withValues(alpha: 0.2),
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: CTColors.dark.surface,
          labelStyle: const TextStyle(fontSize: 12),
          side: BorderSide(color: CTColors.dark.accent.withValues(alpha: 0.4)),
        ),
        useMaterial3: true,
      );
}
```

- [ ] **Step 3: Run the full test suite (confirms no theme breakage)**

```bash
/home/dave/flutter/bin/flutter test --reporter=expanded
```

Expected: all tests pass.

- [ ] **Step 4: Commit**

```bash
git add lib/shared/theme/ct_colors.dart lib/shared/theme/app_theme.dart
git commit -m "feat: CTColors ThemeExtension + google_fonts Inter text theme"
```

---

## Task 7: Shared widgets

**Files:**
- Create: `lib/shared/widgets/ct_filter_chip.dart`
- Create: `lib/shared/widgets/ct_search_bar.dart`
- Create: `lib/shared/widgets/ct_gif_placeholder.dart`
- Create: `lib/shared/widgets/ct_exercise_card.dart`

- [ ] **Step 1: Create CTFilterChip**

Create `lib/shared/widgets/ct_filter_chip.dart`:

```dart
import 'package:flutter/material.dart';

import '../theme/ct_colors.dart';

class CTFilterChip extends StatelessWidget {
  const CTFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    final ct = context.ct;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: ct.surface,
      selectedColor: ct.accent,
      checkmarkColor: ct.bg,
      labelStyle: TextStyle(
        fontSize: 12,
        color: selected ? ct.bg : Colors.white70,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: selected ? ct.accent : ct.elevated,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      showCheckmark: false,
    );
  }
}
```

- [ ] **Step 2: Create CTSearchBar**

Create `lib/shared/widgets/ct_search_bar.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/ct_colors.dart';

class CTSearchBar extends StatelessWidget {
  const CTSearchBar({
    super.key,
    required this.onChanged,
    this.controller,
    this.hint = 'Search exercises…',
  });

  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final ct = context.ct;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: const Icon(LucideIcons.search, size: 18, color: Colors.white38),
        suffixIcon: controller != null
            ? ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller!,
                builder: (_, value, __) => value.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: const Icon(LucideIcons.x, size: 16),
                        color: Colors.white54,
                        onPressed: () {
                          controller!.clear();
                          onChanged('');
                        },
                      ),
              )
            : null,
        filled: true,
        fillColor: ct.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      ),
    );
  }
}
```

- [ ] **Step 3: Create CTGifPlaceholder**

Create `lib/shared/widgets/ct_gif_placeholder.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CTGifPlaceholder extends StatelessWidget {
  const CTGifPlaceholder({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF242424),
      highlightColor: const Color(0xFF333333),
      child: Container(
        width: width,
        height: height,
        color: const Color(0xFF242424),
      ),
    );
  }
}
```

- [ ] **Step 4: Create CTExerciseCard**

Create `lib/shared/widgets/ct_exercise_card.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/models/exercise.dart';
import '../theme/ct_colors.dart';
import 'ct_filter_chip.dart';

class CTExerciseCard extends StatelessWidget {
  const CTExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  final Exercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ct = context.ct;
    return Card(
      color: ct.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: ct.elevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.dumbbell, color: Colors.white38, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: [
                        CTFilterChip(
                          label: exercise.bodyPart,
                          selected: false,
                          onSelected: null,
                        ),
                        CTFilterChip(
                          label: exercise.equipment,
                          selected: false,
                          onSelected: null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, size: 16, color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Write a widget test for CTExerciseCard**

Add to (or create) `test/shared/widgets/ct_exercise_card_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/core/models/exercise.dart';
import 'package:costrutrain/shared/widgets/ct_exercise_card.dart';
import 'package:costrutrain/shared/theme/app_theme.dart';

void main() {
  const exercise = Exercise(
    id: '1',
    source: 'exercisedb',
    name: 'Barbell Curl',
    bodyPart: 'upper arms',
    targetPrimary: 'biceps',
    equipment: 'barbell',
  );

  testWidgets('displays exercise name, bodyPart, and equipment', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: CTExerciseCard(
          exercise: exercise,
          onTap: () => tapped = true,
        ),
      ),
    ));

    expect(find.text('Barbell Curl'), findsOneWidget);
    expect(find.text('upper arms'), findsOneWidget);
    expect(find.text('barbell'), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: CTExerciseCard(
          exercise: exercise,
          onTap: () => tapped = true,
        ),
      ),
    ));

    await tester.tap(find.byType(CTExerciseCard));
    expect(tapped, isTrue);
  });
}
```

- [ ] **Step 6: Run the widget test**

```bash
/home/dave/flutter/bin/flutter test test/shared/widgets/ct_exercise_card_test.dart --reporter=expanded
```

Expected: both tests PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/shared/widgets/ test/shared/
git commit -m "feat: CTFilterChip, CTSearchBar, CTGifPlaceholder, CTExerciseCard shared widgets"
```

---

## Task 8: FilterSheet

**Files:**
- Create: `lib/features/library/widgets/filter_sheet.dart`

These are the exact values from the Body Part Exercise Collection dataset.

- [ ] **Step 1: Create the filter bottom sheet**

Create `lib/features/library/widgets/filter_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/ct_colors.dart';
import '../../../shared/widgets/ct_filter_chip.dart';
import '../providers/library_filter_notifier.dart';

const _bodyParts = [
  'back', 'cardio', 'chest', 'lower arms', 'lower legs',
  'neck', 'shoulders', 'upper arms', 'upper legs', 'waist',
];

const _equipment = [
  'assisted', 'band', 'barbell', 'body weight', 'bosu ball',
  'cable', 'dumbbell', 'ez barbell', 'leverage machine',
  'medicine ball', 'resistance band', 'roller', 'rope',
  'smith machine', 'stability ball', 'stationary bike',
  'trap bar', 'wheel roller',
];

const _muscleGroups = [
  'abs', 'adductors', 'biceps', 'calves', 'cardiovascular system',
  'delts', 'glutes', 'hamstrings', 'lats', 'levator scapulae',
  'pectorals', 'quads', 'serratus anterior', 'spine', 'traps',
  'triceps', 'upper back',
];

class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(libraryFilterProvider);
    final notifier = ref.read(libraryFilterProvider.notifier);
    final ct = context.ct;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: ct.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ct.elevated,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                children: [
                  _Section(
                    title: 'Body Part',
                    values: _bodyParts,
                    selected: filter.bodyPart,
                    onSelect: (v) => notifier.setBodyPart(v == filter.bodyPart ? null : v),
                  ),
                  _Section(
                    title: 'Equipment',
                    values: _equipment,
                    selected: filter.equipment,
                    onSelect: (v) => notifier.setEquipment(v == filter.equipment ? null : v),
                  ),
                  _Section(
                    title: 'Muscle Group',
                    values: _muscleGroups,
                    selected: filter.muscleGroup,
                    onSelect: (v) => notifier.setMuscleGroup(v == filter.muscleGroup ? null : v),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        notifier.clearAll();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Clear all'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.values,
    required this.selected,
    required this.onSelect,
  });

  final String title;
  final List<String> values;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white54),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: values
              .map((v) => CTFilterChip(
                    label: v,
                    selected: selected == v,
                    onSelected: (_) => onSelect(v),
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/library/widgets/filter_sheet.dart
git commit -m "feat: FilterSheet — DraggableScrollableSheet with body part/equipment/muscle group chips"
```

---

## Task 9: ExerciseDetailScreen

**Files:**
- Create: `lib/features/library/views/exercise_detail_screen.dart`

- [ ] **Step 1: Create the detail screen**

Create `lib/features/library/views/exercise_detail_screen.dart`:

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/models/exercise.dart';
import '../../../data/repositories/bundled_json_exercise_repository.dart';
import '../../../shared/theme/ct_colors.dart';
import '../../../shared/widgets/ct_filter_chip.dart';
import '../../../shared/widgets/ct_gif_placeholder.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncExercise = ref.watch(
      _exerciseDetailProvider(exerciseId),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.ct.bg,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: asyncExercise.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (exercise) {
          if (exercise == null) {
            return const Center(child: Text('Exercise not found'));
          }
          final ct = context.ct;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: exercise.gifUrl != null
                      ? CachedNetworkImage(
                          imageUrl: exercise.gifUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              const CTGifPlaceholder(height: 300),
                          errorWidget: (_, __, ___) => Container(
                            color: ct.elevated,
                            child: const Icon(
                              LucideIcons.dumbbell,
                              size: 64,
                              color: Colors.white24,
                            ),
                          ),
                        )
                      : Container(
                          color: ct.elevated,
                          child: const Icon(
                            LucideIcons.dumbbell,
                            size: 64,
                            color: Colors.white24,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          CTFilterChip(
                            label: exercise.bodyPart,
                            selected: false,
                            onSelected: null,
                          ),
                          CTFilterChip(
                            label: exercise.equipment,
                            selected: false,
                            onSelected: null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _InfoRow(label: 'Primary muscle', value: exercise.targetPrimary),
                      if (exercise.muscleGroup != null &&
                          exercise.muscleGroup != exercise.targetPrimary)
                        _InfoRow(label: 'Muscle group', value: exercise.muscleGroup!),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// Private provider — scoped to this file.
final _exerciseDetailProvider = FutureProvider.autoDispose
    .family<Exercise?, String>((ref, id) async {
  return ref.watch(exerciseRepositoryProvider).getById(id);
});
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/library/views/exercise_detail_screen.dart
git commit -m "feat: ExerciseDetailScreen — CachedNetworkImage GIF + primary muscle info"
```

---

## Task 10: ExerciseListScreen rebuild + l10n strings

**Files:**
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/features/library/views/exercise_list_screen.dart`
- Modify: `test/features/library/views/exercise_list_screen_test.dart`

- [ ] **Step 1: Read the existing app_en.arb to know current keys**

Read `lib/l10n/app_en.arb` and note all existing keys (do not overwrite them). Add only new keys.

- [ ] **Step 2: Add new l10n keys to app_en.arb**

Add the following keys to `lib/l10n/app_en.arb` (keep all existing keys):

```json
"searchExercises": "Search exercises…",
"noExercisesFound": "No exercises found",
"clearFilters": "Clear filters",
"filterExercises": "Filter exercises"
```

- [ ] **Step 3: Regenerate l10n**

```bash
/home/dave/flutter/bin/flutter gen-l10n
```

Expected: `lib/generated/l10n/app_localizations_en.dart` updated with new keys.

- [ ] **Step 4: Rebuild ExerciseListScreen**

Replace `lib/features/library/views/exercise_list_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/ct_exercise_card.dart';
import '../../../shared/widgets/ct_filter_chip.dart';
import '../../../shared/widgets/ct_search_bar.dart';
import '../providers/exercise_search_results_provider.dart';
import '../providers/library_filter_notifier.dart';
import '../widgets/filter_sheet.dart';

class ExerciseListScreen extends ConsumerStatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncExercises = ref.watch(exerciseSearchResultsProvider);
    final filter = ref.watch(libraryFilterProvider);
    final notifier = ref.read(libraryFilterProvider.notifier);

    final activeFilters = [
      if (filter.bodyPart != null) (label: filter.bodyPart!, clear: () => notifier.setBodyPart(null)),
      if (filter.equipment != null) (label: filter.equipment!, clear: () => notifier.setEquipment(null)),
      if (filter.muscleGroup != null) (label: filter.muscleGroup!, clear: () => notifier.setMuscleGroup(null)),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: CTSearchBar(
                controller: _searchController,
                hint: context.l10n.searchExercises,
                onChanged: notifier.setQuery,
              ),
            ),
            if (activeFilters.isNotEmpty)
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: activeFilters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (_, i) {
                    final f = activeFilters[i];
                    return CTFilterChip(
                      label: f.label,
                      selected: true,
                      onSelected: (_) => f.clear(),
                    );
                  },
                ),
              ),
            Expanded(
              child: asyncExercises.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: $e'),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () => ref.invalidate(exerciseSearchResultsProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (exercises) => exercises.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(context.l10n.noExercisesFound),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                notifier.clearAll();
                                _searchController.clear();
                              },
                              child: Text(context.l10n.clearFilters),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: exercises.length,
                        itemBuilder: (_, i) => CTExerciseCard(
                          exercise: exercises[i],
                          onTap: () => context.push('/library/${exercises[i].id}'),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFilterSheet,
        tooltip: context.l10n.filterExercises,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(LucideIcons.slidersHorizontal),
            if (filter.hasActiveFilters)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8FF00),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Rebuild the ExerciseListScreen test**

Replace `test/features/library/views/exercise_list_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:costrutrain/core/models/exercise.dart';
import 'package:costrutrain/features/library/providers/exercise_search_results_provider.dart';
import 'package:costrutrain/features/library/views/exercise_list_screen.dart';
import 'package:costrutrain/generated/l10n/app_localizations.dart';
import 'package:costrutrain/shared/theme/app_theme.dart';

Widget _wrap(Widget child, List<Override> overrides) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );

final _fakeExercises = [
  const Exercise(
      id: '1',
      source: 'exercisedb',
      name: 'Push-up',
      bodyPart: 'chest',
      targetPrimary: 'pectorals',
      equipment: 'body weight'),
  const Exercise(
      id: '2',
      source: 'exercisedb',
      name: 'Squat',
      bodyPart: 'upper legs',
      targetPrimary: 'quads',
      equipment: 'body weight'),
];

void main() {
  testWidgets('renders exercise cards with name and chips', (tester) async {
    await tester.pumpWidget(_wrap(
      const ExerciseListScreen(),
      [exerciseSearchResultsProvider.overrideWith((ref) async => _fakeExercises)],
    ));
    await tester.pump();
    expect(find.text('Push-up'), findsOneWidget);
    expect(find.text('Squat'), findsOneWidget);
    expect(find.text('chest'), findsOneWidget);
    expect(find.text('upper legs'), findsOneWidget);
  });

  testWidgets('shows "No exercises found" when list is empty', (tester) async {
    await tester.pumpWidget(_wrap(
      const ExerciseListScreen(),
      [exerciseSearchResultsProvider.overrideWith((ref) async => [])],
    ));
    await tester.pump();
    expect(find.text('No exercises found'), findsOneWidget);
  });

  testWidgets('shows loading indicator while loading', (tester) async {
    await tester.pumpWidget(_wrap(
      const ExerciseListScreen(),
      [
        exerciseSearchResultsProvider.overrideWith(
          (ref) => Future.delayed(const Duration(seconds: 10), () => <Exercise>[]),
        ),
      ],
    ));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

- [ ] **Step 6: Run the list screen tests**

```bash
/home/dave/flutter/bin/flutter test test/features/library/views/exercise_list_screen_test.dart --reporter=expanded
```

Expected: all 3 tests PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/l10n/app_en.arb lib/generated/l10n/ lib/features/library/views/exercise_list_screen.dart test/features/library/views/exercise_list_screen_test.dart
git commit -m "feat: rebuild ExerciseListScreen — search, filter chips, CTExerciseCard list"
```

---

## Task 11: Remove getAll() + exercises_provider + Router update

**Files:**
- Modify: `lib/data/repositories/exercise_repository.dart`
- Modify: `lib/data/repositories/bundled_json_exercise_repository.dart`
- Modify: `lib/core/router.dart`
- Modify: `test/data/repositories/bundled_json_exercise_repository_test.dart`
- Delete: `lib/features/library/providers/exercises_provider.dart`
- Delete: `lib/features/library/providers/exercises_provider.g.dart`

- [ ] **Step 1: Remove getAll() from ExerciseRepository interface**

Replace `lib/data/repositories/exercise_repository.dart`:

```dart
import 'package:costrutrain/core/models/exercise.dart';

abstract interface class ExerciseRepository {
  Future<Exercise?> getById(String id);

  Future<List<Exercise>> search({
    String? query,
    String? bodyPart,
    String? equipment,
    String? muscleGroup,
  });
}
```

- [ ] **Step 2: Remove getAll() from BundledJsonExerciseRepository**

In `lib/data/repositories/bundled_json_exercise_repository.dart`, delete the `getAll()` method. The file should no longer contain:

```dart
  @override
  Future<List<model.Exercise>> getAll() async {
    final rows = await _db.select(_db.exercises).get();
    return rows.map(_fromData).toList();
  }
```

- [ ] **Step 3: Replace getAll() tests with equivalent search() tests**

Replace `test/data/repositories/bundled_json_exercise_repository_test.dart`:

```dart
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
}
```

- [ ] **Step 4: Delete the old exercises_provider files**

```bash
rm /mnt/d/Coding/CostruTrain/lib/features/library/providers/exercises_provider.dart
rm /mnt/d/Coding/CostruTrain/lib/features/library/providers/exercises_provider.g.dart
```

- [ ] **Step 5: Add the detail route OUTSIDE the ShellRoute in router.dart**

Replace `lib/core/router.dart`:

```dart
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/local/shared_prefs_provider.dart';
import '../features/composer/views/composer_screen.dart';
import '../features/history/views/history_screen.dart';
import '../features/library/views/exercise_detail_screen.dart';
import '../features/library/views/exercise_list_screen.dart';
import '../features/library/views/seed_splash_screen.dart';
import '../features/settings/views/settings_screen.dart';
import '../shared/widgets/scaffold_with_nav.dart';

part 'router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final prefs = ref.read(sharedPrefsProvider);
  return GoRouter(
    initialLocation: '/library',
    redirect: (context, state) {
      final seeded = prefs.getBool('seeded') ?? false;
      if (!seeded && state.matchedLocation != '/splash') return '/splash';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SeedSplashScreen(),
      ),
      // Detail route is OUTSIDE ShellRoute — full-screen push, no bottom nav.
      GoRoute(
        path: '/library/:exerciseId',
        builder: (context, state) => ExerciseDetailScreen(
          exerciseId: state.pathParameters['exerciseId']!,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNav(child: child),
        routes: [
          GoRoute(
            path: '/library',
            builder: (context, state) => const ExerciseListScreen(),
          ),
          GoRoute(
            path: '/compose',
            builder: (context, state) => const ComposerScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
```

- [ ] **Step 6: Run build_runner to regenerate router.g.dart**

```bash
/home/dave/flutter/bin/dart run build_runner build --delete-conflicting-outputs
```

Expected: `router.g.dart` regenerated cleanly.

- [ ] **Step 7: Run the full test suite**

```bash
/home/dave/flutter/bin/flutter test --reporter=expanded
```

Expected: all tests pass.

- [ ] **Step 8: Commit**

```bash
git add lib/data/repositories/ lib/core/router.dart lib/core/router.g.dart test/data/repositories/bundled_json_exercise_repository_test.dart
git rm lib/features/library/providers/exercises_provider.dart lib/features/library/providers/exercises_provider.g.dart
git commit -m "refactor: remove getAll(), delete exercises_provider, add detail route outside ShellRoute"
```

---

## Task 12: flutter analyze + flutter test + smoke test

**Files:** None

- [ ] **Step 1: Run flutter analyze**

```bash
/home/dave/flutter/bin/flutter analyze
```

Expected: `No issues found!` Fix any warnings before proceeding.

- [ ] **Step 2: Run all tests**

```bash
/home/dave/flutter/bin/flutter test --reporter=expanded
```

Expected: all tests pass (17 original + new tests).

- [ ] **Step 3: Manual smoke test on Web (or Android)**

```bash
/home/dave/flutter/bin/flutter run -d chrome
```

Verify manually:
- App opens, seed splash runs on first launch
- Library screen loads with all exercises in a card list
- Search bar filters exercises by name (debounced)
- Filter FAB opens bottom sheet; selecting a chip filters results
- Active filter chips appear below search bar; tapping clears that filter
- Tapping a card pushes to detail screen (no bottom nav visible)
- Detail screen shows exercise name, chips, primary muscle
- GIF loads (shimmer → image) if device has internet; shows placeholder icon if not
- Back button returns to library with nav bar restored

- [ ] **Step 4: Commit final**

```bash
git add -A
git commit -m "feat: Phase 1 complete — Exercise Library with FTS5 search, filters, GIF detail"
```
