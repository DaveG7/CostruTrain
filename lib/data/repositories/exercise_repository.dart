import 'package:costrutrain/core/models/exercise.dart';

abstract interface class ExerciseRepository {
  Future<Exercise?> getById(String id);

  Future<List<Exercise>> search({
    String? query,
    String? bodyPart,
    String? equipment,
    String? muscleGroup,
  });
}
