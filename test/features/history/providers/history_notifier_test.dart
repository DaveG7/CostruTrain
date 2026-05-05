import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/core/models/session.dart';
import 'package:costrutrain/features/history/providers/history_notifier.dart';

Session _s(String id, DateTime startedAt, {bool completed = true}) => Session(
      id: id,
      workoutId: 'w1',
      workoutNameSnapshot: 'Test',
      startedAt: startedAt,
      completedAt: completed ? startedAt.add(const Duration(minutes: 5)) : null,
      totalSeconds: 300,
      stepCount: 5,
      wasCompleted: completed,
    );

void main() {
  // "now" is Wednesday 2026-05-06
  final now = DateTime(2026, 5, 6);
  // Monday of this week: 2026-05-04
  final thisMonday = DateTime(2026, 5, 4);
  // Monday of last week: 2026-04-27
  final lastMonday = DateTime(2026, 4, 27);

  test('empty list returns empty groups', () {
    final groups = groupSessions([], now);
    expect(groups, isEmpty);
  });

  test('session this week → THIS WEEK group', () {
    final sessions = [_s('s1', thisMonday.add(const Duration(hours: 10)))];
    final groups = groupSessions(sessions, now);
    expect(groups.length, 1);
    expect(groups[0].label, 'THIS WEEK');
    expect(groups[0].sessions.length, 1);
  });

  test('session last week → LAST WEEK group', () {
    final sessions = [_s('s1', lastMonday.add(const Duration(hours: 9)))];
    final groups = groupSessions(sessions, now);
    expect(groups.length, 1);
    expect(groups[0].label, 'LAST WEEK');
  });

  test('session older → month label group', () {
    final sessions = [_s('s1', DateTime(2026, 3, 15))];
    final groups = groupSessions(sessions, now);
    expect(groups.length, 1);
    expect(groups[0].label, 'MAR 2026');
  });

  test('sessions span multiple groups', () {
    final sessions = [
      _s('s1', thisMonday),
      _s('s2', lastMonday),
      _s('s3', DateTime(2026, 3, 1)),
    ];
    final groups = groupSessions(sessions, now);
    expect(groups.length, 3);
    expect(groups[0].label, 'THIS WEEK');
    expect(groups[1].label, 'LAST WEEK');
    expect(groups[2].label, 'MAR 2026');
  });

  test('sunday belongs to its own week (same week as preceding monday)', () {
    final sunday = DateTime(2026, 5, 10); // Sunday of this week
    final sessions = [_s('s1', sunday)];
    final groups = groupSessions(sessions, now);
    expect(groups[0].label, 'THIS WEEK');
  });
}
