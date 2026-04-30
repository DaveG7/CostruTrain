import 'package:costrutrain/core/models/exercise.dart';

abstract interface class ExerciseRepository {
  // getAll() is Phase 0 only — removed in Task 11.
  Future<List<Exercise>> getAll();
  Future<Exercise?> getById(String id);

  /// Search exercises by full-text query and/or filters.
  /// All non-null parameters are combined with AND logic.
  /// [query] runs against the FTS5 index (exercise names).
  /// [bodyPart], [equipment], [muscleGroup] are exact-match filters.
  Future<List<Exercise>> search({
    String? query,
    String? bodyPart,
    String? equipment,
    String? muscleGroup,
  });
}
