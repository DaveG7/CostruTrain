import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/exercise.dart' as model;
import '../local/app_database.dart';
import 'exercise_repository.dart';

part 'bundled_json_exercise_repository.g.dart';

class BundledJsonExerciseRepository implements ExerciseRepository {
  const BundledJsonExerciseRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<model.Exercise>> getAll() async {
    final rows = await _db.select(_db.exercises).get();
    return rows.map(_fromData).toList();
  }

  @override
  Future<model.Exercise?> getById(String id) async {
    final row = await (_db.select(_db.exercises)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromData(row);
  }

  model.Exercise _fromData(Exercise data) => model.Exercise(
        id: data.id,
        externalId: data.externalId,
        source: data.source,
        name: data.name,
        bodyPart: data.bodyPart,
        targetPrimary: data.targetPrimary,
        equipment: data.equipment,
        gifUrl: data.gifUrl,
      );
}

@Riverpod(keepAlive: true)
ExerciseRepository exerciseRepository(ExerciseRepositoryRef ref) {
  return BundledJsonExerciseRepository(ref.watch(appDatabaseProvider));
}
