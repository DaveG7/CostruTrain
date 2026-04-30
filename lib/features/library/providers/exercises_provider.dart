import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/exercise.dart';
import '../../../data/repositories/bundled_json_exercise_repository.dart';

part 'exercises_provider.g.dart';

@riverpod
Future<List<Exercise>> exercises(ExercisesRef ref) =>
    ref.watch(exerciseRepositoryProvider).getAll();
