import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get externalId => text().nullable()();
  TextColumn get source => text()();
  TextColumn get name => text()();
  TextColumn get bodyPart => text()();
  TextColumn get targetPrimary => text()();
  TextColumn get equipment => text()();
  TextColumn get gifUrl => text().nullable()();
  TextColumn get muscleGroup => text().nullable()();
  // Forward-compat columns (seeds populated in Phase 4)
  IntColumn get defaultSets => integer().nullable()();
  IntColumn get defaultReps => integer().nullable()();
  IntColumn get defaultRestSeconds => integer().nullable()();
  TextColumn get defaultType => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutRow')
class Workouts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  IntColumn get globalRestS => integer().nullable()();
  IntColumn get warmupSeconds => integer().nullable()();
  IntColumn get cooldownS => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutStepRow')
class WorkoutSteps extends Table {
  TextColumn get id => text()();
  TextColumn get workoutId =>
      text().references(Workouts, #id, onDelete: KeyAction.cascade)();
  IntColumn get orderIndex => integer()();
  TextColumn get type => text()(); // 'exercise'|'rest'|'circuit'|'countdown'

  // ExerciseStep fields
  TextColumn get exerciseId => text().nullable()(); // FK to exercises.id (TEXT)
  TextColumn get stepMode => text().nullable()();   // 'reps'|'timed'|'amrap'
  IntColumn get sets => integer().nullable()();
  IntColumn get reps => integer().nullable()();
  IntColumn get workSeconds => integer().nullable()();
  IntColumn get restSeconds => integer().nullable()();
  TextColumn get tempo => text().nullable()();
  BoolColumn get isConfigured =>
      boolean().withDefault(const Constant(false))();

  // CircuitBlock fields
  IntColumn get circuitRounds => integer().nullable()();

  // Nesting — self-reference tracked as TEXT nullable (no Drift .references() for self)
  TextColumn get parentStepId => text().nullable()();
  IntColumn get nestingDepth => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Exercises, Workouts, WorkoutSteps])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ??
            driftDatabase(
              name: 'costrutrain',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createFts();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(exercises, exercises.muscleGroup);
            await customStatement(
                'UPDATE exercises SET muscle_group = target_primary');
            await _createFts();
            await customStatement(
                'INSERT INTO exercises_fts(name, exercise_id) SELECT name, id FROM exercises');
          }
          if (from < 3) {
            await m.addColumn(exercises, exercises.defaultSets);
            await m.addColumn(exercises, exercises.defaultReps);
            await m.addColumn(exercises, exercises.defaultRestSeconds);
            await m.addColumn(exercises, exercises.defaultType);
            await m.createTable(workouts);
            await m.createTable(workoutSteps);
          }
        },
      );

  Future<void> _createFts() async {
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS exercises_fts
        USING fts5(name, exercise_id UNINDEXED)
    ''');
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS exercises_ai
        AFTER INSERT ON exercises BEGIN
          INSERT INTO exercises_fts(name, exercise_id)
          VALUES (new.name, new.id);
        END
    ''');
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
