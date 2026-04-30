import 'package:costrutrain/core/models/exercise.dart';

// getAll() is Phase 0 only.
// Phase 1 replaces it with search({String? query, String? bodyPart, String? equipment}).
abstract interface class ExerciseRepository {
  Future<List<Exercise>> getAll();
  Future<Exercise?> getById(String id);
}
