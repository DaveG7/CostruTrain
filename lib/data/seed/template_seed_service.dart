import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/step_mode.dart';
import '../../core/models/workout.dart';
import '../../core/models/workout_step.dart';
import '../local/app_database.dart';
import '../repositories/workout_repository.dart';

class TemplateSeedService {
  static const flagKey = 'templates_seeded_v1';

  Future<void> seedIfNeeded({
    required SharedPreferences prefs,
    required AppDatabase db,
    required WorkoutRepository repo,
  }) async {
    if (prefs.getBool(flagKey) ?? false) return;
    await _deleteExistingTemplates(db);
    await _insertTemplates(repo);
    await prefs.setBool(flagKey, true);
  }

  Future<void> _deleteExistingTemplates(AppDatabase db) async {
    await (db.delete(db.workouts)
          ..where((t) => t.isTemplate.equals(true)))
        .go();
  }

  Future<void> _insertTemplates(WorkoutRepository repo) async {
    final jsonStr = await rootBundle.loadString('assets/seed/templates.json');
    final list =
        (jsonDecode(jsonStr) as List<dynamic>).cast<Map<String, dynamic>>();
    for (final map in list) {
      await repo.save(_fromJson(map));
    }
  }

  Workout _fromJson(Map<String, dynamic> map) {
    final now = DateTime.now();
    return Workout(
      id: map['id'] as String,
      templateId: map['templateId'] as String,
      isTemplate: true,
      name: map['name'] as String,
      description: map['description'] as String?,
      tags: (map['tags'] as List<dynamic>).cast<String>(),
      globalRestSeconds: map['globalRestSeconds'] as int?,
      steps: _parseSteps(map['steps'] as List<dynamic>),
      createdAt: now,
      updatedAt: now,
    );
  }

  List<WorkoutStep> _parseSteps(List<dynamic> list) {
    return list.map((s) => _parseStep(s as Map<String, dynamic>)).toList();
  }

  WorkoutStep _parseStep(Map<String, dynamic> map) {
    final type = map['type'] as String;
    switch (type) {
      case 'exercise':
        return ExerciseStep(
          id: map['id'] as String,
          orderIndex: map['orderIndex'] as int,
          exerciseId: map['exerciseId'] as String,
          mode: StepMode.values.byName(map['mode'] as String),
          reps: map['reps'] as int?,
          workSeconds: map['workSeconds'] as int?,
          restSeconds: (map['restSeconds'] as int?) ?? 0,
          isConfigured: true,
        );
      case 'rest':
        return RestStep(
          id: map['id'] as String,
          orderIndex: map['orderIndex'] as int,
          durationSeconds: map['durationSeconds'] as int,
        );
      case 'countdown':
        return CountdownStep(
          id: map['id'] as String,
          orderIndex: map['orderIndex'] as int,
          durationSeconds: map['durationSeconds'] as int,
        );
      case 'circuit':
        return CircuitBlock(
          id: map['id'] as String,
          orderIndex: map['orderIndex'] as int,
          rounds: map['rounds'] as int,
          steps: (map['children'] as List<dynamic>)
              .map((c) => _parseStep(c as Map<String, dynamic>) as ExerciseStep)
              .toList(),
        );
      default:
        throw StateError('Unknown template step type: $type');
    }
  }
}
