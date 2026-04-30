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
  int get schemaVersion => 1;
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
