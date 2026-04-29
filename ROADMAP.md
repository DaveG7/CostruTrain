# ROADMAP.md — CostruTrain

## Guiding Principle
> Build the smallest thing that is genuinely useful, ship it, get feedback.
> Never be in a state where the app can't be run end-to-end.

---

## Phase 0 — Foundation (Week 1–2)
**Goal:** Runnable skeleton. Nothing more.

### Deliverables
- [ ] `flutter create CostruTrain` with folder structure matching CLAUDE.md
- [ ] Riverpod + Drift + flutter_cache_manager installed and configured
- [ ] Theme file: dark-first, CrossFit-inspired (dark bg, high-contrast accent)
- [ ] Bottom navigation: Library | Compose | History | Settings
- [ ] Bundled `exercises.json` from Body Part Exercise Collection (~1300 entries)
- [ ] `ExerciseRepository` with `BundledJsonSource` — loads exercises from asset JSON
- [ ] Exercise list screen: scrollable, shows name + body part (no GIFs yet)
- [ ] **Milestone:** `flutter run` works on Android emulator, Web, and macOS desktop

### No:
- No player, no composer, no GIFs, no backend, no auth

---

## Phase 1 — Exercise Library (Week 3–4)
**Goal:** Browse and preview exercises beautifully.

### Deliverables
- [ ] Drift DB: `exercises` table, migration v1
- [ ] ETL: on first run, parse bundled JSON → insert into Drift (one-time seed)
- [ ] Exercise card: name, bodyPart chip, equipment chip, GIF (lazy loaded, cached)
- [ ] Filter drawer: bodyPart, equipment, muscle group (multi-select)
- [ ] Search: debounced, queries Drift FTS (full-text search)
- [ ] Exercise detail screen: large GIF, primary/secondary muscles, description
- [ ] GIF loading: shimmer placeholder → cached GIF via flutter_cache_manager
- [ ] **Milestone:** Can browse all 1300 exercises, filter, search, see GIF preview offline

---

## Phase 2 — Workout Composer (Week 5–7)
**Goal:** Build and save a complete workout.

### Deliverables
- [ ] Drift DB: `workouts` + `workout_steps` tables, migration v2
- [ ] `WorkoutRepository` CRUD — create, read, update, delete workouts
- [ ] Composer screen: 3-column layout (desktop) / tab layout (mobile)
- [ ] Step types: ExerciseStep (reps OR timed), RestStep, CircuitBlock, CountdownStep
- [ ] Add step flow: search/filter exercise → configure (mode, reps/seconds, rest) → append
- [ ] Step list: reorder via long-press drag, swipe to delete, tap to edit
- [ ] Workout metadata form: name, tags, global rest, warm-up seconds
- [ ] My Workouts screen: list of saved workouts with summary (steps count, estimated duration)
- [ ] Workout duplication + delete
- [ ] JSON export/import (share a workout as `.CostruTrain.json` file)
- [ ] **Milestone:** Can build a full CrossFit WOD, save it, export it to a friend

---

## Phase 3 — Workout Player (Week 8–10)
**Goal:** The money feature. This is what makes it real.

### Deliverables
- [ ] `PlayerStateMachine` in `lib/core/player/` — pure Dart, fully unit-tested
- [ ] `PlayerNotifier` (AsyncNotifier) — drives state machine with a 100ms ticker
- [ ] Player screen: full-screen, dark, immersive
  - Current exercise name + GIF (large)
  - Timer ring (circular progress, counts down or up)
  - Phase label: WARMUP / GET READY / WORK / REST / DONE
  - Next up preview (bottom strip)
  - Round counter for circuits
  - Pause/Resume button + Skip button
- [ ] Audio cues: countdown beeps (3-2-1), phase-start tone, finish sound
  - Use `audioplayers` package, bundled .mp3 assets
- [ ] Haptic feedback at phase transitions
- [ ] Keep screen awake during player (`wakelock_plus`)
- [ ] Session auto-saved to Drift on completion
- [ ] History screen: list of completed sessions, tap to view detail
- [ ] **Milestone:** Full end-to-end: compose a workout → play it → see it in history

---

## Phase 4 — Polish & Public Alpha (Week 11–13)
**Goal:** Good enough to share with strangers.

### Deliverables
- [ ] Onboarding flow: 3 screens (what it is, create first workout, privacy statement)
- [ ] Settings screen: default rest time, audio on/off, haptics on/off, theme toggle
- [ ] Workout templates: 5–10 pre-built workouts bundled (Tabata 8-round, 21-15-9, EMOM 10min, etc.)
- [ ] App icon + splash screen (designed, not placeholder)
- [ ] Proper responsive layout: phone / tablet / desktop breakpoints
- [ ] Localization scaffolding: English complete, German skeleton
- [ ] Error handling: empty states, failed GIF loads, corrupted DB recovery
- [ ] GitHub repo goes public: README, screenshots, Docker run instructions
- [ ] GitHub Actions: `flutter test` + `flutter analyze` on every PR
- [ ] **Milestone:** Post on r/selfhosted and r/homegym. Get 10 real users.

---

## Phase 5 — Cloud & Open-Core (Month 4–6)
**Goal:** Optional sync, self-hostable backend.

### Deliverables
- [ ] FastAPI backend: `/exercises` (read), `/workouts` (CRUD), `/sessions` (write)
- [ ] ETL scripts: ingest Body Part Exercise CSV + ExerciseDB into Postgres
- [ ] Supabase Auth integration (email/password + Google OAuth)
- [ ] Sync service: background upload of workouts + sessions to Supabase
- [ ] Self-hosted Docker Compose: `docker-compose up` gives you the full backend
- [ ] Cloud exercise DB: exercises served from backend (larger dataset, video support)
- [ ] Workout sharing: generate shareable link → open in app (deep link)
- [ ] Community templates: browse workouts shared by other users
- [ ] App Store + Play Store submissions
- [ ] **Milestone:** 100 GitHub stars. First self-hoster in the wild.

---

## Phase 6 — Open-Core Premium (Month 6+)
**Goal:** Cover hosting costs and learn the full SaaS loop.

### Deliverables (cloud-only, closed-source additions)
- [ ] Progress analytics: volume over time, muscles per week heatmap, PRs tracking
- [ ] AI workout suggestions: based on history, target muscles, available equipment
- [ ] Custom audio cues: upload your own coach voice
- [ ] Multi-device sync priority queue (faster sync for paying users)
- [ ] Pricing: €0 free | €4.99/mo Pro | one-time self-host license

---

## Decision Log

| Decision | Chosen | Rejected | Reason |
|----------|--------|----------|--------|
| Framework | Flutter | React Native, Tauri+React | Single codebase iOS+Android+Desktop+Web, native perf for timer |
| State | Riverpod | BLoC, Provider | Type-safe, testable, no BuildContext leakage |
| Local DB | Drift | Hive, Isar | SQL power + type-safe Dart, migration support |
| Backend | FastAPI | Django/wger, Node | Python ecosystem, fast iteration, matches Dave's stack |
| Auth | Supabase | Firebase, custom JWT | Self-hostable, GDPR-friendly, Dart SDK |
| License | AGPL-3.0 | MIT, Apache | Prevents commercial closed forks |
| Exercise DB | Body Part Collection | Full ExerciseDB paid | Free, offline-bundleable, GIF URLs included |
