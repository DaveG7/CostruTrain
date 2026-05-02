import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/ct_exercise_card.dart';
import '../../../shared/widgets/ct_filter_chip.dart';
import '../../../shared/widgets/ct_search_bar.dart';
import '../providers/exercise_search_results_provider.dart';
import '../providers/library_filter_notifier.dart';
import '../widgets/filter_sheet.dart';

class ExerciseListScreen extends ConsumerStatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncExercises = ref.watch(exerciseSearchResultsProvider);
    final filter = ref.watch(libraryFilterProvider);
    final notifier = ref.read(libraryFilterProvider.notifier);

    final activeFilters = [
      if (filter.bodyPart != null) (label: filter.bodyPart!, clear: () => notifier.setBodyPart(null)),
      if (filter.equipment != null) (label: filter.equipment!, clear: () => notifier.setEquipment(null)),
      if (filter.muscleGroup != null) (label: filter.muscleGroup!, clear: () => notifier.setMuscleGroup(null)),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: CTSearchBar(
                controller: _searchController,
                hint: context.l10n.searchExercises,
                onChanged: notifier.setQuery,
              ),
            ),
            if (activeFilters.isNotEmpty)
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: activeFilters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (_, i) {
                    final f = activeFilters[i];
                    return CTFilterChip(
                      label: f.label,
                      selected: true,
                      onSelected: (_) => f.clear(),
                    );
                  },
                ),
              ),
            Expanded(
              child: asyncExercises.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: $e'),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () => ref.invalidate(exerciseSearchResultsProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (exercises) => exercises.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(context.l10n.noExercisesFound),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                notifier.clearAll();
                                _searchController.clear();
                              },
                              child: Text(context.l10n.clearFilters),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: exercises.length,
                        itemBuilder: (_, i) => CTExerciseCard(
                          exercise: exercises[i],
                          onTap: () => context.push('/library/${exercises[i].id}'),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFilterSheet,
        tooltip: context.l10n.filterExercises,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(LucideIcons.slidersHorizontal),
            if (filter.hasActiveFilters)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8FF00),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
