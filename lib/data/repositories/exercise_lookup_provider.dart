import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/exercise.dart';
import 'bundled_json_exercise_repository.dart';

/// Shared by-id exercise lookup, used wherever a step only carries an
/// [Exercise.id] and needs the human-readable name/gifUrl resolved
/// (composer step rows, step config, player).
///
/// Retries a null result briefly: right after first-launch seeding
/// completes, the WASM/IndexedDB storage backend (`sharedIndexedDb`
/// fallback path, active when the browser lacks SharedArrayBuffer/
/// cross-origin isolation) can have a short visibility lag between the
/// connection that inserted a row and a fresh connection reading it back.
/// A miss here is far more likely to be that lag than a genuinely absent
/// row, so retry a few times before giving up.
final exerciseByIdProvider =
    FutureProvider.autoDispose.family<Exercise?, String>((ref, id) async {
  final repo = ref.watch(exerciseRepositoryProvider);
  var result = await repo.getById(id);
  for (var attempt = 0; result == null && attempt < 3; attempt++) {
    await Future.delayed(const Duration(milliseconds: 400));
    result = await repo.getById(id);
  }
  return result;
});
