# Cerebrum

> OpenWolf's learning memory. Updated automatically as the AI learns from interactions.
> Do not edit manually unless correcting an error.
> Last updated: 2026-04-29

## User Preferences

- Prefers `context.l10n.someKey` via a `BuildContext` extension (`core/utils/extensions.dart`) — never `AppLocalizations.of(context)!` directly in widgets.

## Key Learnings

- **Project:** CostruTrain

## Do-Not-Repeat

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

## Decision Log

- [2026-04-29] **Routing:** go_router with a ShellRoute for persistent bottom nav. GoRouter instance lives in a Riverpod provider.
- [2026-04-29] **Exercise seeding:** Async on first launch only. AsyncNotifier tracks progress. SharedPreferences stores completion flag. Branded splash shown during seed. Subsequent launches skip entirely.
- [2026-04-29] **Seed spike:** After shell runs green, do a standalone main.dart spike to measure real insert time on device before wiring seed flow into the app.
- [2026-04-29] **i18n:** flutter_localizations + intl from Phase 0. l10n.yaml at root. app_en.arb is the template; app_de.arb contains only {"@@locale": "de"}.
