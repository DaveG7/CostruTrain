# anatomy.md

> Auto-maintained by OpenWolf. Last scanned: 2026-04-30T10:40:00.000Z
> Files: 28 tracked | Anatomy hits: 0 | Misses: 0

## ../../../../home/dave/.claude/projects/-mnt-d-Coding-CostruTrain/memory/

- `MEMORY.md` — Memory Index (~51 tok)
- `project_phase0_design.md` (~394 tok)
- `user_profile.md` (~249 tok)

## ./

- `ARCHITECTURE.md` — ARCHITECTURE.md — CostruTrain (~1527 tok)
- `CLAUDE.md` — OpenWolf (~2624 tok)
- `DESIGN_BRIEF.md` — DESIGN_BRIEF.md — CostruTrain (~1539 tok)
- `ROADMAP.md` — ROADMAP.md — CostruTrain (~2156 tok)
- `pubspec.yaml` — Flutter project manifest with all Phase 0 dependencies (~40 tok)
- `pubspec.lock` — Resolved dependency lock file, 118 packages (~1178 tok)
- `l10n.yaml` — flutter gen-l10n config: arb-dir lib/l10n, output lib/generated/l10n (~10 tok)
- `analysis_options.yaml` — Lint config with custom_lint plugin, strict error rules (~15 tok)

## lib/

- `main.dart` — Minimal placeholder; real entry point written in Task 7. Passes flutter analyze with 0 issues (~5 tok)

## lib/data/local/

- `app_database.dart` — Drift AppDatabase with Exercises table (id, externalId, source, name, bodyPart, targetPrimary, equipment, gifUrl). Includes AppDatabase.forTesting() constructor and keepAlive appDatabaseProvider (~70 tok)
- `app_database.g.dart` — Generated Drift code: _$AppDatabase mixin, ExercisesTable, ExerciseData, ExercisesCompanion — do not edit (~1500 tok)
- `shared_prefs_provider.dart` — keepAlive sharedPrefsProvider that throws UnimplementedError — must be overridden in main.dart via ProviderScope (~30 tok)
- `shared_prefs_provider.g.dart` — Generated Riverpod provider code for sharedPrefsProvider — do not edit (~60 tok)

## lib/core/utils/

- `extensions.dart` — BuildContext.l10n extension for convenient AppLocalizations access (~8 tok)

## lib/shared/theme/

- `app_theme.dart` — Dark theme tokens: bg (#0F0F0F), surface (#1A1A1A), accent yellow-green (#E8FF00), NavigationBar and Chip theming (~50 tok)

## lib/shared/widgets/

- `scaffold_with_nav.dart` — ScaffoldWithNav stateless widget with persistent bottom NavigationBar; routes selected by location prefix (~35 tok)

## lib/l10n/

- `app_en.arb` — English localization template with nav labels, seeding messages, empty state strings (~250 tok)
- `app_de.arb` — German locale declaration (empty, falls back to EN automatically) (~7 tok)

## lib/generated/l10n/

- `app_localizations.dart` — Generated base class and factory methods (~180 tok)
- `app_localizations_en.dart` — Generated English strings class (~30 tok)
- `app_localizations_de.dart` — Generated German strings class (~30 tok)

## assets/seed/

- `exercises.json` — Placeholder empty array []; real data added in Task 9 (~1 tok)

## .claude/

- `settings.json` (~441 tok)

## .claude/rules/

- `openwolf.md` (~313 tok)

## design_handoff_v0.4/

- `README.md` — Project documentation (~4060 tok)

## design_handoff_v0.4/mockups/

- `app.jsx` — app.jsx — assembles the design canvas (~3009 tok)
- `data.jsx` — data.jsx — sample exercise + workout content for the mockups (~1126 tok)
- `design-canvas.jsx` — DesignCanvas.jsx — Figma-ish design canvas wrapper (~8528 tok)
- `frame.jsx` — frame.jsx — chrome shared by mobile + desktop screens (~1924 tok)
- `index.html` — CostruTrain — Hi-fi Mockups (~628 tok)
- `ios-frame.jsx` — iOS.jsx — Simplified iOS 26 (Liquid Glass) device frame (~4080 tok)
- `placeholders.jsx` — placeholders.jsx — striped SVG placeholders for exercise GIFs (~438 tok)
- `screen-composer.jsx` — screen-composer.jsx — Workout Composer (~3032 tok)
- `screen-history.jsx` — screen-history.jsx — Session History (~2379 tok)
- `screen-library.jsx` — screen-library.jsx — Exercise Library (~2626 tok)
- `screen-myworkouts.jsx` — screen-myworkouts.jsx — My Workouts list (~1292 tok)
- `screen-player.jsx` — screen-player.jsx — Workout Player (5 states) (~4989 tok)
- `theme.jsx` — theme.jsx — CostruTrain shared tokens (~910 tok)
- `tweaks-panel.jsx` — tweaks-panel.jsx (~5078 tok)

## docs/superpowers/plans/

- `2026-04-29-phase0-foundation.md` — Phase 0 — Foundation Implementation Plan (~13580 tok)

## docs/superpowers/specs/

- `2026-04-29-phase0-foundation-design.md` — Phase 0 — Foundation Design (~2247 tok)
