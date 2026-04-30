import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/shared_prefs_provider.dart';
import 'seed_service.dart';
import 'seed_state.dart';

part 'seed_notifier.g.dart';

@Riverpod(keepAlive: true)
SeedService seedService(SeedServiceRef ref) => const SeedService();

@riverpod
class SeedNotifier extends _$SeedNotifier {
  static const _seededKey = 'seeded';

  @override
  Future<SeedState> build() async {
    final prefs = ref.read(sharedPrefsProvider);

    if (prefs.getBool(_seededKey) ?? false) {
      return const SeedState(done: 1, total: 1);
    }

    final db = ref.read(appDatabaseProvider);
    final service = ref.read(seedServiceProvider);

    await service.run(
      db: db,
      onProgress: (done, total) {
        state = AsyncData(SeedState(done: done, total: total));
      },
    );

    await prefs.setBool(_seededKey, true);
    return const SeedState(done: 1, total: 1);
  }
}
