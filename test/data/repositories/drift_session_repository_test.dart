import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/data/local/app_database.dart';
import 'package:costrutrain/data/repositories/drift_session_repository.dart';
import 'package:costrutrain/core/models/session.dart';

void main() {
  late AppDatabase db;
  late DriftSessionRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftSessionRepository(db);
  });
  tearDown(() => db.close());

  final baseTime = DateTime.fromMillisecondsSinceEpoch(1000000);

  Session makeSession(String id) => Session(
    id: id,
    workoutId: 'w1',
    workoutNameSnapshot: 'Test',
    startedAt: baseTime,
    completedAt: null,
    totalSeconds: 60,
    stepCount: 3,
    wasCompleted: false,
  );

  test('save and getById', () async {
    final s = makeSession('s1');
    await repo.save(s);
    final found = await repo.getById('s1');
    expect(found, isNotNull);
    expect(found!.workoutNameSnapshot, 'Test');
    expect(found.wasCompleted, false);
  });

  test('getAll returns newest first', () async {
    final s1 = makeSession('s1').copyWith(
      startedAt: DateTime.fromMillisecondsSinceEpoch(1000000),
    );
    final s2 = makeSession('s2').copyWith(
      startedAt: DateTime.fromMillisecondsSinceEpoch(2000000),
    );
    await repo.save(s1);
    await repo.save(s2);
    final all = await repo.getAll();
    expect(all.first.id, 's2');
    expect(all.last.id, 's1');
  });

  test('save overwrites on conflict (upsert)', () async {
    await repo.save(makeSession('s1'));
    final updated = makeSession('s1').copyWith(totalSeconds: 120);
    await repo.save(updated);
    final found = await repo.getById('s1');
    expect(found!.totalSeconds, 120);
  });

  test('delete removes session', () async {
    await repo.save(makeSession('s1'));
    await repo.delete('s1');
    final found = await repo.getById('s1');
    expect(found, isNull);
  });

  test('getById returns null for missing id', () async {
    final found = await repo.getById('nope');
    expect(found, isNull);
  });
}
