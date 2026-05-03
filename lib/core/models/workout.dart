import 'package:flutter/foundation.dart';
import 'workout_step.dart';

const _kKeep = Object();

@immutable
class Workout {
  final String id;
  final String name;
  final String? description;
  final List<String> tags;
  final int? globalRestSeconds;
  final int? warmupSeconds;
  final int? cooldownSeconds;
  final List<WorkoutStep> steps;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Workout({
    required this.id,
    required this.name,
    this.description,
    required this.tags,
    this.globalRestSeconds,
    this.warmupSeconds,
    this.cooldownSeconds,
    required this.steps,
    required this.createdAt,
    required this.updatedAt,
  });

  Workout copyWith({
    String? name,
    Object? description = _kKeep,
    List<String>? tags,
    Object? globalRestSeconds = _kKeep,
    Object? warmupSeconds = _kKeep,
    Object? cooldownSeconds = _kKeep,
    List<WorkoutStep>? steps,
    DateTime? updatedAt,
  }) =>
      Workout(
        id: id,
        name: name ?? this.name,
        description: identical(description, _kKeep) ? this.description : description as String?,
        tags: tags ?? this.tags,
        globalRestSeconds: identical(globalRestSeconds, _kKeep)
            ? this.globalRestSeconds
            : globalRestSeconds as int?,
        warmupSeconds: identical(warmupSeconds, _kKeep) ? this.warmupSeconds : warmupSeconds as int?,
        cooldownSeconds:
            identical(cooldownSeconds, _kKeep) ? this.cooldownSeconds : cooldownSeconds as int?,
        steps: steps ?? this.steps,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
