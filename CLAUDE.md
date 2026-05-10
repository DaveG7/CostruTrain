# OpenWolf

@.wolf/OPENWOLF.md

This project uses OpenWolf for context management. Read and follow .wolf/OPENWOLF.md every session. Check .wolf/cerebrum.md before generating code. Check .wolf/anatomy.md before reading files.

# CLAUDE.md — CostruTrain: Training Composer App

## Project Identity
- **Name:** CostruTrain (working title — open to change)
- **Tagline:** Build your training. Own your data.
- **Positioning:** Privacy-first, open-source workout composer for people who actually program their own training (CrossFit, strength, HIIT, home gym).
- **Primary user:** Dave — pharmacist, data engineer, CrossFit/cycling athlete, father of two. Builds this for himself first, open-sources it second.
- **License:** AGPL-3.0 (strongest open-source copyleft; protects against closed forks monetizing without giving back)

## Core Concept
A training composer + player. Think "timeline script editor for workouts":
- LEFT: Exercise library (filterable, searchable, GIF/video preview)
- CENTER: Workout composer — ordered steps (Exercise, Rest, Countdown, Circuit loop)
- RIGHT: Workout metadata (name, tags, rounds, global defaults)
- PLAYER: Full-screen player with timer state machine, GIF display, audio cues, next-up preview

This is NOT another tracking app. It is a COMPOSER first, player second, tracker third.

## Tech Stack (LOCKED — do not suggest alternatives without strong justification)
- **Frontend/Mobile/Desktop:** Flutter 3.x (Dart)
- **State management:** Riverpod (hooks_riverpod + riverpod_annotation)
- **Routing:** go_router — declarative, ShellRoute for persistent bottom nav
- **Local DB:** Drift (SQLite ORM for Dart) — workouts, exercises, sessions
- **Preferences:** shared_preferences — seed completion flag, user settings
- **Media cache:** flutter_cache_manager — GIFs cached locally per exercise
- **i18n:** flutter_localizations + intl — from Phase 0, all strings via AppLocalizations
- **Splash:** flutter_native_splash — native splash on launch
- **Cloud sync (optional/later):** Supabase (Postgres + Auth + Storage)
- **Backend API (Phase 2+):** FastAPI (Python 3.12) — exercise DB, user workouts, sharing
- **Containerization:** Docker Compose, behind Traefik reverse proxy
- **CI/CD:** GitHub Actions
- **Hosting infra:** Hetzner VPS (public) + TrueNAS SCALE homelab (dev/staging)

## Architecture Principles
1. **Offline-first, always.** App works 100% without network. Cloud sync is additive, never required.
2. **Data ownership.** User data never leaves the device unless explicitly opted in.
3. **Swappable exercise sources.** Exercise DB is behind an abstraction layer — can be local JSON, remote API, or wger self-hosted.
4. **Separation of concerns:**
   - `core/` — pure Dart, zero Flutter dependencies (models, state machine, serialization)
   - `data/` — repositories, local DB (Drift), remote API client
   - `features/` — Flutter UI per feature (composer, player, library, settings)
   - `shared/` — reusable widgets, theme, utils
5. **The player is a deterministic state machine.** No ambiguity in timing logic.

## Core Data Models

### Exercise
```dart
class Exercise {
  final String id;           // internal UUID
  final String? externalId;  // from source dataset
  final String source;       // "exercisedb" | "wger" | "custom"
  final String name;
  final BodyPart bodyPart;
  final MuscleGroup targetPrimary;
  final List<MuscleGroup> targetSecondary;
  final Equipment equipment;
  final Difficulty? difficulty;
  final String? gifUrl;      // original from dataset
  final String? gifCached;   // local cache path
}
```

### WorkoutStep (union type)
```dart
sealed class WorkoutStep {
  final String id;
  final int orderIndex;
}
class ExerciseStep extends WorkoutStep {
  final String exerciseId;
  final StepMode mode;       // REPS | TIMED | AMRAP
  final int? reps;
  final int? workSeconds;
  final int restSeconds;
  final String? tempo;       // e.g. "3-1-2"
}
class RestStep extends WorkoutStep { final int durationSeconds; }
class CircuitBlock extends WorkoutStep {
  final int rounds;
  final List<WorkoutStep> steps; // nested
}
class CountdownStep extends WorkoutStep { final int durationSeconds; }
```

### Workout
```dart
class Workout {
  final String id;
  final String name;
  final String? description;
  final List<String> tags;
  final int? globalRestSeconds;
  final int? warmupSeconds;
  final int? cooldownSeconds;
  final List<WorkoutStep> steps;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

## Player State Machine
States: `Idle → Warmup → ExerciseCountdown(3s) → Working → Resting → CircuitRest → Finished`
- State transitions are pure functions: `(PlayerState, PlayerEvent) → PlayerState`
- Timer lives in a single `Ticker` provider — never spawn multiple timers
- Audio cues fire at: start, last 3 seconds of any phase, transition
- UI updates from state only — no imperative calls to widgets

## Naming Conventions
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Providers: `camelCaseProvider` (Riverpod)
- DB tables: `snake_case` (Drift)
- Constants: `kCamelCase`
- No `get` prefix on getters
- Prefer `sealed class` over enums for union types

## Project Structure
```
CostruTrain/
├── CLAUDE.md                    ← YOU ARE HERE
├── ARCHITECTURE.md
├── ROADMAP.md
├── DESIGN_BRIEF.md              ← Visual language, color tokens, typography
├── design_handoff_v0.4/         ← Screen mockups (JSX) — source of truth for UI layout
├── l10n.yaml                    ← flutter gen-l10n config
├── pubspec.yaml
├── assets/
│   └── seed/
│       └── exercises.json       ← Body Part Collection (~1300 exercises)
├── lib/
│   ├── main.dart                ← ProviderScope, pre-load SharedPreferences, runApp
│   ├── app.dart                 ← MaterialApp.router, GoRouter provider, l10n delegates
│   ├── l10n/
│   │   ├── app_en.arb           ← template (all strings)
│   │   └── app_de.arb           ← {"@@locale": "de"} only — missing keys fall back to EN
│   ├── core/
│   │   ├── models/              ← Exercise, Workout, WorkoutStep, PlayerState
│   │   ├── player/              ← State machine (pure Dart, no Flutter)
│   │   └── utils/
│   │       └── extensions.dart  ← BuildContext.l10n extension
│   ├── data/
│   │   ├── local/               ← Drift AppDatabase, DAOs
│   │   ├── remote/              ← API client (dio), exercise source adapters (Phase 2+)
│   │   ├── repositories/        ← ExerciseRepository interface + implementations
│   │   └── seed/
│   │       ├── seed_service.dart    ← chunked batch insert, onProgress callback
│   │       └── seed_notifier.dart   ← AsyncNotifier<SeedState> — app startup concern
│   ├── features/
│   │   ├── library/             ← Exercise browser (filterable, searchable)
│   │   ├── composer/            ← Workout builder (timeline editor)
│   │   ├── player/              ← Full-screen workout player
│   │   ├── history/             ← Completed sessions log
│   │   └── settings/            ← Preferences, sync, about
│   └── shared/
│       ├── widgets/             ← Reusable components (ScaffoldWithNav, etc.)
│       ├── theme/               ← Colors, typography, spacing
│       └── utils/               ← Shared utilities
├── test/
│   ├── core/                    ← Unit tests for state machine, models, seed
│   └── features/                ← Widget tests
├── backend/                     ← FastAPI (Phase 2+)
│   ├── main.py
│   ├── models/
│   ├── routers/
│   └── etl/                     ← Exercise dataset ingestion scripts
└── docker/
    ├── docker-compose.yml
    └── traefik/
```

## i18n Conventions
- All UI strings go through `AppLocalizations` from Phase 0 — no hardcoded strings in widgets
- Access via `context.l10n.someKey` (BuildContext extension in `core/utils/extensions.dart`) — never `AppLocalizations.of(context)!` directly
- `app_de.arb` contains only `{"@@locale": "de"}` — no empty string values (empty renders blank, not EN fallback)
- No language switcher UI until Phase 4

## Routing Conventions
- `GoRouter` instance lives in a Riverpod provider (`goRouterProvider`) — never a global
- `ShellRoute` wraps all tab routes to keep `ScaffoldWithNav` alive across navigation
- Redirect guard: return `null` for all non-redirect cases — never `state.matchedLocation` fallthrough
- Navigation side-effects (e.g., after seed completes) fire in `ref.listen`, never inside `build()`

## Seeding Conventions
- `SeedNotifier` lives in `data/seed/` — seeding is an **app startup** concern, not a library feature
- Idempotency uses the SharedPreferences `seeded` flag only — never row count (crash mid-seed leaves rows > 0)
- Set the `seeded` flag **only after** `db.batch()` completes successfully
- Chunk inserts: 100 rows/batch, call `onProgress` after each chunk — never one giant batch (no real progress)
- `SeedState.total` is computed as `(exercises.length / chunkSize).ceil()` — never hardcoded
- `SeedState.isDone` is a computed getter (`done >= total`) — never a stored field

## Design Contract (MANDATORY)
Before implementing ANY screen, widget, or visual component:
1. Read `DESIGN_BRIEF.md` — color tokens, typography, mood (once per session, not per widget)
2. List `design_handoff_v0.4/` — check if a mockup exists for this screen
3. If mockup exists → read it first, implement it faithfully, do not invent layout
4. If no mockup exists → flag it before proceeding, do not invent layout without confirmation
5. Color tokens in `DESIGN_BRIEF.md` override any defaults — never hardcode hex values
6. Dark theme is the primary theme — build dark-first, light theme is Phase 4+

## What NOT to do
- Do NOT use `setState` in complex screens — use Riverpod providers
- Do NOT put business logic in widgets
- Do NOT use `print()` — use `logger` package
- Do NOT hardcode colors/sizes — always use theme tokens
- Do NOT make network calls in build methods
- Do NOT skip error handling on async operations
- Do NOT use `AppLocalizations.of(context)!` directly — use `context.l10n`
- Do NOT read SharedPreferences cold inside GoRouter redirect — pre-load in `main()` and inject via `ProviderScope` override
- Do NOT put seed/startup logic under `features/` — it belongs in `data/seed/`
- Do NOT implement any screen without first checking `design_handoff_v0.4/` for an existing mockup

## Exercise Data Source
- **Seed (bundled, Phase 1):** Body Part Exercise Collection JSON (~1300 exercises, gifUrl per entry)
- **Remote (Phase 2):** ExerciseDB API or self-hosted wger REST API
- ETL script: `backend/etl/ingest_exercises.py` — normalizes CSV → internal schema → Postgres
- GIFs: downloaded on first use, cached locally via flutter_cache_manager

## Monetization / Distribution
- **GitHub:** Public repo, AGPL-3.0
- **App Stores:** Free, no account required for core functionality
- **Cloud sync (optional):** Future Supabase integration, self-hostable
- **Open-core:** Cloud-only features (sync, sharing, AI suggestions) are closed-source additions
- **No ads. Ever.**

## Claude Code Session Rules
- Always run `flutter analyze` before considering a task complete
- Always run `flutter test` for any modified core logic
- Commit messages: `feat:`, `fix:`, `refactor:`, `test:`, `docs:` prefixes
- When uncertain about a model change, ASK before implementing — model changes cascade
- Check `ROADMAP.md` before starting any task to confirm phase alignment
- Mark the current phase complete in `ROADMAP.md` before the final commit of any phase

## Versioning

**Convention:** `MAJOR.MINOR.PATCH[-channel.N]+BUILD`

| Component | Rule | Example |
|-----------|------|---------|
| `MAJOR` | Breaking DB migration or full redesign | `2.0.0` |
| `MINOR` | New visible feature/screen/flow | `1.1.0` |
| `PATCH` | Bug fix, polish, copy change | `1.1.1` |
| `-channel.N` | Pre-release stage (omit for production) | `-beta.1`, `-rc.1` |
| `+BUILD` | Monotonically increasing, never reset | `+42` |

**Channel stages:**
```
1.1.0-alpha.1+42   → internal / dev only
1.1.0-beta.1+43   → Firebase App Distribution / sideload APK
1.1.0-rc.1+44     → final QA
1.1.0+45          → production (Play Store, GitHub Release, GitHub Pages)
```

**Git tag convention:**
```bash
git tag v1.1.0 -m "CostruTrain 1.1.0 — <one-liner changelog>"
git push origin --tags
```

**Build number strategy:** Sequential, tied to `GITHUB_RUN_NUMBER` in CI. Never reset. Never timestamp-based.
