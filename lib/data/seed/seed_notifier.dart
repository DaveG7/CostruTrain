import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/shared_prefs_provider.dart';
import '../repositories/drift_workout_repository.dart';
import 'seed_service.dart';
import 'seed_state.dart';
import 'template_seed_service.dart';

part 'seed_notifier.g.dart';

@Riverpod(keepAlive: true)
SeedService seedService(SeedServiceRef ref) => const SeedService();

@riverpod
class SeedNotifier extends _$SeedNotifier {
  static const _seededKey = 'seeded';

  @override
  Future<SeedState> build() async {
    final prefs = ref.read(sharedPrefsProvider);
    final db = ref.read(appDatabaseProvider);

    // Exercise seed — runs only on first launch.
    if (!(prefs.getBool(_seededKey) ?? false)) {
      final service = ref.read(seedServiceProvider);
      await service.run(
        db: db,
        onProgress: (done, total) {
          state = AsyncData(SeedState(done: done, total: total));
        },
      );
      await prefs.setBool(_seededKey, true);
    }

    // Template seed — version-flagged, independent of exercise seed.
    await TemplateSeedService().seedIfNeeded(
      prefs: prefs,
      db: db,
      repo: ref.read(workoutRepositoryProvider),
    );

    return const SeedState(done: 1, total: 1);
  }
}
