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
- **Local DB:** Drift (SQLite ORM for Dart) — workouts, exercises, sessions
- **Media cache:** flutter_cache_manager — GIFs cached locally per exercise
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
├── PROJECT_SPEC.md
├── ARCHITECTURE.md
├── ROADMAP.md
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── app.dart                 ← MaterialApp, routing, theme
│   ├── core/
│   │   ├── models/              ← Exercise, Workout, WorkoutStep, PlayerState
│   │   ├── player/              ← State machine (pure Dart, no Flutter)
│   │   └── utils/
│   ├── data/
│   │   ├── local/               ← Drift DB, DAOs
│   │   ├── remote/              ← API client (dio), exercise source adapters
│   │   ├── repositories/        ← ExerciseRepo, WorkoutRepo, SessionRepo
│   │   └── seed/                ← bundled exercises.json (Body Part Collection)
│   ├── features/
│   │   ├── library/             ← Exercise browser (filterable, searchable)
│   │   ├── composer/            ← Workout builder (timeline editor)
│   │   ├── player/              ← Full-screen workout player
│   │   ├── history/             ← Completed sessions log
│   │   └── settings/            ← Preferences, sync, about
│   └── shared/
│       ├── widgets/             ← Reusable components
│       ├── theme/               ← Colors, typography, spacing
│       └── l10n/                ← Localization (en, de, it start)
├── test/
│   ├── core/                    ← Unit tests for state machine, models
│   └── features/                ← Widget tests
├── backend/                     ← FastAPI (Phase 2)
│   ├── main.py
│   ├── models/
│   ├── routers/
│   └── etl/                     ← Exercise dataset ingestion scripts
└── docker/
    ├── docker-compose.yml
    └── traefik/
```

## What NOT to do
- Do NOT use `setState` in complex screens — use Riverpod providers
- Do NOT put business logic in widgets
- Do NOT use `print()` — use `logger` package
- Do NOT hardcode colors/sizes — always use theme tokens
- Do NOT make network calls in build methods
- Do NOT skip error handling on async operations

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
