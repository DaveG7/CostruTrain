# ARCHITECTURE.md — CostruTrain

## System Overview

CostruTrain is an offline-first, cross-platform workout composer and player.
The system is split into two independent components that can evolve separately:

1. **Flutter App** — the product users install. Works 100% standalone.
2. **Backend API** — optional cloud layer for sync, sharing, exercise DB updates.

```
┌──────────────────────────────────────────────────────────┐
│                     Flutter App                          │
│                                                          │
│  ┌──────────┐  ┌────────────┐  ┌──────────┐  ┌───────┐ │
│  │ Library  │  │  Composer  │  │  Player  │  │History│ │
│  │ Feature  │  │  Feature   │  │  Feature │  │Feature│ │
│  └────┬─────┘  └─────┬──────┘  └────┬─────┘  └───┬───┘ │
│       │              │              │             │      │
│  ┌────▼──────────────▼──────────────▼─────────────▼───┐ │
│  │              Riverpod Providers Layer               │ │
│  └────────────────────────┬────────────────────────────┘ │
│                           │                              │
│  ┌────────────────────────▼────────────────────────────┐ │
│  │              Repository Layer                       │ │
│  │  ExerciseRepo │ WorkoutRepo │ SessionRepo           │ │
│  └──────┬─────────────────────────────┬────────────────┘ │
│         │                             │                  │
│  ┌──────▼──────┐              ┌───────▼──────┐          │
│  │  Local DB   │              │ Remote Client│          │
│  │  (Drift/    │              │  (Dio + API) │          │
│  │   SQLite)   │              │  OPTIONAL    │          │
│  └─────────────┘              └──────────────┘          │
└──────────────────────────────────────────────────────────┘
                                      │ HTTPS (optional)
                              ┌───────▼────────┐
                              │  FastAPI       │
                              │  Backend       │
                              │  + Postgres    │
                              │  + Supabase    │
                              └────────────────┘
```

## Layer Responsibilities

### Feature Layer (`lib/features/`)
- Flutter widgets only
- Reads from providers via `ref.watch` / `ref.read`
- Never imports from `data/` directly — only via providers
- No business logic

### Provider Layer (Riverpod)
- Bridges features ↔ repositories
- Holds all transient UI state (selected exercise, current filter, etc.)
- Player state machine lives here as an `AsyncNotifier`

### Repository Layer (`lib/data/repositories/`)
- Pure Dart (no Flutter)
- Abstracts local vs remote sources
- Offline-first: local DB is source of truth; remote syncs in background
- Interface-based: `abstract class ExerciseRepository {...}`

### Local DB Layer (`lib/data/local/`)
- Drift (type-safe SQLite ORM)
- Tables: `exercises`, `workouts`, `workout_steps`, `sessions`, `session_entries`
- All writes are atomic transactions
- Migration strategy: Drift schema versions

### Remote Layer (`lib/data/remote/`)
- Dio HTTP client
- Three adapters implementing `ExerciseSource`:
  - `BundledJsonSource` — reads from assets (Phase 1, always available)
  - `ExerciseDbApiSource` — ExerciseDB REST API
  - `WgerApiSource` — self-hosted wger REST API
- Remote calls never block the UI — always background with optimistic local state

## Player Architecture (most critical component)

The player is a **pure state machine** in `lib/core/player/`.
Zero Flutter dependencies in this directory — fully unit-testable.

### States
```dart
sealed class PlayerState {
  const PlayerState();
}
class PlayerIdle extends PlayerState {}
class PlayerWarmup extends PlayerState { final int remaining; }
class PlayerExerciseCountdown extends PlayerState {
  final ExerciseStep step; final int remaining;
}
class PlayerWorking extends PlayerState {
  final ExerciseStep step; final int elapsed; final int? total;
}
class PlayerResting extends PlayerState {
  final int remaining; final WorkoutStep? nextStep;
}
class PlayerCircuitRest extends PlayerState {
  final int remaining; final int currentRound; final int totalRounds;
}
class PlayerFinished extends PlayerState { final SessionResult result; }
```

### Events
```dart
sealed class PlayerEvent {}
class StartWorkout extends PlayerEvent { final Workout workout; }
class Tick extends PlayerEvent {}           // fires every 100ms
class PauseResume extends PlayerEvent {}
class SkipStep extends PlayerEvent {}
class StopWorkout extends PlayerEvent {}
```

### Transition function
```dart
PlayerState reduce(PlayerState state, PlayerEvent event) {
  // Pure function — no side effects
  // Audio cues, haptics triggered by middleware watching state changes
}
```

## Data Flow: Composer → Player

```
User builds Workout (Composer feature)
    │
    ▼
WorkoutRepo.save(workout) → Drift (local)
    │
    ▼
User taps "Start"
    │
    ▼
PlayerNotifier.start(workout)
    │
    ▼
Workout.steps.resolveToEvents() → List<PlayerEvent>
    │
    ▼
Ticker fires Tick every 100ms
    │
    ▼
PlayerState machine transitions
    │
    ▼
Player UI rebuilds from state only (no imperative calls)
    │
    ▼
On Finish: SessionRepo.save(result) → Drift
```

## Offline-First Sync Strategy (Phase 3)

1. All data written locally first (Drift), always
2. `SyncService` runs in background, uploads diff to Supabase
3. Conflicts resolved by `updatedAt` timestamp (last-write-wins for personal use)
4. Sync is invisible to user unless explicitly checked in Settings
5. User can disable sync entirely — app works identically

## Security Considerations
- No PII stored beyond what user explicitly enters
- Supabase RLS (Row Level Security) ensures users only access their own data
- No analytics, no telemetry, no third-party SDKs that phone home
- AGPL license prevents closed commercial forks without disclosure

## Performance Targets
- App cold start: < 1.5s
- Exercise library scroll (1300 items): 60fps (use `ListView.builder`, lazy GIF loading)
- Player state machine tick latency: < 5ms
- GIF first load (cached): < 200ms
- Workout save (local): < 50ms
