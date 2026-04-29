# Design Handoff — CostruTrain v0.4 mockups

> **For Claude Code (Flutter implementation).**
> This bundle is the bridge between the design exploration and Phase 0–3 of `ROADMAP.md`.

---

## 0. About the design files

The files in `mockups/` are **design references created in HTML/JSX** — high-fidelity prototypes showing the intended look, density, and behavior.

They are **not** production code. They are not Flutter, do not match the codebase's widget tree, and use shortcuts (placeholder GIFs, mocked data, no real state machine) that would be wrong to translate literally.

**Your task:** recreate these designs as **Flutter widgets** inside the `lib/` structure already defined in `CLAUDE.md` and `ARCHITECTURE.md`, using the locked stack:

- Flutter 3.x + Dart
- Riverpod (`hooks_riverpod` + `riverpod_annotation`) for state
- Drift (SQLite ORM) for persistence
- `flutter_cache_manager` for GIF caching
- `audioplayers` for player cues, `wakelock_plus` for screen-on during a session

Read `CLAUDE.md` first. Don't deviate from the stack without strong justification.

---

## 1. Fidelity

**High-fidelity.** Colors, type, spacing, radii, layouts, and the Player state visuals are final. Reproduce them pixel-faithfully — but using Flutter idioms (`ThemeExtension`, `LayoutBuilder` for breakpoints, `CustomPainter` for the timer ring), not by porting CSS verbatim.

Where the HTML cheats (e.g. mono-glyph icons like `⌕`, `≡`, `▶`, `››`), substitute proper icons from `Icons` (Material) or `lucide_icons` / `phosphor_flutter` once you've picked one and pinned it.

---

## 2. Design system / tokens

These are the **only** values to use. Hard-code them once into the Flutter `ThemeData` + a `ThemeExtension<CTColors>` and never invent new ones.

### 2.1 Colors (dark theme — only theme for v1)

| Token | Hex | Used for |
|---|---|---|
| `bg`            | `#0F0F0F` | Scaffold background |
| `surface`       | `#1A1A1A` | Cards, list rows |
| `elevated`      | `#242424` | Modals, drawers, bottom sheets |
| `elevatedHi`    | `#2E2E2E` | Hover / pressed surface |
| `border`        | `#2E2E2E` | All dividers + card outlines |
| `borderSoft`    | `#222222` | Inner subtle dividers |
| `text`          | `#F0F0F0` | Primary text |
| `textSecondary` | `#9E9E9E` | Labels, metadata |
| `textDisabled`  | `#555555` | Disabled / placeholder |
| `red`           | `#E84040` | **Accent — primary CTAs, WORK phase, current state** |
| `redDim`        | `#7A1A1A` | Red borders / chip outlines |
| `amber`         | `#F5A623` | REST phase, warnings |
| `amberDim`      | `#7A4F00` | Amber borders |
| `green`         | `#4CAF50` | GET READY, FINISHED, PRs |
| `greenDim`      | `#1F4D22` | Green borders |
| `blue`          | `#3D8BFF` | CIRCUIT block accent |

### 2.2 Typography

| Role | Family | Weight | Size | Tracking | Notes |
|---|---|---|---|---|---|
| Timer (huge) | `JetBrainsMono` | 700 | 56 / 96 / 140 | -1.5 to -2 | `fontFeatures: [FontFeature.tabularFigures()]` — non-negotiable |
| Heading L | `Inter` | 700–800 | 22–36 | -0.4 | Page titles, exercise name |
| Heading M | `Inter` | 700 | 16–18 | -0.2 | Card titles |
| Body | `Inter` | 400–500 | 13–14 | 0 | `textWrap: pretty` |
| Meta label | `JetBrainsMono` | 600 | 9–11 | +1.2 to +1.6, **uppercase** | Section labels, badges |
| Chip | `Inter` | 600 | 10–11 | +0.4, uppercase | |

Add Google Fonts via `google_fonts` package (offline-bundled — do **not** fetch at runtime).

### 2.3 Shape

- Card / panel radius: **8**
- Chip radius: **4**
- Pill / FAB / primary button radius: **24** (or `999` for full pill — controls)
- Player full-screen: **0** (no rounding)

### 2.4 Elevation

**No drop shadows on dark.** Differentiate surfaces with `bg → surface → elevated` background steps + 1px borders. The single exception is the FAB, which uses a colored glow: `BoxShadow(color: red.withOpacity(0.35), blurRadius: 24, offset: Offset(0, 8))`.

### 2.5 Spacing

8-pt scale. Common values used in mockups: `4 / 6 / 8 / 10 / 12 / 14 / 16 / 18 / 20 / 22 / 28`. Do not invent off-grid values.

---

## 3. Screen specs

Each screen has **mobile (390 × 844, iPhone 14 Pro)** and **desktop (1280 × 820)** layouts. Use `LayoutBuilder` with a `>= 900px` breakpoint to switch.

### 3.1 Workout Player — `lib/features/player/`
**Most important screen. Build this first after Phase 2.** All other screens lead here.

**5 states** — implement as the `sealed class PlayerState` in `lib/core/player/` per `ARCHITECTURE.md`:

| State | Ring color | Center | Bottom strip |
|---|---|---|---|
| `WARMUP` | grey `#9E9E9E` | countdown MM:SS, "REMAINING" label | next-up: "Get Ready · 0:10" |
| `GET READY` | green `#4CAF50` | huge single digit `3`/`2`/`1`, full ring | next-up: "Work · 21r" |
| `WORK` (timed) | red `#E84040` | MM:SS countdown | next-up: next exercise + tiny GIF |
| `WORK` (reps/AMRAP) | red `#E84040` | MM:SS count-**up**, "ELAPSED" label, "21 REPS" sublabel | same |
| `REST` | amber `#F5A623` | MM:SS countdown | next-up preview |
| `FINISHED` | green | total time `7:42` (huge), PR chip + stats card | "✓ SAVE SESSION" CTA |

**Layout zones (mobile, 390×844):**
- Top 80px: phase badge (left) · `ROUND 1 / 3` (center mono) · close `✕` (right)
- Hero (flex): exercise GIF (220×140), exercise name (22/700), detail line (12/secondary), `TimerRing` (220×220, 10px stroke)
- Bottom 140px: next-up card (8 radius, surface) + control row (skip-back 48 / pause 56 pill / skip-fwd 48)

**Layout zones (desktop, 1280×760):**
- Two-column grid: `1fr / 320px`
- Left stage: top exit/title + 5-state cycler chips · centered split (left: phase + name + GIF / right: 340px ring) · bottom controls + keybinding hint
- Right queue panel: workout name, elapsed/round stat tiles, vertical step queue with check / current / pending states

**TimerRing (build as `CustomPainter`):**
- Track: `#1F1F1F`, stroke `10` (mobile) / `14` (desktop)
- Progress: phase color, `strokeCap: round`, animated `strokeDasharray`-equivalent via `tween` on the painter
- Center text: `JetBrainsMono` 700, tabular figures, font size `≈ ringSize × 0.28`
- Animation: 200ms linear on every tick

**Keyboard (desktop):** `Space`=pause, `→`=skip, `Esc`=exit. Show as faded mono hint under controls.

### 3.2 Exercise Library — `lib/features/library/`

**Mobile (390×844):**
- Top bar: title `Library`, sub `1,304 exercises · offline`, right icons (search, filter w/ red `3` badge for active filter count)
- Search input (10/12 padding, surface bg, `⌘K` chip on right)
- Active filter chip row (red filled if active, ✕ to dismiss)
- 2-column grid of `ExerciseCard` (gap 10)
- Bottom tab bar (4 tabs: Library / Compose / History / Settings — Library active)

**Desktop (1280×820):**
- 3-column: `240px filter rail / 1fr grid / 320px detail panel`
- Filter rail: 3 grouped checkbox lists (Body Part / Equipment / Target Muscle) — checkbox is 12×12 square, filled red when on, with right-aligned mono count
- Grid: 4 columns of cards (use `GridView.builder`, `SliverGridDelegateWithFixedCrossAxisCount`)
- Detail panel: large GIF (260px), name, primary muscle highlighted as red chip, 30d performance stat tiles (2×2 grid), bottom CTA "+ Add to workout" + favorite star

**ExerciseCard:**
- 8 radius, surface bg, 1px border
- GIF top (square-ish, fills card width × ~0.85), 1px bottom divider
- Padding 10/11/11, name (13/600), 2 chips below (body part, equipment)

**GIF loading pattern (Phase 1):** `flutter_cache_manager` → striped placeholder while loading → cached image → swap. Match the placeholder's red-on-charcoal stripe pattern (see `mockups/placeholders.jsx`).

### 3.3 Workout Composer — `lib/features/composer/`

**Mobile:**
- Top bar with workout name (inline-editable), back chevron, `SAVE` (outlined) + `▶ Play` (red filled) buttons
- Tag chip row + `+ tag` dashed chip
- Vertical timeline list of `StepRow`s
- `CircuitWrap`: dashed blue `#3D8BFF55` border, blue-tint bg `rgba(61,139,255,0.04)`, "× 3" rounds badge top-right, nested steps indented 24px
- Bottom-right FAB (red, 56h, pill, glow shadow): `+ Add Step` → opens bottom sheet `[Add Exercise / Add Rest / Add Circuit / Add Countdown]`

**Desktop:**
- 3-column: `300px library / 1fr timeline / 320px step editor`
- Library mini: search + filter chips + 2-column small `ExerciseCard` grid (drag-source for the timeline)
- Timeline center: tag row + Save/Play actions, 4 stat tiles (Steps / Est duration / Rounds / Total reps), then the `StepRow` list, then 4 dashed "+ Type" buttons row to add new steps inline
- Right editor: contextual to selected step — GIF preview, mode segmented control (REPS / TIMED / AMRAP), key-value rows (Reps, Rest after, Tempo, Scale), Duplicate / Delete at bottom

**StepRow grid:** `24 (drag handle) / 36 (numbered chip) / 1fr (name + chips + detail) / auto (duration mono) / 16 (chevron)`. Drag handle uses `::` mono glyph in mockup — replace with `Icons.drag_indicator`.

### 3.4 My Workouts — `lib/features/composer/saved/`

**Mobile:**
- Top bar with title + sub `5 saved · 17 sessions logged`
- Filter chip row (All / Benchmark / EMOM / Tabata / Strength)
- Vertical list of `WorkoutCard`s
- FAB `+ New Workout`

**Desktop:**
- Filter chip row (left) + `Import .json` outlined + `+ New Workout` red filled (right)
- 3-column grid of `WorkoutCard` (large variant)
- Trailing "+" empty card to start a new workout

**WorkoutCard:**
- 8 radius, surface bg, padding 14/16
- Top row: name (15/700) + tag chips (left), 36×36 circular `▶` outline (right)
- Divider, then 4-column mono stat grid: STEPS / EST / LAST / LOG

### 3.5 Session History — `lib/features/history/`

**Mobile:**
- 3 stat tiles: THIS WEEK / STREAK / VOLUME
- Sessions grouped by date label (`Today` / `Yesterday` / `Apr 26`...)
- `SessionRow`: time mono (left) · workout name + `5 / 5 STEPS · auto-saved` mono sub · duration mono · chevron

**Desktop:**
- 2-column: `1fr content / 320px detail`
- 4 stat tiles (Sessions 30d / Total time / Avg per session / Streak)
- **Activity heatmap**: 30-cell grid (one cell per day), red opacity steps `0 / 0.3 / 0.6 / 1.0`, 1px borderSoft, 2 radius
- Grouped session list (large variant adds an inline 8-bar mini sparkline between name and duration)
- Right detail: workout name + PR chip · big mono final time card (56pt) · round splits list · `↻ Repeat` outlined + `Compare` red CTA

---

## 4. Components to extract into `lib/shared/widgets/`

Build these once, reuse everywhere:

| Widget | File | Notes |
|---|---|---|
| `CTChip` | `chip.dart` | Inter 10/600 uppercase, 4px radius, optional color/border/bg overrides, optional mono variant |
| `CTPhaseBadge` | `phase_badge.dart` | `WORK / REST / GET READY / WARMUP / DONE` — coloured dot + label, mono |
| `CTMetaLabel` | `meta_label.dart` | Mono 10/600, +1.4 tracking, uppercase, secondary color |
| `CTTimerRing` | `timer_ring.dart` | `CustomPainter`, takes `progress 0..1`, `color`, `label`, `value`, `sub` |
| `CTGifPlaceholder` | `gif_placeholder.dart` | Striped diagonal pattern, mono label centered |
| `CTExerciseCard` | `exercise_card.dart` | sm/md/lg sizes |
| `CTStepRow` | `step_row.dart` | EXERCISE / REST / COUNTDOWN / CIRCUIT variants |
| `CTCircuitWrap` | `circuit_wrap.dart` | Dashed border, rounds badge, nested children slot |
| `CTWorkoutCard` | `workout_card.dart` | normal / large |
| `CTSessionRow` | `session_row.dart` | normal / large (with sparkline) |
| `CTFilterChip` | `filter_chip.dart` | active fills red, inactive outlined; optional dismissible ✕ |
| `CTSearchBar` | `search_bar.dart` | Surface bg, leading `⌕`, trailing `⌘K` chip |
| `CTFab` | `fab.dart` | Red pill, 56h, glow shadow |
| `CTNavRail` (desktop) | `nav_rail.dart` | 220px, sidebar nav with red active border-left |
| `CTBottomNav` (mobile) | `bottom_nav.dart` | 4 tabs, mono glyph + small label, red active |

---

## 5. Sample data referenced in mockups

The mockups use **Fran** (the CrossFit benchmark: 21–15–9 thrusters + pull-ups, for time) as the canonical example workout. Bundle this as one of the Phase 4 default templates. Other workouts referenced for the My Workouts / History list:

- Helen (3 rounds: 400m run, 21 KB swings, 12 pull-ups)
- EMOM 12 — Squat Clean
- Tabata — 8 Round Burpee
- Dave's Saturday Hybrid (custom)

Use these as the seed templates so demoing the app feels real, not Lorem-ipsum.

---

## 6. Interactions & state

The mockups show a **live mobile Player** with a real countdown — that behavior is the contract:

- 1Hz tick (the spec says 100ms ticker — fine; UI rebuilds on the second-edge for the digit, ring tweens continuously)
- Pause toggles between `❚❚ PAUSE` and `▶ RESUME`, ring animation freezes on pause
- Skip forward / back navigates between steps in the queue
- Phase transitions trigger the audio cues (last 3 sec beep, phase-start tone, finish sound) per `ARCHITECTURE.md`
- Screen stays awake while a session is active (`wakelock_plus`)

All other interactions in the mockups (filter chip toggle, drag-reorder, swipe-delete) are visual placeholders — implement per the Roadmap phase they belong to.

---

## 7. Assets you'll need (not in this bundle)

- **Exercise GIFs** — bundled JSON from Body Part Exercise Collection, lazy-loaded via `flutter_cache_manager` (see `ROADMAP.md` Phase 1)
- **Audio cues** — `assets/audio/beep.mp3`, `tone.mp3`, `finish.mp3` (placeholders OK; pick final clips during Phase 4 polish)
- **App icon + splash** — Phase 4 deliverable, not designed yet
- **Icon set** — pick **one** of `lucide_icons`, `phosphor_flutter`, or `material_symbols_icons` and stick with it. Mockups use mono Unicode glyphs as stand-ins (`⌕`, `≡`, `▶`, `❚❚`, `››`, `‹‹`, `✕`, `↻`, `★`) — map each consistently.

---

## 8. Files in this bundle

```
design_handoff_v0.4/
├── README.md                  ← this file
└── mockups/
    ├── index.html             ← entry point — open in browser to see all screens on a canvas
    ├── app.jsx                ← canvas assembly + Tweaks
    ├── theme.jsx              ← all design tokens (CT object)
    ├── frame.jsx              ← MobileFrame, DesktopFrame, nav chrome
    ├── data.jsx               ← sample exercises + Fran workout + history
    ├── placeholders.jsx       ← GIF placeholder pattern
    ├── screen-library.jsx     ← Library mobile + desktop
    ├── screen-composer.jsx    ← Composer mobile + desktop
    ├── screen-player.jsx      ← Player (5 states) mobile + desktop, includes TimerRing
    ├── screen-myworkouts.jsx  ← My Workouts mobile + desktop
    ├── screen-history.jsx     ← History mobile + desktop
    ├── design-canvas.jsx      ← presentation shell (not part of the design)
    ├── tweaks-panel.jsx       ← live tweak controls (not part of the design)
    └── ios-frame.jsx          ← (unused in current mockups)
```

**To preview:** open `mockups/index.html` in a modern browser. The canvas is pannable/zoomable, and the Tweaks panel (toolbar toggle, top-right) lets you cycle the live Player state and try alternate accent colors.

---

## 9. Implementation order (matches ROADMAP.md)

1. **Phase 0 finish:** wire `ThemeData` + `CTColors` extension from §2 above
2. **Phase 1:** build `CTExerciseCard`, `CTGifPlaceholder`, `CTSearchBar`, `CTFilterChip` → Library mobile, then Library desktop
3. **Phase 2:** build `CTStepRow`, `CTCircuitWrap`, `CTWorkoutCard`, `CTFab` → Composer mobile + desktop, then My Workouts
4. **Phase 3:** build `CTTimerRing` (`CustomPainter`), `CTPhaseBadge` → Player state machine + UI for all 5 states, then History
5. **Phase 4 polish:** swap in real icons, real GIFs, audio cues, wakelock, responsive breakpoints

Don't try to build all screens at once. Each phase ships a runnable end-to-end slice.

---

## 10. Open questions for Dave (resolve before Phase 3)

- **Light theme**: brief mentions "with light theme option later" — confirm v1 is dark-only, light is post-v1
- **Tablet breakpoint**: mockups have mobile (≤900) and desktop (≥900). Is iPad-portrait its own thing or does it fall to mobile?
- **Icon set**: pick one (Lucide / Phosphor / Material Symbols)
- **Brand mark**: the `C` square in the sidebar is a placeholder — final logo TBD
- **Player completion celebration**: brief says "confetti or subtle animation" — current mockup is subtle (PR chip + stats card). Confirm.
