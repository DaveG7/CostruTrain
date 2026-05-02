import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/exercise.dart';
import '../../../data/repositories/bundled_json_exercise_repository.dart';
import 'library_filter_notifier.dart';

part 'exercise_search_results_provider.g.dart';

/// Drives the exercise list. autoDispose tears it down on tab switch.
/// Debounce lives in LibraryFilterNotifier.setQuery() — no Future.delayed here.
@riverpod
Future<List<Exercise>> exerciseSearchResults(ExerciseSearchResultsRef ref) {
  final filter = ref.watch(libraryFilterProvider);
  return ref.watch(exerciseRepositoryProvider).search(
        query: filter.query.isEmpty ? null : filter.query,
        bodyPart: filter.bodyPart,
        equipment: filter.equipment,
        muscleGroup: filter.muscleGroup,
      );
}
