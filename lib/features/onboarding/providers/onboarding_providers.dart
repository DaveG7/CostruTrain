import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/workout.dart';
import '../../../data/repositories/drift_workout_repository.dart';

part 'onboarding_providers.g.dart';

@riverpod
Future<List<Workout>> templateWorkouts(TemplateWorkoutsRef ref) async {
  final repo = ref.watch(workoutRepositoryProvider);
  final all = await repo.getAll();
  return all.where((w) => w.isTemplate).toList();
}
