import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/session.dart';
import '../../../data/repositories/drift_session_repository.dart';

part 'history_notifier.g.dart';

class SessionGroup {
  const SessionGroup({required this.label, required this.sessions});
  final String label;
  final List<Session> sessions;
}

@riverpod
class HistoryNotifier extends _$HistoryNotifier {
  @override
  Future<List<SessionGroup>> build() async {
    final sessions = await ref.watch(sessionRepositoryProvider).getAll();
    return groupSessions(sessions, DateTime.now());
  }
}

// Top-level for unit-testability.
List<SessionGroup> groupSessions(List<Session> sessions, DateTime now) {
  if (sessions.isEmpty) return [];

  final weekday = now.weekday; // 1=Mon … 7=Sun
  final thisWeekStart = DateTime(now.year, now.month, now.day - (weekday - 1));
  final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));

  final thisWeek = <Session>[];
  final lastWeek = <Session>[];
  final olderGroups = <String, List<Session>>{};

  for (final s in sessions) {
    if (!s.startedAt.isBefore(thisWeekStart)) {
      thisWeek.add(s);
    } else if (!s.startedAt.isBefore(lastWeekStart)) {
      lastWeek.add(s);
    } else {
      final key = DateFormat('MMM yyyy').format(s.startedAt).toUpperCase();
      (olderGroups[key] ??= []).add(s);
    }
  }

  final result = <SessionGroup>[];
  if (thisWeek.isNotEmpty) {
    result.add(SessionGroup(label: 'THIS WEEK', sessions: thisWeek));
  }
  if (lastWeek.isNotEmpty) {
    result.add(SessionGroup(label: 'LAST WEEK', sessions: lastWeek));
  }
  for (final entry in olderGroups.entries) {
    result.add(SessionGroup(label: entry.key, sessions: entry.value));
  }
  return result;
}
