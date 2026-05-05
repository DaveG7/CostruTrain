const _kKeep = Object();

class Session {
  const Session({
    required this.id,
    required this.workoutId,
    required this.workoutNameSnapshot,
    required this.startedAt,
    required this.completedAt,
    required this.totalSeconds,
    required this.stepCount,
    required this.wasCompleted,
  });

  final String id;
  final String? workoutId;
  final String workoutNameSnapshot;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int totalSeconds;
  final int stepCount;
  final bool wasCompleted;

  Session copyWith({
    String? id,
    Object? workoutId = _kKeep,
    String? workoutNameSnapshot,
    DateTime? startedAt,
    Object? completedAt = _kKeep,
    int? totalSeconds,
    int? stepCount,
    bool? wasCompleted,
  }) =>
      Session(
        id: id ?? this.id,
        workoutId: workoutId == _kKeep ? this.workoutId : workoutId as String?,
        workoutNameSnapshot: workoutNameSnapshot ?? this.workoutNameSnapshot,
        startedAt: startedAt ?? this.startedAt,
        completedAt:
            completedAt == _kKeep ? this.completedAt : completedAt as DateTime?,
        totalSeconds: totalSeconds ?? this.totalSeconds,
        stepCount: stepCount ?? this.stepCount,
        wasCompleted: wasCompleted ?? this.wasCompleted,
      );
}
