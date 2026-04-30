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

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Exercises])
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
  int get schemaVersion => 2;

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
            // Bulk-populate FTS for existing rows (trigger only fires on future INSERTs).
            await customStatement(
                'INSERT INTO exercises_fts(name, exercise_id) SELECT name, id FROM exercises');
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
