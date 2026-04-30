# Memory

> Chronological action log. Hooks and AI append to this file automatically.
> Old sessions are consolidated by the daemon weekly.

## Session: 2026-04-30

| Time | Action | File(s) | Outcome | ~Tokens |
|------|--------|---------|---------|--------|
| 09:00 | Task 1 — flutter create + scaffold | pubspec.yaml, l10n.yaml, analysis_options.yaml, assets/seed/exercises.json, pubspec.lock | committed feat/phase-0-foundation | ~2800 |
| 09:05 | intl version fix: ^0.19.0→^0.20.0 (pinned by flutter_localizations 0.20.2) | pubspec.yaml | resolved | ~200 |
| 09:06 | custom_lint version fix: ^0.6.4→^0.7.6 (conflict with riverpod_lint analyzer) | pubspec.yaml | resolved, 118 deps installed | ~200 |
| 09:10 | Fix 1: replaced generated main.dart with minimal placeholder (dot-shorthand errors) | lib/main.dart | flutter analyze: 0 issues | ~150 |
| 09:10 | Fix 2: cerebrum.md — moved Do-Not-Repeat (additional) entries into main section; added l10n Decision Log entry | .wolf/cerebrum.md | updated | ~100 |
| 09:15 | Task 3 — i18n infrastructure: fixed import path (custom output-dir), removed unnecessary non-null assertion | lib/core/utils/extensions.dart, lib/l10n/*, lib/generated/l10n/* | committed, flutter analyze clean | ~600 |
| 10:40 | Task 4 — Theme + ScaffoldWithNav: app_theme.dart (dark theme tokens), scaffold_with_nav.dart (bottom nav routing) | lib/shared/theme/app_theme.dart, lib/shared/widgets/scaffold_with_nav.dart | flutter analyze: 0 issues, committed | ~500 |
| 10:48 | Task 5 — Drift AppDatabase schema v1 + SharedPreferences provider; build_runner generated .g.dart files; flutter analyze: 0 issues | lib/data/local/app_database.dart, app_database.g.dart, shared_prefs_provider.dart, shared_prefs_provider.g.dart | committed | ~800 |
| 11:10 | Task 6 — ExerciseRepository TDD: interface + BundledJsonExerciseRepository; fixed Drift Exercise vs model Exercise name conflict using model alias; 4/4 tests pass; analyze clean | lib/data/repositories/exercise_repository.dart, bundled_json_exercise_repository.dart, bundled_json_exercise_repository.g.dart, test/data/repositories/bundled_json_exercise_repository_test.dart | committed | ~900 |

## Session: 2026-04-29 21:03

| Time | Action | File(s) | Outcome | ~Tokens |
|------|--------|---------|---------|--------|
| 22:07 | Created docs/superpowers/specs/2026-04-29-phase0-foundation-design.md | — | ~2353 |
| 22:07 | Edited docs/superpowers/specs/2026-04-29-phase0-foundation-design.md | 5→6 lines | ~112 |
| 22:08 | Session end: 2 writes across 1 files (2026-04-29-phase0-foundation-design.md) | 3 reads | ~6501 tok |
| 22:12 | Edited docs/superpowers/specs/2026-04-29-phase0-foundation-design.md | 1→2 lines | ~37 |
| 22:12 | Edited CLAUDE.md | modified sync() | ~267 |
| 22:12 | Edited CLAUDE.md | expanded (+9 lines) | ~598 |
| 22:13 | Edited CLAUDE.md | expanded (+23 lines) | ~537 |
| 22:13 | Edited ROADMAP.md | expanded (+25 lines) | ~745 |
| 22:15 | Session end: 7 writes across 3 files (2026-04-29-phase0-foundation-design.md, CLAUDE.md, ROADMAP.md) | 4 reads | ~10814 tok |
| 22:25 | Created docs/superpowers/plans/2026-04-29-phase0-foundation.md | — | ~14507 |
| 22:30 | Brainstorming session complete — Phase 0 design approved, plan written (14 tasks) | spec + plan + CLAUDE.md + ROADMAP.md | ~32k tok |
| 22:27 | Session end: 8 writes across 4 files (2026-04-29-phase0-foundation-design.md, CLAUDE.md, ROADMAP.md, 2026-04-29-phase0-foundation.md) | 4 reads | ~26399 tok |
| 22:46 | Edited docs/superpowers/plans/2026-04-29-phase0-foundation.md | 12→7 lines | ~44 |
| 22:52 | Session end: 9 writes across 4 files (2026-04-29-phase0-foundation-design.md, CLAUDE.md, ROADMAP.md, 2026-04-29-phase0-foundation.md) | 4 reads | ~26446 tok |
| 23:04 | Created ../../../../home/dave/.claude/projects/-mnt-d-Coding-CostruTrain/memory/MEMORY.md | — | ~54 |
| 23:05 | Created ../../../../home/dave/.claude/projects/-mnt-d-Coding-CostruTrain/memory/user_profile.md | — | ~252 |
| 23:05 | Created ../../../../home/dave/.claude/projects/-mnt-d-Coding-CostruTrain/memory/project_phase0_design.md | — | ~406 |
| 22:35 | Session wrap-up: saved user + project memories, fixed intl_utils bug in plan | memory/ + cerebrum.md | ~1k tok |
| 23:05 | Session end: 12 writes across 7 files (2026-04-29-phase0-foundation-design.md, CLAUDE.md, ROADMAP.md, 2026-04-29-phase0-foundation.md, MEMORY.md) | 4 reads | ~27209 tok |
