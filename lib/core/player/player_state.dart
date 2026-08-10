// lib/core/player/player_state.dart

import '../models/workout_step.dart';
import 'player_phase.dart';

class FlatStep {
  const FlatStep({
    required this.step,
    this.circuitRound,
    this.circuitTotalRounds,
    this.skipped = false,
  });

  final WorkoutStep step;
  final int? circuitRound;
  final int? circuitTotalRounds;
  final bool skipped;

  FlatStep copyWith({
    WorkoutStep? step,
    int? circuitRound,
    int? circuitTotalRounds,
    bool? skipped,
  }) =>
      FlatStep(
        step: step ?? this.step,
        circuitRound: circuitRound ?? this.circuitRound,
        circuitTotalRounds: circuitTotalRounds ?? this.circuitTotalRounds,
        skipped: skipped ?? this.skipped,
      );
}

class PlayerState {
  const PlayerState({
    required this.phase,
    required this.currentStepIndex,
    required this.remainingSeconds,
    required this.stepElapsedSeconds,
    required this.isPaused,
    required this.isCountingUp,
    required this.ringBellThisTick,
    required this.sequence,
    this.getReadyCountdownSeconds = 3,
  });

  final PlayerPhase phase;
  final int currentStepIndex;
  final int remainingSeconds;
  final int stepElapsedSeconds;
  final bool isPaused;
  final bool isCountingUp;
  final bool ringBellThisTick;
  final List<FlatStep> sequence;
  final int getReadyCountdownSeconds;

  bool get shouldPlayBeep =>
      !isPaused && remainingSeconds <= 3 && remainingSeconds > 0;

  FlatStep get current => sequence[currentStepIndex];

  FlatStep? get nextFlat => currentStepIndex + 1 < sequence.length
      ? sequence[currentStepIndex + 1]
      : null;

  static PlayerState idle() => const PlayerState(
        phase: PlayerPhase.idle,
        currentStepIndex: 0,
        remainingSeconds: 0,
        stepElapsedSeconds: 0,
        isPaused: false,
        isCountingUp: false,
        ringBellThisTick: false,
        sequence: [],
      );

  PlayerState copyWith({
    PlayerPhase? phase,
    int? currentStepIndex,
    int? remainingSeconds,
    int? stepElapsedSeconds,
    bool? isPaused,
    bool? isCountingUp,
    bool? ringBellThisTick,
    List<FlatStep>? sequence,
    int? getReadyCountdownSeconds,
  }) =>
      PlayerState(
        phase: phase ?? this.phase,
        currentStepIndex: currentStepIndex ?? this.currentStepIndex,
        remainingSeconds: remainingSeconds ?? this.remainingSeconds,
        stepElapsedSeconds: stepElapsedSeconds ?? this.stepElapsedSeconds,
        isPaused: isPaused ?? this.isPaused,
        isCountingUp: isCountingUp ?? this.isCountingUp,
        ringBellThisTick: ringBellThisTick ?? this.ringBellThisTick,
        sequence: sequence ?? this.sequence,
        getReadyCountdownSeconds:
            getReadyCountdownSeconds ?? this.getReadyCountdownSeconds,
      );
}
