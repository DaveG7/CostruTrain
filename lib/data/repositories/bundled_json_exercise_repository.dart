import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/exercise.dart' as model;
import '../local/app_database.dart';
import 'exercise_repository.dart';

part 'bundled_json_exercise_repository.g.dart';

class BundledJsonExerciseRepository implements ExerciseRepository {
  const BundledJsonExerciseRepository(this._db);

  final AppDatabase _db;

  @override
  Future<model.Exercise?> getById(String id) async {
    final row = await (_db.select(_db.exercises)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromData(row);
  }

  @override
  Future<List<model.Exercise>> search({
    String? query,
    String? bodyPart,
    String? equipment,
    String? muscleGroup,
  }) async {
    if (query != null && query.isNotEmpty) {
      return _searchWithFts(
        query,
        bodyPart: bodyPart,
        equipment: equipment,
        muscleGroup: muscleGroup,
      );
    }
    return _filterOnly(
      bodyPart: bodyPart,
      equipment: equipment,
      muscleGroup: muscleGroup,
    );
  }

  Future<List<model.Exercise>> _searchWithFts(
    String query, {
    String? bodyPart,
    String? equipment,
    String? muscleGroup,
  }) async {
    // The (col = ? OR ? IS NULL) pattern makes each filter optional:
    // when NULL is bound, the condition is always true (no filtering).
    const sql = '''
      SELECT e.id, e.external_id, e.source, e.name, e.body_part,
             e.target_primary, e.equipment, e.gif_url, e.muscle_group
      FROM exercises e
      INNER JOIN exercises_fts fts ON fts.exercise_id = e.id
      WHERE exercises_fts MATCH ?
        AND (e.body_part = ? OR ? IS NULL)
        AND (e.equipment = ? OR ? IS NULL)
        AND (e.muscle_group = ? OR ? IS NULL)
      ORDER BY fts.rank
    ''';

    final vars = [
      Variable.withString(query),
      bodyPart != null ? Variable.withString(bodyPart) : const Variable<String>(null),
      bodyPart != null ? Variable.withString(bodyPart) : const Variable<String>(null),
      equipment != null ? Variable.withString(equipment) : const Variable<String>(null),
      equipment != null ? Variable.withString(equipment) : const Variable<String>(null),
      muscleGroup != null ? Variable.withString(muscleGroup) : const Variable<String>(null),
      muscleGroup != null ? Variable.withString(muscleGroup) : const Variable<String>(null),
    ];

    final rows = await _db.customSelect(sql, variables: vars).get();
    return rows.map(_fromRow).toList();
  }

  Future<List<model.Exercise>> _filterOnly({
    String? bodyPart,
    String? equipment,
    String? muscleGroup,
  }) async {
    final rows = await (_db.select(_db.exercises)
          ..where((e) {
            Expression<bool> w = const Constant(true);
            if (bodyPart != null) w = w & e.bodyPart.equals(bodyPart);
            if (equipment != null) w = w & e.equipment.equals(equipment);
            if (muscleGroup != null) w = w & e.muscleGroup.equals(muscleGroup);
            return w;
          })
          ..orderBy([(e) => OrderingTerm.asc(e.name)]))
        .get();
    return rows.map(_fromData).toList();
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
        muscleGroup: data.muscleGroup,
      );

  model.Exercise _fromRow(QueryRow row) => model.Exercise(
        id: row.read<String>('id'),
        externalId: row.readNullable<String>('external_id'),
        source: row.read<String>('source'),
        name: row.read<String>('name'),
        bodyPart: row.read<String>('body_part'),
        targetPrimary: row.read<String>('target_primary'),
        equipment: row.read<String>('equipment'),
        gifUrl: row.readNullable<String>('gif_url'),
        muscleGroup: row.readNullable<String>('muscle_group'),
      );
}

@Riverpod(keepAlive: true)
ExerciseRepository exerciseRepository(ExerciseRepositoryRef ref) {
  return BundledJsonExerciseRepository(ref.watch(appDatabaseProvider));
}
