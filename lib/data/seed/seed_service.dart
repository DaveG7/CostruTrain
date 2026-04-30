import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../../core/models/exercise.dart' as model;
import '../local/app_database.dart';

class SeedService {
  const SeedService({this.defaultAsset = 'assets/seed/exercises.json'});

  final String defaultAsset;

  Future<void> run({
    required AppDatabase db,
    String? assetPath,
    int chunkSize = 100,
    void Function(int done, int total)? onProgress,
  }) async {
    final raw = await rootBundle.loadString(assetPath ?? defaultAsset);
    await runWithJson(db: db, json: raw, chunkSize: chunkSize, onProgress: onProgress);
  }

  Future<void> runWithJson({
    required AppDatabase db,
    required String json,
    int chunkSize = 100,
    void Function(int done, int total)? onProgress,
  }) async {
    final list = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
    final exercises = list.map(model.Exercise.fromJson).toList();
    final total = (exercises.length / chunkSize).ceil();

    for (var i = 0; i < total; i++) {
      final chunk = exercises.sublist(
        i * chunkSize,
        min((i + 1) * chunkSize, exercises.length),
      );
      await db.batch((b) => b.insertAllOnConflictUpdate(
            db.exercises,
            chunk.map(_toCompanion).toList(),
          ));
      onProgress?.call(i + 1, total);
    }
  }

  ExercisesCompanion _toCompanion(model.Exercise e) => ExercisesCompanion.insert(
        id: e.id,
        externalId: Value(e.externalId),
        source: e.source,
        name: e.name,
        bodyPart: e.bodyPart,
        targetPrimary: e.targetPrimary,
        equipment: e.equipment,
        gifUrl: Value(e.gifUrl),
      );
}

// Test helper — overrides run() to use in-memory JSON instead of rootBundle.
class OverridableSeedService extends SeedService {
  const OverridableSeedService({required this.json});
  final String json;

  @override
  Future<void> run({
    required AppDatabase db,
    String? assetPath,
    int chunkSize = 100,
    void Function(int done, int total)? onProgress,
  }) =>
      runWithJson(db: db, json: json, chunkSize: chunkSize, onProgress: onProgress);
}
