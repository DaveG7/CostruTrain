# Phase 0 — Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a runnable Flutter skeleton with dark theme, go_router navigation, i18n infrastructure, Drift-backed exercise seeding (first-launch only), and a basic exercise list screen — `flutter run` green on Android, Web, and macOS.

**Architecture:** Shell-first — get navigation running with placeholder screens, then add the data layer (Drift + ExerciseRepository), then the seed flow (SeedService → SeedNotifier → splash screen), then the exercise list. A standalone spike measures insert performance before committing to chunk size.

**Tech Stack:** Flutter 3.x · Dart · flutter_riverpod + riverpod_annotation · go_router · Drift + drift_flutter · shared_preferences · flutter_localizations + intl · flutter_native_splash

**Spec:** `docs/superpowers/specs/2026-04-29-phase0-foundation-design.md`

---

## File Map

| File | Purpose |
|---|---|
| `pubspec.yaml` | All runtime + dev dependencies, asset declaration |
| `l10n.yaml` | flutter gen-l10n config |
| `assets/seed/exercises.json` | Bundled Body Part Collection (~1300 exercises) |
| `lib/main.dart` | Pre-load SharedPreferences, ProviderScope override, runApp |
| `lib/app.dart` | CostruTrainApp (ConsumerWidget) — MaterialApp.router + l10n |
| `lib/core/router.dart` | goRouterProvider — ShellRoute, redirect guard |
| `lib/core/models/exercise.dart` | Exercise value class + fromJson + fromData |
| `lib/core/utils/extensions.dart` | BuildContext.l10n extension |
| `lib/l10n/app_en.arb` | All EN strings (template) |
| `lib/l10n/app_de.arb` | `{"@@locale": "de"}` only |
| `lib/data/local/app_database.dart` | Drift AppDatabase, Exercises table, appDatabaseProvider |
| `lib/data/local/shared_prefs_provider.dart` | sharedPrefsProvider (overridden in main.dart) |
| `lib/data/repositories/exercise_repository.dart` | Abstract ExerciseRepository interface |
| `lib/data/repositories/bundled_json_exercise_repository.dart` | Drift-backed impl + exerciseRepositoryProvider |
| `lib/data/seed/seed_service.dart` | Chunked batch insert, runWithJson() for testability |
| `lib/data/seed/seed_state.dart` | SeedState value class (done, total, isDone getter) |
| `lib/data/seed/seed_notifier.dart` | AsyncNotifier\<SeedState\>, writes SharedPreferences flag |
| `lib/shared/theme/app_theme.dart` | Dark theme tokens |
| `lib/shared/widgets/scaffold_with_nav.dart` | Persistent bottom NavigationBar (ShellRoute child) |
| `lib/features/library/views/seed_splash_screen.dart` | Branded splash, progress bar, retry button |
| `lib/features/library/views/exercise_list_screen.dart` | ListView.builder — name + bodyPart chip |
| `lib/features/library/providers/exercises_provider.dart` | exercisesProvider (FutureProvider) |
| `lib/features/composer/views/composer_screen.dart` | Empty placeholder |
| `lib/features/history/views/history_screen.dart` | Empty placeholder |
| `lib/features/settings/views/settings_screen.dart` | Empty placeholder |
| `test/core/models/exercise_test.dart` | Exercise.fromJson unit tests |
| `test/data/repositories/bundled_json_exercise_repository_test.dart` | getAll + getById tests |
| `test/data/seed/seed_service_test.dart` | Chunked insert + progress callback tests |
| `test/data/seed/seed_notifier_test.dart` | Fast path + seeding path + error path |
| `test/features/library/views/seed_splash_screen_test.dart` | Widget tests for all 4 states |
| `test/features/library/views/exercise_list_screen_test.dart` | Widget test — renders list |

---

## Task 1: Project scaffold and dependencies

**Files:**
- Create: `pubspec.yaml`
- Create: `l10n.yaml`
- Create: `analysis_options.yaml`
- Create: all `lib/` and `test/` subdirectories
- Create: `assets/seed/` directory (exercises.json added in Task 5)

- [ ] **Step 1: Run flutter create in the existing directory**

```bash
flutter create \
  --org com.costrutrain \
  --project-name costrutrain \
  --platforms android,ios,macos,web \
  .
```

Expected: Flutter scaffolds the project files. Existing files (CLAUDE.md, ROADMAP.md, etc.) are not overwritten. Answer `y` if prompted to overwrite any generated file like `README.md`.

- [ ] **Step 2: Replace pubspec.yaml with full dependency list**

```yaml
name: costrutrain
description: "Privacy-first workout composer and player."
version: 1.0.0+1

environment:
  sdk: ">=3.4.0 <4.0.0"

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
  intl: ^0.19.0
  flutter_native_splash: ^2.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.12
  drift_dev: ^2.20.2
  riverpod_generator: ^2.4.3
  riverpod_lint: ^2.3.13
  custom_lint: ^0.6.4

flutter:
  uses-material-design: true
  generate: true
  assets:
    - assets/seed/exercises.json
```

- [ ] **Step 3: Write l10n.yaml**

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/generated/l10n
nullable-getter: false
```

- [ ] **Step 4: Write analysis_options.yaml**

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  plugins:
    - custom_lint
  errors:
    missing_required_param: error
    missing_return: error

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_declarations: true
    avoid_print: true
```

- [ ] **Step 5: Create folder structure**

```bash
mkdir -p \
  assets/seed \
  lib/core/models \
  lib/core/utils \
  lib/l10n \
  lib/data/local \
  lib/data/repositories \
  lib/data/seed \
  lib/features/library/views \
  lib/features/library/providers \
  lib/features/composer/views \
  lib/features/history/views \
  lib/features/settings/views \
  lib/shared/theme \
  lib/shared/widgets \
  test/core/models \
  test/data/repositories \
  test/data/seed \
  test/features/library/views
```

- [ ] **Step 6: Install dependencies**

```bash
flutter pub get
```

Expected: `Got dependencies!` with no resolution errors.

- [ ] **Step 7: Commit**

```bash
git add pubspec.yaml pubspec.lock l10n.yaml analysis_options.yaml
git commit -m "feat: flutter project scaffold and dependencies"
```

---

## Task 2: Exercise model (TDD)

**Files:**
- Create: `lib/core/models/exercise.dart`
- Create: `test/core/models/exercise_test.dart`

The `Exercise` model is the core domain object. `fromJson` maps the Body Part Collection JSON structure (fields: `id`, `name`, `bodyPart`, `target`, `equipment`, `gifUrl`). The internal `id` is prefixed to prevent collisions with future sources.

- [ ] **Step 1: Write the failing test**

```dart
// test/core/models/exercise_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/core/models/exercise.dart';

void main() {
  group('Exercise.fromJson', () {
    final json = {
      'id': '0042',
      'name': 'Push-up',
      'bodyPart': 'chest',
      'target': 'pectorals',
      'equipment': 'body weight',
      'gifUrl': 'https://example.com/push-up.gif',
    };

    test('maps all fields', () {
      final e = Exercise.fromJson(json);
      expect(e.id, 'exercisedb_0042');
      expect(e.externalId, '0042');
      expect(e.source, 'exercisedb');
      expect(e.name, 'Push-up');
      expect(e.bodyPart, 'chest');
      expect(e.targetPrimary, 'pectorals');
      expect(e.equipment, 'body weight');
      expect(e.gifUrl, 'https://example.com/push-up.gif');
    });

    test('gifUrl is nullable', () {
      final noGif = Map<String, dynamic>.from(json)..remove('gifUrl');
      expect(Exercise.fromJson(noGif).gifUrl, isNull);
    });
  });
}
```

- [ ] **Step 2: Run to confirm failure**

```bash
flutter test test/core/models/exercise_test.dart
```

Expected: `Error: Could not find package 'costrutrain'` or `Target of URI doesn't exist`.

- [ ] **Step 3: Implement Exercise model**

```dart
// lib/core/models/exercise.dart
class Exercise {
  final String id;
  final String? externalId;
  final String source;
  final String name;
  final String bodyPart;
  final String targetPrimary;
  final String equipment;
  final String? gifUrl;

  const Exercise({
    required this.id,
    this.externalId,
    required this.source,
    required this.name,
    required this.bodyPart,
    required this.targetPrimary,
    required this.equipment,
    this.gifUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: 'exercisedb_${json['id'] as String}',
        externalId: json['id'] as String,
        source: 'exercisedb',
        name: json['name'] as String,
        bodyPart: json['bodyPart'] as String,
        targetPrimary: json['target'] as String,
        equipment: json['equipment'] as String,
        gifUrl: json['gifUrl'] as String?,
      );
}
```

- [ ] **Step 4: Run tests — expect green**

```bash
flutter test test/core/models/exercise_test.dart
```

Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/core/models/exercise.dart test/core/models/exercise_test.dart
git commit -m "feat: Exercise model with fromJson"
```

---

## Task 3: i18n infrastructure + BuildContext extension

**Files:**
- Create: `lib/l10n/app_en.arb`
- Create: `lib/l10n/app_de.arb`
- Create: `lib/core/utils/extensions.dart`

- [ ] **Step 1: Write app_en.arb**

```json
{
  "@@locale": "en",
  "navLibrary": "Library",
  "@navLibrary": {"description": "Bottom nav label — Exercise Library tab"},
  "navCompose": "Compose",
  "@navCompose": {"description": "Bottom nav label — Workout Composer tab"},
  "navHistory": "History",
  "@navHistory": {"description": "Bottom nav label — Session History tab"},
  "navSettings": "Settings",
  "@navSettings": {"description": "Bottom nav label — Settings tab"},
  "seedingProgress": "Setting up your exercise library…",
  "@seedingProgress": {"description": "Progress message during first-launch seeding"},
  "seedError": "Something went wrong. Please try again.",
  "@seedError": {"description": "Error message when seeding fails"},
  "seedRetry": "Retry",
  "@seedRetry": {"description": "Retry button label after seed failure"},
  "exercisesEmpty": "No exercises found.",
  "@exercisesEmpty": {"description": "Empty state label on exercise list screen"}
}
```

- [ ] **Step 2: Write app_de.arb**

```json
{
  "@@locale": "de"
}
```

Note: no empty string values — missing keys fall back to EN automatically.

- [ ] **Step 3: Write BuildContext extension**

```dart
// lib/core/utils/extensions.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

- [ ] **Step 4: Generate localizations**

```bash
dart run intl_utils:generate
```

If `intl_utils` is not available, use:
```bash
flutter gen-l10n
```

Expected: `lib/generated/l10n/app_localizations.dart` (and `_en.dart`, `_de.dart`) created.

- [ ] **Step 5: Commit**

```bash
git add lib/l10n/ lib/core/utils/extensions.dart
git commit -m "feat: i18n infrastructure — ARB files and BuildContext.l10n extension"
```

---

## Task 4: Theme + ScaffoldWithNav

**Files:**
- Create: `lib/shared/theme/app_theme.dart`
- Create: `lib/shared/widgets/scaffold_with_nav.dart`

- [ ] **Step 1: Write AppTheme**

```dart
// lib/shared/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color _bg = Color(0xFF0F0F0F);
  static const Color _surface = Color(0xFF1A1A1A);
  static const Color _accent = Color(0xFFE8FF00); // CrossFit yellow-green

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _bg,
        colorScheme: const ColorScheme.dark(
          primary: _accent,
          secondary: _accent,
          surface: _surface,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: _surface,
          indicatorColor: Color(0x33E8FF00),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: _surface,
          labelStyle: const TextStyle(fontSize: 12),
          side: BorderSide(color: _accent.withValues(alpha: 0.4)),
        ),
        useMaterial3: true,
      );
}
```

- [ ] **Step 2: Write ScaffoldWithNav**

```dart
// lib/shared/widgets/scaffold_with_nav.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/extensions.dart';

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.child});

  final Widget child;

  static int _indexForLocation(String location) {
    if (location.startsWith('/library')) return 0;
    if (location.startsWith('/compose')) return 1;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexForLocation(location),
        onDestinationSelected: (i) {
          const routes = ['/library', '/compose', '/history', '/settings'];
          context.go(routes[i]);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.fitness_center_outlined),
            selectedIcon: const Icon(Icons.fitness_center),
            label: context.l10n.navLibrary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_box_outlined),
            selectedIcon: const Icon(Icons.add_box),
            label: context.l10n.navCompose,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: context.l10n.navHistory,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: context.l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/shared/theme/app_theme.dart lib/shared/widgets/scaffold_with_nav.dart
git commit -m "feat: dark theme tokens and ScaffoldWithNav"
```

---

## Task 5: Drift schema, AppDatabase, SharedPreferences provider

**Files:**
- Create: `lib/data/local/app_database.dart`
- Create: `lib/data/local/shared_prefs_provider.dart`

These files use code generation. Run `build_runner` after writing them.

- [ ] **Step 1: Write AppDatabase**

```dart
// lib/data/local/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Exercises])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'costrutrain'));

  AppDatabase.forTesting() : super(NativeDatabase.memory());

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

- [ ] **Step 2: Write SharedPreferences provider**

```dart
// lib/data/local/shared_prefs_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPrefs(SharedPrefsRef ref) {
  throw UnimplementedError(
    'sharedPrefsProvider must be overridden in main.dart via ProviderScope.',
  );
}
```

- [ ] **Step 3: Run code generation**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: `app_database.g.dart` and `shared_prefs_provider.g.dart` created. No errors.

- [ ] **Step 4: Commit**

```bash
git add lib/data/local/ 
git commit -m "feat: Drift AppDatabase schema v1 and SharedPreferences provider"
```

---

## Task 6: ExerciseRepository (TDD)

**Files:**
- Create: `lib/data/repositories/exercise_repository.dart`
- Create: `lib/data/repositories/bundled_json_exercise_repository.dart`
- Create: `test/data/repositories/bundled_json_exercise_repository_test.dart`

- [ ] **Step 1: Write the failing tests**

```dart
// test/data/repositories/bundled_json_exercise_repository_test.dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/data/local/app_database.dart';
import 'package:costrutrain/data/repositories/bundled_json_exercise_repository.dart';

void main() {
  late AppDatabase db;
  late BundledJsonExerciseRepository repo;

  setUp(() {
    db = AppDatabase.forTesting();
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
```

- [ ] **Step 2: Run to confirm failure**

```bash
flutter test test/data/repositories/bundled_json_exercise_repository_test.dart
```

Expected: compile error — classes not defined yet.

- [ ] **Step 3: Write the abstract interface**

```dart
// lib/data/repositories/exercise_repository.dart
import '../../../lib/core/models/exercise.dart';

// getAll() is Phase 0 only.
// Phase 1 replaces it with search({String? query, String? bodyPart, String? equipment}).
abstract interface class ExerciseRepository {
  Future<List<Exercise>> getAll();
  Future<Exercise?> getById(String id);
}
```

Fix import path — in Dart, imports inside `lib/` use the package form:

```dart
// lib/data/repositories/exercise_repository.dart
import 'package:costrutrain/core/models/exercise.dart';

abstract interface class ExerciseRepository {
  Future<List<Exercise>> getAll();
  Future<Exercise?> getById(String id);
}
```

- [ ] **Step 4: Write BundledJsonExerciseRepository**

```dart
// lib/data/repositories/bundled_json_exercise_repository.dart
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/exercise.dart';
import '../local/app_database.dart';
import 'exercise_repository.dart';

part 'bundled_json_exercise_repository.g.dart';

class BundledJsonExerciseRepository implements ExerciseRepository {
  const BundledJsonExerciseRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Exercise>> getAll() async {
    final rows = await _db.select(_db.exercises).get();
    return rows.map(_fromData).toList();
  }

  @override
  Future<Exercise?> getById(String id) async {
    final row = await (_db.select(_db.exercises)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromData(row);
  }

  Exercise _fromData(ExerciseData data) => Exercise(
        id: data.id,
        externalId: data.externalId,
        source: data.source,
        name: data.name,
        bodyPart: data.bodyPart,
        targetPrimary: data.targetPrimary,
        equipment: data.equipment,
        gifUrl: data.gifUrl,
      );
}

@Riverpod(keepAlive: true)
ExerciseRepository exerciseRepository(ExerciseRepositoryRef ref) {
  return BundledJsonExerciseRepository(ref.watch(appDatabaseProvider));
}
```

- [ ] **Step 5: Run code generation**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 6: Run tests — expect green**

```bash
flutter test test/data/repositories/bundled_json_exercise_repository_test.dart
```

Expected: `All tests passed!`

- [ ] **Step 7: Commit**

```bash
git add lib/data/repositories/ test/data/repositories/
git commit -m "feat: ExerciseRepository interface and BundledJsonExerciseRepository"
```

---

## Task 7: GoRouter + placeholder screens + main.dart + flutter_native_splash

**Files:**
- Create: `lib/core/router.dart`
- Create: `lib/features/composer/views/composer_screen.dart`
- Create: `lib/features/history/views/history_screen.dart`
- Create: `lib/features/settings/views/settings_screen.dart`
- Create: `lib/app.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: Write placeholder screens**

```dart
// lib/features/composer/views/composer_screen.dart
import 'package:flutter/material.dart';

class ComposerScreen extends StatelessWidget {
  const ComposerScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Composer — coming soon'));
}
```

```dart
// lib/features/history/views/history_screen.dart
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('History — coming soon'));
}
```

```dart
// lib/features/settings/views/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Settings — coming soon'));
}
```

- [ ] **Step 2: Write goRouterProvider**

```dart
// lib/core/router.dart
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/local/shared_prefs_provider.dart';
import '../features/composer/views/composer_screen.dart';
import '../features/history/views/history_screen.dart';
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

Note: `SeedSplashScreen` and `ExerciseListScreen` are imported here but written in Tasks 12 and 13. Create empty placeholder versions now:

```dart
// lib/features/library/views/seed_splash_screen.dart  (temporary placeholder)
import 'package:flutter/material.dart';
class SeedSplashScreen extends StatelessWidget {
  const SeedSplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );
}
```

```dart
// lib/features/library/views/exercise_list_screen.dart  (temporary placeholder)
import 'package:flutter/material.dart';
class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Text('Exercises')),
  );
}
```

- [ ] **Step 3: Write app.dart**

```dart
// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'shared/theme/app_theme.dart';

class CostruTrainApp extends ConsumerWidget {
  const CostruTrainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'CostruTrain',
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      localizationsDelegates: const [
        // AppLocalizations.localizationsDelegates — added after gen-l10n runs
      ],
      supportedLocales: const [Locale('en'), Locale('de')],
    );
  }
}
```

You will add `AppLocalizations.localizationsDelegates` after confirming `flutter gen-l10n` ran (Step 4 of Task 3). Replace the comment with:
```dart
localizationsDelegates: AppLocalizations.localizationsDelegates,
supportedLocales: AppLocalizations.supportedLocales,
```
And add import: `import 'package:flutter_gen/gen_l10n/app_localizations.dart';`

- [ ] **Step 4: Write main.dart**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/local/shared_prefs_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const CostruTrainApp(),
    ),
  );
}
```

- [ ] **Step 5: Run code generation for router**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 6: Commit**

```bash
git add lib/core/router.dart lib/core/router.g.dart lib/app.dart lib/main.dart \
        lib/features/composer/ lib/features/history/ lib/features/settings/ \
        lib/features/library/views/seed_splash_screen.dart \
        lib/features/library/views/exercise_list_screen.dart
git commit -m "feat: GoRouter shell — ShellRoute, placeholder screens, main.dart wiring"
```

---

## Task 8: Checkpoint 1 — shell running

- [ ] **Step 1: Run flutter analyze**

```bash
flutter analyze
```

Expected: `No issues found!` (or only info-level hints).

- [ ] **Step 2: Run on Web**

```bash
flutter run -d chrome
```

Expected: app opens, dark background, bottom nav with 4 tabs, placeholder screen content visible.

- [ ] **Step 3: Run on macOS**

```bash
flutter run -d macos
```

Expected: same as Web.

- [ ] **Step 4: Run on Android emulator**

Start an AVD in Android Studio or via `flutter emulators --launch <id>`, then:

```bash
flutter run -d android
```

Expected: same as above.

If you are on first launch (no seeded flag), you will see the placeholder SeedSplashScreen — this is correct. The real splash is written in Task 12.

---

## Task 9: Seed spike — performance measurement

**Files:**
- Create: `main_seed_spike.dart` (deleted after measurement)

This is an exploratory task. No tests. Delete the file when done.

- [ ] **Step 1: Download exercises.json**

Download the Body Part Exercise Collection JSON to `assets/seed/exercises.json`. The file should be a JSON array of objects, each with keys: `id`, `name`, `bodyPart`, `target`, `equipment`, `gifUrl`.

Verify:
```bash
wc -l assets/seed/exercises.json
python3 -c "import json; d=json.load(open('assets/seed/exercises.json')); print(len(d), 'exercises')"
```

Expected: approximately 1300 entries.

- [ ] **Step 2: Write the spike**

```dart
// main_seed_spike.dart  — DELETE AFTER MEASURING
import 'dart:convert';
import 'dart:math';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'lib/core/models/exercise.dart';
import 'lib/data/local/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase(NativeDatabase.memory());

  final raw = await rootBundle.loadString('assets/seed/exercises.json');
  final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  final exercises = list.map(Exercise.fromJson).toList();

  const chunkSize = 100;
  final total = (exercises.length / chunkSize).ceil();
  final overall = Stopwatch()..start();

  for (var i = 0; i < total; i++) {
    final sw = Stopwatch()..start();
    final chunk = exercises.sublist(i * chunkSize, min((i + 1) * chunkSize, exercises.length));
    await db.batch((b) => b.insertAllOnConflictUpdate(
          db.exercises,
          chunk.map((e) => ExercisesCompanion.insert(
                id: e.id,
                externalId: Value(e.externalId),
                source: e.source,
                name: e.name,
                bodyPart: e.bodyPart,
                targetPrimary: e.targetPrimary,
                equipment: e.equipment,
                gifUrl: Value(e.gifUrl),
              )).toList(),
        ));
    print('Chunk ${i + 1}/$total: ${sw.elapsedMilliseconds}ms');
  }

  print('TOTAL: ${overall.elapsedMilliseconds}ms for ${exercises.length} exercises');
  await db.close();
}
```

- [ ] **Step 3: Run spike on device**

```bash
flutter run -d android --target main_seed_spike.dart
```

Read the console output. Record the total time.

- [ ] **Step 4: Evaluate results**

| Result | Action |
|---|---|
| Total < 800ms | Proceed with `chunkSize = 100` (default in SeedService) |
| Total 800ms–2000ms | Increase to `chunkSize = 200` — update SeedService default |
| Total > 2000ms | Increase to `chunkSize = 500` — update SeedService default |

- [ ] **Step 5: Delete spike file**

```bash
rm main_seed_spike.dart
git add -A
git commit -m "chore: add exercises.json asset (spike complete, chunkSize confirmed)"
```

---

## Task 10: SeedService (TDD)

**Files:**
- Create: `lib/data/seed/seed_service.dart`
- Create: `test/data/seed/seed_service_test.dart`

`SeedService` exposes two methods: `run()` (loads from Flutter asset) and `runWithJson()` (accepts raw JSON string — used in tests to bypass `rootBundle`).

- [ ] **Step 1: Write the failing tests**

```dart
// test/data/seed/seed_service_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/data/local/app_database.dart';
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
    db = AppDatabase.forTesting();
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
```

- [ ] **Step 2: Run to confirm failure**

```bash
flutter test test/data/seed/seed_service_test.dart
```

Expected: compile error.

- [ ] **Step 3: Implement SeedService**

```dart
// lib/data/seed/seed_service.dart
import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../../core/models/exercise.dart';
import '../local/app_database.dart';

class SeedService {
  const SeedService({this.defaultAsset = 'assets/seed/exercises.json'});

  final String defaultAsset;

  Future<void> run({
    required AppDatabase db,
    String? assetPath,
    int chunkSize = 100,
    void Function(int done, int total)? onProgress,
  }) async {
    final raw = await rootBundle.loadString(assetPath ?? defaultAsset);
    await runWithJson(db: db, json: raw, chunkSize: chunkSize, onProgress: onProgress);
  }

  Future<void> runWithJson({
    required AppDatabase db,
    required String json,
    int chunkSize = 100,
    void Function(int done, int total)? onProgress,
  }) async {
    final list = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
    final exercises = list.map(Exercise.fromJson).toList();
    final total = (exercises.length / chunkSize).ceil();

    for (var i = 0; i < total; i++) {
      final chunk = exercises.sublist(
        i * chunkSize,
        min((i + 1) * chunkSize, exercises.length),
      );
      await db.batch((b) => b.insertAllOnConflictUpdate(
            db.exercises,
            chunk.map(_toCompanion).toList(),
          ));
      onProgress?.call(i + 1, total);
    }
  }

  ExercisesCompanion _toCompanion(Exercise e) => ExercisesCompanion.insert(
        id: e.id,
        externalId: Value(e.externalId),
        source: e.source,
        name: e.name,
        bodyPart: e.bodyPart,
        targetPrimary: e.targetPrimary,
        equipment: e.equipment,
        gifUrl: Value(e.gifUrl),
      );
}
```

- [ ] **Step 4: Run tests — expect green**

```bash
flutter test test/data/seed/seed_service_test.dart
```

Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/data/seed/seed_service.dart test/data/seed/seed_service_test.dart
git commit -m "feat: SeedService — chunked batch insert with progress callback"
```

---

## Task 11: SeedState + SeedNotifier (TDD)

**Files:**
- Create: `lib/data/seed/seed_state.dart`
- Create: `lib/data/seed/seed_notifier.dart`
- Create: `test/data/seed/seed_notifier_test.dart`

- [ ] **Step 1: Write SeedState**

```dart
// lib/data/seed/seed_state.dart
import 'package:flutter/foundation.dart';

@immutable
class SeedState {
  const SeedState({required this.done, required this.total});

  final int done;
  final int total;

  bool get isDone => done >= total;

  @override
  bool operator ==(Object other) =>
      other is SeedState && other.done == done && other.total == total;

  @override
  int get hashCode => Object.hash(done, total);
}
```

- [ ] **Step 2: Write the failing tests**

```dart
// test/data/seed/seed_notifier_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:costrutrain/data/local/app_database.dart';
import 'package:costrutrain/data/local/shared_prefs_provider.dart';
import 'package:costrutrain/data/seed/seed_notifier.dart';
import 'package:costrutrain/data/seed/seed_service.dart';
import 'package:costrutrain/data/seed/seed_state.dart';

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
    db = AppDatabase.forTesting();
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
```

- [ ] **Step 3: Run to confirm failure**

```bash
flutter test test/data/seed/seed_notifier_test.dart
```

Expected: compile error.

- [ ] **Step 4: Implement SeedNotifier**

```dart
// lib/data/seed/seed_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/shared_prefs_provider.dart';
import 'seed_service.dart';
import 'seed_state.dart';

part 'seed_notifier.g.dart';

// Allows tests to inject a SeedService with in-memory JSON.
@Riverpod(keepAlive: true)
SeedService seedService(SeedServiceRef ref) => const SeedService();

@riverpod
class SeedNotifier extends _$SeedNotifier {
  static const _seededKey = 'seeded';

  @override
  Future<SeedState> build() async {
    final prefs = ref.read(sharedPrefsProvider);

    if (prefs.getBool(_seededKey) ?? false) {
      return const SeedState(done: 1, total: 1);
    }

    final db = ref.read(appDatabaseProvider);
    final service = ref.read(seedServiceProvider);

    await service.run(
      db: db,
      onProgress: (done, total) {
        state = AsyncData(SeedState(done: done, total: total));
      },
    );

    await prefs.setBool(_seededKey, true);
    return const SeedState(done: 1, total: 1);
  }
}
```

Add the `OverridableSeedService` helper used in tests to `seed_service.dart`:

```dart
// Append to lib/data/seed/seed_service.dart
class OverridableSeedService extends SeedService {
  const OverridableSeedService({required this.json});
  final String json;

  @override
  Future<void> run({
    required AppDatabase db,
    String? assetPath,
    int chunkSize = 100,
    void Function(int done, int total)? onProgress,
  }) =>
      runWithJson(db: db, json: json, chunkSize: chunkSize, onProgress: onProgress);
}
```

- [ ] **Step 5: Run code generation**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 6: Run tests — expect green**

```bash
flutter test test/data/seed/seed_notifier_test.dart
```

Expected: `All tests passed!`

- [ ] **Step 7: Commit**

```bash
git add lib/data/seed/ test/data/seed/seed_notifier_test.dart
git commit -m "feat: SeedState + SeedNotifier — async seed flow with SharedPreferences flag"
```

---

## Task 12: Splash screen + GoRouter redirect

**Files:**
- Modify: `lib/features/library/views/seed_splash_screen.dart` (replace placeholder)
- Create: `test/features/library/views/seed_splash_screen_test.dart`

- [ ] **Step 1: Write the failing widget tests**

```dart
// test/features/library/views/seed_splash_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:costrutrain/data/local/app_database.dart';
import 'package:costrutrain/data/local/shared_prefs_provider.dart';
import 'package:costrutrain/data/seed/seed_notifier.dart';
import 'package:costrutrain/data/seed/seed_state.dart';
import 'package:costrutrain/features/library/views/seed_splash_screen.dart';

Widget _wrap(Widget child, List<Override> overrides) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(home: child),
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows indeterminate bar on AsyncLoading', (tester) async {
    await tester.pumpWidget(_wrap(
      const SeedSplashScreen(),
      [
        seedNotifierProvider.overrideWith(() => _LoadingNotifier()),
      ],
    ));
    await tester.pump();
    final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator));
    expect(bar.value, isNull); // indeterminate
  });

  testWidgets('shows determinate bar with value on progress', (tester) async {
    await tester.pumpWidget(_wrap(
      const SeedSplashScreen(),
      [
        seedNotifierProvider.overrideWith(() => _ProgressNotifier()),
      ],
    ));
    await tester.pump();
    final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator));
    expect(bar.value, closeTo(0.5, 0.01));
  });

  testWidgets('shows retry button on AsyncError', (tester) async {
    await tester.pumpWidget(_wrap(
      const SeedSplashScreen(),
      [
        seedNotifierProvider.overrideWith(() => _ErrorNotifier()),
      ],
    ));
    await tester.pump();
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}

class _LoadingNotifier extends _$SeedNotifier {
  @override
  Future<SeedState> build() => Future.delayed(const Duration(hours: 1), () => const SeedState(done: 0, total: 1));
}

class _ProgressNotifier extends _$SeedNotifier {
  @override
  Future<SeedState> build() async => const SeedState(done: 1, total: 2);
}

class _ErrorNotifier extends _$SeedNotifier {
  @override
  Future<SeedState> build() => Future.error('seed failed');
}
```

- [ ] **Step 2: Run to confirm failure**

```bash
flutter test test/features/library/views/seed_splash_screen_test.dart
```

Expected: compile error or state mismatch failures.

- [ ] **Step 3: Replace seed_splash_screen.dart placeholder**

```dart
// lib/features/library/views/seed_splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/extensions.dart';
import '../../../data/seed/seed_notifier.dart';
import '../../../data/seed/seed_state.dart';

class SeedSplashScreen extends ConsumerWidget {
  const SeedSplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<SeedState>>(seedNotifierProvider, (_, next) {
      if (next case AsyncData(value: SeedState(isDone: true))) {
        context.go('/library');
      }
    });

    final asyncState = ref.watch(seedNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'CostruTrain',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
              ),
              const Spacer(),
              switch (asyncState) {
                AsyncLoading() => Column(
                    children: [
                      const LinearProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(context.l10n.seedingProgress),
                    ],
                  ),
                AsyncData(:final value) when !value.isDone => Column(
                    children: [
                      LinearProgressIndicator(
                        value: value.total > 0 ? value.done / value.total : null,
                      ),
                      const SizedBox(height: 12),
                      Text(context.l10n.seedingProgress),
                    ],
                  ),
                AsyncData() => const SizedBox.shrink(),
                AsyncError() => Column(
                    children: [
                      Text(context.l10n.seedError),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(seedNotifierProvider),
                        child: Text(context.l10n.seedRetry),
                      ),
                    ],
                  ),
                _ => const SizedBox.shrink(),
              },
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect green**

```bash
flutter test test/features/library/views/seed_splash_screen_test.dart
```

Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/features/library/views/seed_splash_screen.dart \
        test/features/library/views/seed_splash_screen_test.dart
git commit -m "feat: SeedSplashScreen — 4-state branded splash with progress and retry"
```

---

## Task 13: Exercise list screen

**Files:**
- Create: `lib/features/library/providers/exercises_provider.dart`
- Modify: `lib/features/library/views/exercise_list_screen.dart` (replace placeholder)
- Create: `test/features/library/views/exercise_list_screen_test.dart`

- [ ] **Step 1: Write exercisesProvider**

```dart
// lib/features/library/providers/exercises_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/exercise.dart';
import '../../../data/repositories/exercise_repository.dart';

part 'exercises_provider.g.dart';

@riverpod
Future<List<Exercise>> exercises(ExercisesRef ref) =>
    ref.watch(exerciseRepositoryProvider).getAll();
```

Run code gen: `dart run build_runner build --delete-conflicting-outputs`

- [ ] **Step 2: Write the failing widget test**

```dart
// test/features/library/views/exercise_list_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:costrutrain/core/models/exercise.dart';
import 'package:costrutrain/features/library/providers/exercises_provider.dart';
import 'package:costrutrain/features/library/views/exercise_list_screen.dart';

final _fakeExercises = [
  const Exercise(id: '1', source: 'exercisedb', name: 'Push-up', bodyPart: 'chest', targetPrimary: 'pectorals', equipment: 'body weight'),
  const Exercise(id: '2', source: 'exercisedb', name: 'Squat', bodyPart: 'upper legs', targetPrimary: 'quads', equipment: 'body weight'),
];

void main() {
  testWidgets('renders exercise names and bodyPart chips', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        exercisesProvider.overrideWith((ref) async => _fakeExercises),
      ],
      child: const MaterialApp(home: ExerciseListScreen()),
    ));
    await tester.pump();
    expect(find.text('Push-up'), findsOneWidget);
    expect(find.text('Squat'), findsOneWidget);
    expect(find.text('chest'), findsOneWidget);
    expect(find.text('upper legs'), findsOneWidget);
  });

  testWidgets('shows empty state when list is empty', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        exercisesProvider.overrideWith((ref) async => []),
      ],
      child: const MaterialApp(home: ExerciseListScreen()),
    ));
    await tester.pump();
    expect(find.byType(ListView), findsNothing);
  });
}
```

- [ ] **Step 3: Run to confirm failure**

```bash
flutter test test/features/library/views/exercise_list_screen_test.dart
```

Expected: compile error or widget not found.

- [ ] **Step 4: Replace exercise_list_screen.dart placeholder**

```dart
// lib/features/library/views/exercise_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../providers/exercises_provider.dart';

class ExerciseListScreen extends ConsumerWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncExercises = ref.watch(exercisesProvider);

    return Scaffold(
      body: switch (asyncExercises) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        AsyncData(:final value) when value.isEmpty => Center(
            child: Text(context.l10n.exercisesEmpty),
          ),
        AsyncData(:final value) => ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, i) {
              final e = value[i];
              return ListTile(
                title: Text(e.name),
                trailing: Chip(label: Text(e.bodyPart)),
              );
            },
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
```

- [ ] **Step 5: Run tests — expect green**

```bash
flutter test test/features/library/views/exercise_list_screen_test.dart
```

Expected: `All tests passed!`

- [ ] **Step 6: Run full test suite**

```bash
flutter test
```

Expected: all tests pass.

- [ ] **Step 7: Commit**

```bash
git add lib/features/library/ test/features/library/
git commit -m "feat: ExerciseListScreen — name + bodyPart chip, empty and error states"
```

---

## Task 14: flutter_native_splash + final checkpoint

**Files:**
- Create: `flutter_native_splash.yaml`

- [ ] **Step 1: Write flutter_native_splash.yaml**

```yaml
flutter_native_splash:
  color: "#0F0F0F"
  color_dark: "#0F0F0F"
  image: assets/splash_logo.png  # replace with actual logo asset if available
  android_12:
    color: "#0F0F0F"
    image: assets/splash_logo.png
  web: false
```

If you don't have a logo asset yet, omit the `image` lines and use color-only:

```yaml
flutter_native_splash:
  color: "#0F0F0F"
  color_dark: "#0F0F0F"
  android_12:
    color: "#0F0F0F"
  web: false
```

- [ ] **Step 2: Generate native splash**

```bash
dart run flutter_native_splash:create
```

Expected: splash files generated in `android/`, `ios/`, `macos/`.

- [ ] **Step 3: Run flutter analyze**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 4: Run full test suite**

```bash
flutter test
```

Expected: all tests pass.

- [ ] **Step 5: Run on all targets**

```bash
flutter run -d chrome
flutter run -d macos
flutter run -d android
```

**Verify the milestone checklist:**
- [ ] App launches with native splash
- [ ] First launch: shows branded splash screen with progress bar while seeding
- [ ] After seeding: transitions to Library tab automatically
- [ ] Library tab shows ~1300 exercises with name and bodyPart chip
- [ ] Bottom nav switches between Library / Compose / History / Settings
- [ ] Subsequent launches skip splash and go straight to Library
- [ ] `flutter run` succeeds on Android emulator, Web, and macOS desktop

- [ ] **Step 6: Final commit**

```bash
git add flutter_native_splash.yaml android/ ios/ macos/
git commit -m "feat: flutter_native_splash — dark bg native splash"
git commit -m "chore: Phase 0 milestone complete — runnable skeleton with seeded exercise list"
```

---

## Self-Review Notes

**Spec coverage check:**

| Spec requirement | Covered by |
|---|---|
| Shell: folder structure | Task 1 |
| Shell: Riverpod + Drift + dependencies | Task 1 |
| Shell: dark theme | Task 4 |
| Shell: go_router + ShellRoute + bottom nav | Task 7 |
| Shell: i18n from day 1, context.l10n, app_de.arb format | Task 3 |
| Shell: flutter_native_splash | Task 14 |
| Routing: goRouterProvider, ShellRoute, redirect guard | Task 7 |
| Routing: SharedPreferences pre-loaded in main.dart | Task 7 |
| Drift schema: Exercises table, schema v1 | Task 5 |
| ExerciseRepository: interface + Phase 0 impl | Task 6 |
| Seed spike: standalone measurement | Task 9 |
| SeedService: chunked inserts, onProgress | Task 10 |
| SeedState: computed isDone, computed total | Task 11 |
| SeedNotifier: AsyncNotifier, SharedPreferences flag | Task 11 |
| Splash: 4 states (Loading, Progress, Done, Error) | Task 12 |
| Exercise list: ListView.builder, name + bodyPart chip | Task 13 |
| Milestone: flutter run on Android + Web + macOS | Task 14 |
