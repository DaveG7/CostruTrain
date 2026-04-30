# Cerebrum

> OpenWolf's learning memory. Updated automatically as the AI learns from interactions.
> Do not edit manually unless correcting an error.
> Last updated: 2026-04-29

## User Preferences

- Prefers `context.l10n.someKey` via a `BuildContext` extension (`core/utils/extensions.dart`) — never `AppLocalizations.of(context)!` directly in widgets.

## Key Learnings

- **Project:** CostruTrain
- **intl version:** flutter_localizations SDK package pins intl to 0.20.2 in Flutter 3.41.x. Always use `intl: ^0.20.0` not `^0.19.0` in pubspec.yaml.
- **custom_lint version:** `custom_lint ^0.6.4` conflicts with `riverpod_lint ^2.3.13` due to incompatible analyzer/rxdart versions. Use `custom_lint: ^0.7.6` or higher.
- **flutter pub get with l10n:** When `generate: true` is set in pubspec and l10n.yaml exists, pub get attempts to run gen-l10n. It will error if lib/l10n/app_en.arb does not exist — this is expected until ARB files are created in Task 2.
- **FTS5 bound-variable MATCH:** `WHERE exercises_fts MATCH ?` with `Variable.withString(query)` works correctly in Drift's `customSelect`. The `(col = ? OR ? IS NULL)` pattern for optional filters also works — bind NULL via `const Variable<String>(null)` (NOT `Variable<String?>(null)` — the non-nullable form compiles fine with null value).
- **search() routing:** When no query, use Drift type-safe DSL (_filterOnly with Expression<bool> composition); when query present, use customSelect with FTS5 JOIN. This avoids string concatenation for the common filter-only path.

## Do-Not-Repeat

- [2026-04-29] Do NOT use `dart run intl_utils:generate` — `intl_utils` is not in pubspec.yaml. Always use `flutter gen-l10n` to generate localizations.

- [2026-04-29] Do NOT add empty string values to `app_de.arb`. Use only `{"@@locale": "de"}`. Empty string values render as blank in the UI — missing keys fall back to EN automatically.
- [2026-04-29] Do NOT use `AppLocalizations.of(context)!` directly in widgets. Always use `context.l10n` via the BuildContext extension in `core/utils/extensions.dart`.
- [2026-04-29] Do NOT read SharedPreferences cold inside GoRouter redirect — it is synchronous and returns null before the async load completes, causing wrong redirects. Pre-load SharedPreferences before runApp and inject via sharedPrefsProvider override in ProviderScope.
- [2026-04-29] GoRouter redirect guard: always return null for routes that are not the redirect target. Only redirect to /splash if not already on /splash — otherwise redirect loops occur.
- [2026-04-29] Do NOT use row count for seed idempotency — a crash mid-seed leaves rows > 0 and gives a false positive. Use the SharedPreferences 'seeded' flag only. Set it ONLY after db.batch() completes successfully.
- [2026-04-29] Do NOT use a single db.batch() for 1300 rows if you want real progress reporting — it fires once at 100%. Chunk inserts (100 rows/batch) and call onProgress after each chunk.
- [2026-04-29] ExerciseRepository.getAll() is Phase 0 only — Phase 1 replaces it with search({query, bodyPart, equipment}). Design the interface for swap from day 1.
- [2026-04-29] SeedNotifier belongs in data/seed/seed_notifier.dart — seeding is an app startup concern, not a library feature. features/library/ must not own startup logic.
- [2026-04-29] SeedState.total must be computed as (exercises.length / chunkSize).ceil() — never hardcode chunk count. Spike may change chunk size; dataset will grow.
- [2026-04-29] SeedState.isDone must be a computed getter (done >= total), not a stored field — avoids done/total/isDone getting out of sync.
- [2026-04-30] `intl: ^0.19.0` fails resolution with Flutter 3.41.x — use `^0.20.0` or higher. Flutter 3.41 pins intl to 0.20.2 internally.
- [2026-04-30] `custom_lint: ^0.6.4` conflicts with `riverpod_lint: ^2.3.13` — use `^0.7.6` or higher.
- [2026-04-30] Drift generates a data class named `Exercise` (not `ExerciseData`) from an `Exercises` table. This conflicts with `lib/core/models/exercise.dart:Exercise`. Fix: import the model with alias (`import '...exercise.dart' as model;`) and use `model.Exercise` for return types. Unqualified `Exercise` in the same file then refers to the Drift data class. The test file imports only `app_database.dart` (not the model), so no conflict there.
- [2026-04-30] `import 'package:drift/drift.dart'` is NOT needed in BundledJsonExerciseRepository if no Drift-specific DSL (Companion, Drift queries) is used directly — Drift query API is inherited through the AppDatabase import via `app_database.dart`.
- [2026-04-30] Test files that use `Value(...)` from Drift need `import 'package:drift/drift.dart' show Value;` explicitly — unlike lib files that use `part of`, test files don't inherit the import from app_database.dart.

## Decision Log

- [2026-04-29] **Routing:** go_router with a ShellRoute for persistent bottom nav. GoRouter instance lives in a Riverpod provider.
- [2026-04-29] **Exercise seeding:** Async on first launch only. AsyncNotifier tracks progress. SharedPreferences stores completion flag. Branded splash shown during seed. Subsequent launches skip entirely.
- [2026-04-29] **Seed spike:** After shell runs green, do a standalone main.dart spike to measure real insert time on device before wiring seed flow into the app.
- [2026-04-29] **i18n:** flutter_localizations + intl from Phase 0. l10n.yaml at root. app_en.arb is the template; app_de.arb contains only {"@@locale": "de"}.
- [2026-04-30] **l10n generated files:** `lib/generated/l10n/` output from `flutter gen-l10n` is committed to the repo (same convention as Drift/Riverpod `.g.dart` files — no gitignore exclusion needed).
- [2026-04-30] Drift generates the row data class as `Exercise` (singular, no suffix) when the table class is `Exercises`. The plan incorrectly assumed `ExerciseData`. When the domain model is also named `Exercise`, import the model with an alias: `import '...exercise.dart' as model;` and use `model.Exercise` as return types.
- [2026-04-30] `test/widget_test.dart` from `flutter create` references `MyApp` which does not exist. Delete or replace it when Task 7 writes the real `main.dart` and `CostruTrainApp`.
