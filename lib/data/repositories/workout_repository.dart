import 'package:costrutrain/core/models/workout.dart';

abstract interface class WorkoutRepository {
  Future<List<Workout>> getAll();
  Future<Workout?> getById(String id);
  Future<Workout> save(Workout workout); // upsert by UUID
  Future<void> delete(String id);
}
