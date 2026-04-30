# Phase 1 — Exercise Library Design

**Date:** 2026-04-30
**Phase:** 1 of 6
**Goal:** Browse and preview exercises beautifully.
**Milestone:** Can browse all 1300 exercises, filter, search, see GIF preview offline.

---

## Decisions Made

| Question | Decision | Rationale |
|----------|----------|-----------|
| Icon set | Lucide (`lucide_icons`) | Consistent stroke weight, minimal aesthetic, well-maintained Flutter package |
| Tablet breakpoint | Skip — mobile only | Responsive layout is Phase 4 scope; building two layouts now doubles complexity before UX is validated |
| GIF in list vs detail | Detail screen only | 1300 cards × ~3MB GIFs = unacceptable scroll cost; list stays lightweight |
| Search + filter combination | AND logic | Most expected behavior; single Drift query with MATCH + WHERE filters |
| Search implementation | FTS5 virtual table | Roadmap-specified; correct for future dataset growth; trigger-based sync requires zero SeedService changes |

---

## Scope

### In Phase 1
- Drift schema migration v1 → v2 (FTS5 virtual table + trigger)
- `ExerciseRepository.search()` replacing `getAll()`
- `CTExerciseCard` — name, bodyPart chip, equipment chip, static placeholder
- `CTSearchBar` — debounced via provider
- `CTFilterChip` — active/inactive states
- Filter bottom sheet — bodyPart, equipment, muscleGroup (multi-select, AND logic)
- `ExerciseListScreen` — rebuilt with search + filter + list
- `ExerciseDetailScreen` — large GIF, primary/secondary muscles
- GIF loading: shimmer → cached via `flutter_cache_manager` (detail screen only)
- GoRouter route: `/library/:exerciseId`
- Unit + widget tests for all new components

### Out of Phase 1
- Tablet / desktop responsive layout (Phase 4)
- GIFs in the list card (never — detail screen only)
- "Add to workout" button on detail screen (Phase 2)
- Backend exercise API (Phase 5)
- FTS ranking / relevance tuning

---

## Data Layer

### Schema Migration v1 → v2

`AppDatabase.schemaVersion` bumps to `2`. Migration adds a new column, two SQLite-native objects via `customStatement` (Drift does not model FTS5 tables as typed tables), and bulk-populates FTS for existing rows:

```sql
-- New column for muscle group filtering
ALTER TABLE exercises ADD COLUMN muscle_group TEXT;

-- FTS5 virtual table — indexes exercise names
CREATE VIRTUAL TABLE IF NOT EXISTS exercises_fts
  USING fts5(name, exercise_id UNINDEXED);

-- Trigger: auto-populate FTS on every INSERT into exercises
CREATE TRIGGER IF NOT EXISTS exercises_ai
  AFTER INSERT ON exercises BEGIN
    INSERT INTO exercises_fts(name, exercise_id)
    VALUES (new.name, new.id);
  END;
```

- `onUpgrade(from: 1, to: 2)` runs all statements, then immediately bulk-populates FTS from existing exercises:
  ```sql
  INSERT INTO exercises_fts(name, exercise_id) SELECT name, id FROM exercises;
  ```
  This is required because the trigger only fires on future INSERTs — existing seeded rows would otherwise produce an empty FTS index after upgrade.
- `onCreate` runs `createAll()` then both statements (fresh installs start at v2). No bulk population needed — the trigger fires during seed inserts.
- If FTS migration fails, the error is logged and rethrown — the app surfaces an error state on the library screen with a retry option.

### `ExerciseRepository` Interface

`getAll()` is removed. Replaced with:

```dart
abstract class ExerciseRepository {
  Future<model.Exercise?> getById(String id);

  Future<List<model.Exercise>> search({
    String? query,
    BodyPart? bodyPart,
    Equipment? equipment,
    MuscleGroup? muscleGroup,
  });
}
```

`BundledJsonExerciseRepository` implementation:
- When `query` is non-null and non-empty: JOIN `exercises_fts MATCH ?` with `exercises` table, apply filter `WHERE` clauses on `body_part`, `equipment`, `muscle_group`, order by FTS `rank`.
- When `query` is null/empty: plain `SELECT` with `WHERE` filters on same columns, order by `name`.
- Uses `db.customSelect()` with typed mapping for the FTS JOIN path.
- Returns `List<model.Exercise>` (domain model, not Drift row class — `as model` alias preserved).

---

## State Management

### `LibraryFilterState`

Pure value class in `lib/features/library/`:

```dart
class LibraryFilterState {
  final String query;
  final BodyPart? bodyPart;
  final Equipment? equipment;
  final MuscleGroup? muscleGroup;

  bool get hasActiveFilters =>
    query.isNotEmpty || bodyPart != null || equipment != null || muscleGroup != null;
}
```

### `LibraryFilterNotifier`

`Notifier<LibraryFilterState>` in `lib/features/library/`. `keepAlive` — filter selections survive tab switches.

Methods: `setQuery(String)`, `setBodyPart(BodyPart?)`, `setEquipment(Equipment?)`, `setMuscleGroup(MuscleGroup?)`, `clearAll()`.

`setQuery()` owns the debounce via a `Timer?` field — cancels the previous timer on each call, fires after 300ms to update `state.query`. All other setters update state immediately (chip taps don't need debounce).

```dart
Timer? _debounce;

void setQuery(String value) {
  _debounce?.cancel();
  _debounce = Timer(const Duration(milliseconds: 300), () {
    state = state.copyWith(query: value);
  });
}
```

### `exerciseSearchResultsProvider`

`FutureProvider.autoDispose` — tears down when user leaves Library tab:

```dart
final exerciseSearchResultsProvider = FutureProvider.autoDispose((ref) async {
  final filter = ref.watch(libraryFilterProvider);
  return ref.watch(exerciseRepositoryProvider).search(
    query: filter.query.isEmpty ? null : filter.query,
    bodyPart: filter.bodyPart,
    equipment: filter.equipment,
    muscleGroup: filter.muscleGroup,
  );
});
```

No `Future.delayed` in the provider — debounce is entirely in `setQuery()`. The provider rebuilds only when `state.query` actually changes (after the timer fires), not on every keystroke.

---

## UI Components

All shared widgets in `lib/shared/widgets/`. Screen-specific widgets in `lib/features/library/widgets/`.

### `CTExerciseCard` — `lib/shared/widgets/exercise_card.dart`

- Static placeholder: `#242424` bg + Lucide `dumbbell` icon (no GIF in list)
- Name: Inter 14sp semibold
- bodyPart chip + equipment chip using `CTFilterChip`
- `InkWell` → `context.push('/library/$id')`
- 8px border radius, 8pt padding, `#1A1A1A` card bg

### `CTSearchBar` — `lib/shared/widgets/search_bar.dart`

- Styled `TextField`, Lucide `search` prefix icon
- Lucide `x` suffix icon (visible when non-empty), clears query on tap
- Takes `onChanged: ValueChanged<String>` callback — the screen wires it to `libraryFilterProvider.notifier.setQuery()`
- Takes optional `TextEditingController? controller` — `ExerciseListScreen` passes its own controller so it can call `controller.clear()` when `clearAll()` is triggered (programmatic field reset without rebuilding the widget)
- Shared widget stays provider-agnostic

### `CTFilterChip` — `lib/shared/widgets/filter_chip.dart`

- Thin wrapper over Flutter `FilterChip` using `CTColors` tokens
- Active: `#E8FF00` bg + `#0F0F0F` text
- Inactive: `#1A1A1A` bg + muted text, 4px border radius

### `ExerciseListScreen` — `lib/features/library/views/exercise_list_screen.dart`

Layout (top to bottom):
1. `CTSearchBar` — pinned
2. Horizontal scrollable active-filter chip row (shows applied filters, tap to remove)
3. `ListView.builder` of `CTExerciseCard` — `AsyncValue.when`:
   - `loading`: `LinearProgressIndicator` at top
   - `error`: inline error card + retry button (`ref.invalidate(exerciseSearchResultsProvider)`)
   - `data([])`: empty state — "No exercises found" + clear-filters button
   - `data(list)`: cards
4. `FloatingActionButton` (Lucide `sliders-horizontal`) — opens filter bottom sheet

### Filter Bottom Sheet — `lib/features/library/widgets/filter_sheet.dart`

- `DraggableScrollableSheet`
- Three sections: Body Part / Equipment / Muscle Group
- Each: horizontal `Wrap` of `CTFilterChip` (multi-select, tap toggles)
- "Clear all" resets notifier; "Apply" pops sheet (changes already live — notifier updated on tap)
- Active filter count shown on FAB badge

### `ExerciseDetailScreen` — `lib/features/library/views/exercise_detail_screen.dart`

- Route: `/library/:exerciseId`
- Loads exercise via `exerciseRepositoryProvider.getById(id)`
- Top: `CachedNetworkImage` for GIF — `CTGifPlaceholder` while loading, Lucide `dumbbell` on error
- Below: name (Inter 20sp bold), bodyPart + equipment chips
- Primary muscle label + secondary muscles list
- Standard `AppBar` with back arrow (`context.pop()`)

### `CTGifPlaceholder` — `lib/shared/widgets/gif_placeholder.dart`

- Shimmer animation widget used as `CachedNetworkImage` placeholder
- Matches card/detail dimensions via `SizedBox` wrapper

---

## Navigation

`/library/:exerciseId` is placed **outside** the `ShellRoute` — the detail screen is a full-screen push context with no bottom nav. The nav bar reappears on back.

```dart
// Outside ShellRoute — no bottom nav on detail
GoRoute(
  path: '/library/:exerciseId',
  builder: (context, state) => ExerciseDetailScreen(
    exerciseId: state.pathParameters['exerciseId']!,
  ),
),
// ShellRoute wraps /library, /compose, /history, /settings (unchanged)
ShellRoute(...),
```

- `context.push('/library/$id')` from the card — back button returns to library with nav restored
- No redirect guards needed on this route
- Rationale: bottom nav on a detail screen is visual noise and breaks the browse → inspect mental model

---

## Error Handling

| Scenario | Handling |
|----------|----------|
| FTS migration fails | Log via `logger`, rethrow — library screen shows error state with retry |
| Search returns empty | Empty state widget + clear-filters CTA |
| GIF load fails | Static Lucide `dumbbell` icon (same as card placeholder) |
| `exerciseSearchResultsProvider` error | Inline error card + `ref.invalidate()` retry |
| `getById` returns null | Detail screen shows "Exercise not found" + back button |

---

## Testing

### Unit Tests — `test/data/repositories/`

`ExerciseRepository.search()` using `AppDatabase.forTesting()`:
- FTS MATCH returns correct exercises
- bodyPart filter alone
- equipment filter alone
- muscleGroup filter alone
- Query + bodyPart filter (AND logic)
- Empty query returns all exercises (ordered by name)
- Query with no matches returns empty list
- `getById` found and null cases (existing tests, preserved)

### Unit Tests — `test/features/library/`

`LibraryFilterNotifier`:
- `setQuery`, `setBodyPart`, `setEquipment`, `setMuscleGroup` update state correctly
- `clearAll()` resets to initial state
- `hasActiveFilters` computed correctly

### Widget Tests — `test/features/library/`

- `CTExerciseCard`: renders name + chips, tap triggers navigation
- `ExerciseListScreen`: loading state, error state + retry, empty state + clear, populated list
- `CTFilterChip`: active/inactive visual states

No GIF tests — `CachedNetworkImage` is mocked in widget tests.

---

## File Map

```
lib/
├── data/
│   ├── local/
│   │   └── app_database.dart          ← schemaVersion 2, FTS migration
│   └── repositories/
│       ├── exercise_repository.dart   ← remove getAll(), add search()
│       └── bundled_json_exercise_repository.dart  ← FTS JOIN implementation
├── features/
│   └── library/
│       ├── providers/
│       │   ├── library_filter_notifier.dart
│       │   └── exercise_search_results_provider.dart
│       ├── views/
│       │   ├── exercise_list_screen.dart   ← rebuilt
│       │   └── exercise_detail_screen.dart ← new
│       └── widgets/
│           └── filter_sheet.dart
└── shared/
    └── widgets/
        ├── exercise_card.dart          ← new
        ├── gif_placeholder.dart        ← new
        ├── search_bar.dart             ← new
        └── filter_chip.dart            ← new
test/
├── data/repositories/
│   └── bundled_json_exercise_repository_test.dart  ← extended
└── features/library/
    ├── library_filter_notifier_test.dart  ← new
    └── exercise_list_screen_test.dart     ← new
```
