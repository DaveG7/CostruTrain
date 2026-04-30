import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/core/models/exercise.dart';

void main() {
  group('Exercise.fromJson', () {
    final json = {
      'id': '0042',
      'name': 'Push-up',
      'bodyPart': 'chest',
      'target': 'pectorals',
      'equipment': 'body weight',
      'gifUrl': 'https://example.com/push-up.gif',
    };

    test('maps all fields', () {
      final e = Exercise.fromJson(json);
      expect(e.id, 'exercisedb_0042');
      expect(e.externalId, '0042');
      expect(e.source, 'exercisedb');
      expect(e.name, 'Push-up');
      expect(e.bodyPart, 'chest');
      expect(e.targetPrimary, 'pectorals');
      expect(e.equipment, 'body weight');
      expect(e.gifUrl, 'https://example.com/push-up.gif');
    });

    test('gifUrl is nullable', () {
      final noGif = Map<String, dynamic>.from(json)..remove('gifUrl');
      expect(Exercise.fromJson(noGif).gifUrl, isNull);
    });
  });
}
