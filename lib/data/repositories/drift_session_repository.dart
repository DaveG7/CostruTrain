import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/session.dart';
import '../local/app_database.dart';
import 'session_repository.dart';

part 'drift_session_repository.g.dart';

class DriftSessionRepository implements SessionRepository {
  const DriftSessionRepository(this._db);
  final AppDatabase _db;

  @override
  Future<List<Session>> getAll() async {
    final rows = await (_db.select(_db.sessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Session?> getById(String id) async {
    final row = await (_db.select(_db.sessions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Future<Session> save(Session session) async {
    await _db.into(_db.sessions).insertOnConflictUpdate(_toCompanion(session));
    return session;
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.sessions)..where((t) => t.id.equals(id))).go();
  }

  Session _toModel(SessionRow row) => Session(
        id: row.id,
        workoutId: row.workoutId,
        workoutNameSnapshot: row.workoutNameSnapshot,
        startedAt: DateTime.fromMillisecondsSinceEpoch(row.startedAt),
        completedAt: row.completedAt != null
            ? DateTime.fromMillisecondsSinceEpoch(row.completedAt!)
            : null,
        totalSeconds: row.totalSeconds,
        stepCount: row.stepCount,
        wasCompleted: row.wasCompleted,
      );

  SessionsCompanion _toCompanion(Session s) => SessionsCompanion.insert(
        id: s.id,
        workoutId: Value(s.workoutId),
        workoutNameSnapshot: s.workoutNameSnapshot,
        startedAt: s.startedAt.millisecondsSinceEpoch,
        completedAt: Value(s.completedAt?.millisecondsSinceEpoch),
        totalSeconds: s.totalSeconds,
        stepCount: s.stepCount,
        wasCompleted: Value(s.wasCompleted),
      );
}

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(SessionRepositoryRef ref) =>
    DriftSessionRepository(ref.read(appDatabaseProvider));
