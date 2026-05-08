import 'package:costrutrain/data/local/app_database.dart';
import 'package:costrutrain/data/repositories/drift_workout_repository.dart';
import 'package:costrutrain/data/seed/template_seed_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DriftWorkoutRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftWorkoutRepository(db);
  });

  tearDown(() => db.close());

  test('seeds templates with isTemplate:true', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final service = TemplateSeedService();

    await service.seedIfNeeded(prefs: prefs, db: db, repo: repo);

    final workouts = await repo.getAll();
    expect(workouts, isNotEmpty);
    expect(workouts.every((w) => w.isTemplate), isTrue);
    expect(workouts.every((w) => w.templateId != null), isTrue);
  });

  test('sets templates_seeded_v1 flag after seeding', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final service = TemplateSeedService();

    await service.seedIfNeeded(prefs: prefs, db: db, repo: repo);

    expect(prefs.getBool(TemplateSeedService.flagKey), isTrue);
  });

  test('does not re-seed when flag is already set', () async {
    SharedPreferences.setMockInitialValues({TemplateSeedService.flagKey: true});
    final prefs = await SharedPreferences.getInstance();
    final service = TemplateSeedService();

    await service.seedIfNeeded(prefs: prefs, db: db, repo: repo);

    final workouts = await repo.getAll();
    expect(workouts, isEmpty); // nothing inserted because flag was set
  });

  test('re-seed deletes old templates and reinserts', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final service = TemplateSeedService();

    await service.seedIfNeeded(prefs: prefs, db: db, repo: repo);
    final countAfterFirst = (await repo.getAll()).length;

    // Simulate re-seed (flag cleared)
    await prefs.remove(TemplateSeedService.flagKey);
    await service.seedIfNeeded(prefs: prefs, db: db, repo: repo);

    final countAfterSecond = (await repo.getAll()).length;
    expect(countAfterSecond, countAfterFirst); // no duplicates
  });
}
