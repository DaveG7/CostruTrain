# Phase 0 — Foundation Design

**Project:** CostruTrain
**Date:** 2026-04-29
**Status:** Approved

---

## Overview

Phase 0 delivers a runnable Flutter skeleton: theme, navigation, routing, i18n infrastructure, and a seeded exercise list. The milestone is `flutter run` working on Android emulator, Web, and macOS desktop, with all ~1300 bundled exercises visible in a basic list.

Build order: **Shell-first**, with an early spike to validate seed performance on-device before committing to the full integration.

---

## Section 1 — Project Structure & Shell

```
lib/
├── main.dart                        ← ProviderScope + pre-load SharedPreferences + runApp
├── app.dart                         ← MaterialApp.router + GoRouter + l10n wiring
├── l10n/
│   ├── app_en.arb                   ← template (all UI strings)
│   └── app_de.arb                   ← {"@@locale": "de"} only — missing keys fall back to EN
├── core/
│   ├── models/                      ← Exercise model (Phase 0 only)
│   └── utils/
│       └── extensions.dart          ← BuildContext.l10n extension
├── data/
│   ├── local/                       ← Drift AppDatabase
│   ├── repositories/                ← ExerciseRepository interface + BundledJsonSource impl
│   └── seed/
│       ├── seed_service.dart        ← chunked batch insert + onProgress callback
│       └── seed_notifier.dart       ← AsyncNotifier driving seed flow
├── features/
│   ├── library/
│   │   └── views/
│   │       ├── seed_splash_screen.dart
│   │       └── exercise_list_screen.dart
│   ├── composer/                    ← empty placeholder screen
│   ├── history/                     ← empty placeholder screen
│   └── settings/                    ← empty placeholder screen
└── shared/
    ├── theme/                       ← CostruTrainTheme (dark-first, high-contrast accent)
    └── widgets/
        └── scaffold_with_nav.dart   ← shared BottomNavigationBar wrapper
```

**i18n setup:**
- `l10n.yaml` at project root configures `flutter gen-l10n`
- `MaterialApp.router` receives `localizationsDelegates: AppLocalizations.localizationsDelegates` and `supportedLocales: AppLocalizations.supportedLocales`
- `app_de.arb` contains only `{"@@locale": "de"}` — no empty string values (they render blank, not as fallback)
- All widgets access strings via `context.l10n.someKey` through the `BuildContext` extension — never `AppLocalizations.of(context)!` directly

```dart
// core/utils/extensions.dart
extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

---

## Section 2 — Routing

`GoRouter` lives in a Riverpod provider (`goRouterProvider`) to enable `ref.watch` access to app state.

**Route tree:**
```
/ (root redirect — checks SharedPreferences seeded flag synchronously)
  → /splash    if not seeded
  → /library   if already seeded

ShellRoute  (ScaffoldWithNav — persistent bottom nav)
  ├── /library
  ├── /compose
  ├── /history
  └── /settings
```

**Startup sequence in `main.dart`:**
```dart
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

SharedPreferences is pre-loaded before `runApp` and injected via provider override so the GoRouter redirect can read the `seeded` flag synchronously without null-safety issues.

**Redirect guard:**
```dart
redirect: (context, state) {
  final seeded = ref.read(sharedPrefsProvider).getBool('seeded') ?? false;
  if (!seeded && state.matchedLocation != '/splash') return '/splash';
  return null; // always return null for all other cases — avoids redirect loops
},
```

**No deep-link handling in Phase 0** — that is a Phase 5 concern.

---

## Section 3 — Seed Spike + Drift Schema + ExerciseRepository

### Spike

After the shell runs green, create `main_seed_spike.dart` at the project root. It:
1. Loads `exercises.json` from assets
2. Opens an in-memory Drift DB
3. Inserts all rows in 100-row chunks, printing elapsed time per chunk and total

Run on device. If 13 × 100-row batches complete in <1s, proceed with chunk size 100. Adjust chunk size based on results. Delete `main_seed_spike.dart` after the spike.

### Drift Schema

```dart
// data/local/app_database.dart
@DriftDatabase(tables: [Exercises])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}

class Exercises extends Table {
  TextColumn get id          => text()();
  TextColumn get externalId  => text().nullable()();
  TextColumn get source      => text()();       // "exercisedb" | "custom"
  TextColumn get name        => text()();
  TextColumn get bodyPart    => text()();       // stored as string
  TextColumn get targetPrimary => text()();
  TextColumn get equipment   => text()();
  TextColumn get gifUrl      => text().nullable()();
  // gifCached, difficulty, secondaryMuscles → Phase 1

  @override
  Set<Column> get primaryKey => {id};
}
```

Migration v1 only. FTS deferred to Phase 1.

### ExerciseRepository

```dart
// data/repositories/exercise_repository.dart
abstract interface class ExerciseRepository {
  // Phase 0 only — replaced by search({query, bodyPart, equipment}) in Phase 1
  Future<List<Exercise>> getAll();
  Future<Exercise?> getById(String id);
}
```

Phase 0 implementation: `BundledJsonExerciseRepository` in `data/repositories/bundled_json_exercise_repository.dart`. Reads `assets/seed/exercises.json`, maps to `Exercise` models, persists via `AppDatabase`. The interface is designed for swap — Phase 1 adds `search()` and removes `getAll()` from the interface.

### SeedService

```dart
// data/seed/seed_service.dart
class SeedService {
  Future<void> run({
    required AppDatabase db,
    required String jsonAsset,
    int chunkSize = 100,
    void Function(int done, int total)? onProgress,
  }) async {
    final exercises = await _parseAsset(jsonAsset);
    final total = (exercises.length / chunkSize).ceil();
    for (var i = 0; i < total; i++) {
      final chunk = exercises.skip(i * chunkSize).take(chunkSize).toList();
      await db.batch((b) => b.insertAllOnConflictUpdate(db.exercises, chunk));
      onProgress?.call(i + 1, total);
    }
  }
}
```

---

## Section 4 — Seed Flow Integration + Exercise List Screen

### SeedState

```dart
// data/seed/seed_notifier.dart
class SeedState {
  final int done;
  final int total;

  const SeedState({required this.done, required this.total});

  bool get isDone => done >= total;  // computed — never stored
}
```

`total` is always computed as `(exercises.length / chunkSize).ceil()` — never hardcoded.

### SeedNotifier

`AsyncNotifier<SeedState>` in `data/seed/seed_notifier.dart`.

- `build()` checks the SharedPreferences `seeded` flag via `ref.read(sharedPrefsProvider)`
- If `true` → returns `SeedState(done: 1, total: 1)` immediately (fast path, skips seeding)
- If `false` → calls `SeedService.run(onProgress: ...)`, updating state after each chunk
- On success → writes `seeded = true` to SharedPreferences, emits final done state
- On error → emits `AsyncError` (splash shows retry)

**Idempotency uses the SharedPreferences flag only.** Row count is not checked — a crashed mid-seed leaves rows > 0 and would give a false positive.

### Splash Screen

`features/library/views/seed_splash_screen.dart` — `ConsumerWidget` watching `seedNotifierProvider`:

| State | UI |
|---|---|
| `AsyncLoading` | Branded logo + indeterminate `LinearProgressIndicator` (no value yet) |
| `AsyncData(isDone: false)` | Branded logo + `LinearProgressIndicator(value: done/total)` + `context.l10n.seedingProgress` |
| `AsyncData(isDone: true)` | Triggers `context.go('/library')` via `ref.listen` |
| `AsyncError` | Error message + retry button calling `ref.invalidate(seedNotifierProvider)` |

Navigation fires in `ref.listen`, never inside `build()` — avoids setState-during-build errors.

### Exercise List Screen

`features/library/views/exercise_list_screen.dart` — `ConsumerWidget` backed by a `FutureProvider` calling `repository.getAll()`.

- `ListView.builder`: exercise name (left) + bodyPart chip (right)
- No GIFs, no search, no filter — Phase 1
- Empty state and error state handled

---

## Dependencies

| Package | Purpose |
|---|---|
| `flutter_riverpod` + `riverpod_annotation` | State management |
| `drift` + `drift_flutter` | Local SQLite ORM |
| `shared_preferences` | Seed completion flag |
| `go_router` | Declarative routing |
| `flutter_localizations` + `intl` | i18n |
| `flutter_cache_manager` | GIF caching (wired Phase 1, installed Phase 0) |
| `flutter_native_splash` | Native splash screen on launch |

---

## Milestone

`flutter run` works on Android emulator, Web, and macOS desktop. All ~1300 exercises visible in a scrollable list. Seeding runs once on first launch with a branded progress screen. Subsequent launches go straight to Library.
