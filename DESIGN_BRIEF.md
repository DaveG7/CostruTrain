# DESIGN_BRIEF.md — CostruTrain
## Brief for Claude Artifacts / v0.dev / Figma AI

---

## App Identity

- **Name:** CostruTrain
- **Tagline:** Build your training. Own your data.
- **Personality:** Focused, athletic, no-BS. Think a serious gym notebook that got a software upgrade. Not gamified. Not bubbly. Not corporate.

---

## Design Language

### Mood
Dark, dense, high-contrast. Inspired by:
- Zwift dark UI (cycling computer aesthetic)
- CrossFit competition scoreboards
- Terminal / data engineering tools (Dave's world)
- NOT: Duolingo, Headspace, Peloton pink/pastel

### Colors (dark-first, with light theme option later)
```
Background primary:    #0F0F0F  (near black)
Background surface:    #1A1A1A  (card bg)
Background elevated:   #242424  (modal, drawer)
Accent primary:        #E84040  (athletic red — CTAs, active timer ring)
Accent secondary:      #F5A623  (amber — rest phase, warnings)
Accent success:        #4CAF50  (green — finish, complete)
Text primary:          #F0F0F0
Text secondary:        #9E9E9E
Text disabled:         #555555
Border/divider:        #2E2E2E
```

### Typography
- **Display (timer):** Monospace or tabular-nums, large, no-nonsense — e.g. `JetBrains Mono` or `Roboto Mono`
- **Headings:** `Inter` or `DM Sans`, weight 600–700
- **Body:** `Inter`, weight 400
- **Labels/chips:** `Inter`, weight 500, uppercase tracking

### Shape
- Border radius: 8px (cards), 4px (chips), 24px (FAB/primary buttons), 0px (full-screen player)
- Minimal drop shadows — prefer border + background differentiation over shadows on dark bg
- Dense information layout — not airy. Power users want to see more, not less.

---

## Screen Inventory (design these in order)

### 1. Exercise Library Screen
**Layout:** Two-column grid (mobile) / three-column grid (tablet+)
**Each card contains:**
- GIF autoplay (looping, silent) — square aspect ratio
- Exercise name (bold, bottom of card)
- Two chips: body part + equipment
- Tap → detail screen

**Top area:**
- Search bar (always visible)
- "Filter" button → slides up bottom sheet with multi-select filters (Body Part, Equipment, Target Muscle)
- Active filter chips row (dismissible)

**Design challenge:** Make the GIF grid feel like a pro reference tool, not a recipe app.

---

### 2. Workout Composer Screen
**Layout (mobile):** Vertical, single column
- Top: Workout name (editable inline tap)
- Tag chips row
- Steps list (the "timeline")
- Each step row: left icon (exercise type or rest), center (name + detail), right (duration/reps chip)
- Long-press drag handle to reorder
- Swipe left → delete
- Tap → edit step modal

**FAB (bottom right):** "+ Add Step" → opens bottom sheet: [Add Exercise | Add Rest | Add Circuit]

**Top bar actions:** Save | Play (primary CTA in accent red)

**Layout (desktop/tablet):** 3-panel
- Left: Exercise library (mini version, searchable)
- Center: Step timeline
- Right: Step detail editor (contextual to selected step)

---

### 3. Workout Player Screen (most important — full-screen, immersive)
**Layout:** Full-screen, dark, portrait-locked on mobile

**Top area (20%):**
- Phase label: "WORK" / "REST" / "GET READY" — large, uppercase, accent color
- Round indicator: "Round 2 / 5" (for circuits)

**Center (50%):**
- Current exercise GIF (large, 16:9 or square)
- Exercise name (large, white)
- Timer: huge circular ring (red=work, amber=rest, green=countdown)
  - Center of ring: time remaining in `MM:SS` or just `SS`

**Bottom strip (20%):**
- "NEXT UP:" label + next exercise name + tiny GIF thumbnail
- Pause/Resume button (center)
- Skip button (right, smaller)

**States:**
- WARMUP: Countdown from user-set duration, neutral color ring
- GET READY: 3-2-1 countdown, accent green, current exercise already shown
- WORK: Red ring, counting down (timed) or counting up (AMRAP/reps)
- REST: Amber ring, next exercise preview
- FINISHED: Full-screen summary (total time, exercises done, rounds), confetti or subtle animation

---

### 4. My Workouts Screen
**Layout:** Vertical list
**Each workout card:**
- Workout name (large)
- Tag chips
- Metadata row: step count, estimated duration, last performed date
- Long-press → context menu (Edit, Duplicate, Share, Delete)
- Tap → quick preview modal (step list, read-only) with "Start" CTA

**Empty state:** Illustration + "Build your first workout →" button

---

### 5. Session History Screen
**Layout:** Grouped by date, vertical list
**Each session entry:**
- Workout name
- Date + time
- Duration (actual)
- Steps completed / total
- Tap → session detail (read-only player replay summary)

---

## Component Library to Define

These are the reusable components designers should spec:

| Component | Notes |
|-----------|-------|
| `ExerciseCard` | GIF + name + 2 chips, grid layout |
| `StepRow` | Timeline step in composer |
| `TimerRing` | Circular progress, 3 color states |
| `PhaseLabel` | Large uppercase text, color per phase |
| `NextUpStrip` | Bottom strip in player |
| `WorkoutCard` | Summary card in My Workouts |
| `FilterChip` | Dismissible active filter |
| `BodyPartBadge` | Colored chip per body part |
| `EquipmentIcon` | Icon + label per equipment type |
| `StepTypeBadge` | REPS / TIMED / AMRAP chip |

---

## What to Give to Claude Artifacts or v0.dev

Use this exact prompt structure:

```
Design a [screen name] for a dark-themed fitness app called CostruTrain.
App identity: serious, athletic, no-BS, dark background (#0F0F0F), accent red (#E84040).
[Paste the specific screen description from above]
Use Inter font, minimal shadows, dense information layout.
Target: Flutter-compatible component design.
Output: full-width mockup with all states (normal, active, empty).
```

For the player screen specifically, ask for all 5 player states as separate artboards.

---

## Design → Code Order

1. Design `TimerRing` component first → hand to Claude Code → implement as Flutter CustomPainter
2. Design `ExerciseCard` → implement as Flutter widget
3. Design full Player screen → implement PlayerScreen with all states
4. Design Composer step list → implement StepList with Drift-backed data
5. Design Library grid → implement with lazy GIF loading
