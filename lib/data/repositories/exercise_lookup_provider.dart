import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/exercise.dart';
import 'bundled_json_exercise_repository.dart';

/// Shared by-id exercise lookup, used wherever a step only carries an
/// [Exercise.id] and needs the human-readable name/gifUrl resolved
/// (composer step rows, step config, player).
final exerciseByIdProvider =
    FutureProvider.autoDispose.family<Exercise?, String>((ref, id) {
  return ref.watch(exerciseRepositoryProvider).getById(id);
});
