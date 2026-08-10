import '../models/step_mode.dart';
import '../models/workout.dart';
import '../models/workout_step.dart';
import 'player_phase.dart';
import 'player_state.dart';

class PlayerStateMachine {
  PlayerState transition(
    PlayerState s,
    PlayerEvent event, {
    Workout? workout,
    int getReadyCountdownSeconds = 3,
  }) {
    switch (event) {
      case PlayerEvent.start:
        final seq = _flatten(workout!.steps);
        if (seq.isEmpty) return PlayerState.idle();
        return PlayerState(
          phase: PlayerPhase.countdown,
          currentStepIndex: 0,
          remainingSeconds: getReadyCountdownSeconds,
          stepElapsedSeconds: 0,
          isPaused: false,
          isCountingUp: false,
          ringBellThisTick: false,
          sequence: List.unmodifiable(seq),
          getReadyCountdownSeconds: getReadyCountdownSeconds,
        );

      case PlayerEvent.tick:
        if (s.isPaused) return s;
        return _applyTick(s);

      case PlayerEvent.skip:
        return _applySkip(s);

      case PlayerEvent.back:
        return _applyBack(s);

      case PlayerEvent.pause:
        return s.copyWith(isPaused: true);

      case PlayerEvent.resume:
        return s.copyWith(isPaused: false);

      case PlayerEvent.quit:
        return PlayerState.idle();
    }
  }

  List<FlatStep> _flatten(List<WorkoutStep> steps) {
    final result = <FlatStep>[];
    for (final step in steps) {
      if (step is CircuitBlock) {
        for (int r = 1; r <= step.rounds; r++) {
          for (final child in step.steps) {
            result.add(FlatStep(
              step: child,
              circuitRound: r,
              circuitTotalRounds: step.rounds,
            ));
          }
        }
      } else {
        result.add(FlatStep(step: step));
      }
    }
    return result;
  }

  PlayerState _applyTick(PlayerState s) {
    s = s.copyWith(ringBellThisTick: false);
    switch (s.phase) {
      case PlayerPhase.countdown:
        if (s.remainingSeconds > 1) {
          return s.copyWith(remainingSeconds: s.remainingSeconds - 1);
        }
        return _beginStep(s);

      case PlayerPhase.working:
        if (s.isCountingUp) {
          return s.copyWith(
            remainingSeconds: s.remainingSeconds + 1,
            stepElapsedSeconds: s.stepElapsedSeconds + 1,
          );
        }
        if (s.remainingSeconds > 1) {
          return s.copyWith(
            remainingSeconds: s.remainingSeconds - 1,
            stepElapsedSeconds: s.stepElapsedSeconds + 1,
          );
        }
        return _endStep(s);

      case PlayerPhase.resting:
        if (s.remainingSeconds > 1) {
          return s.copyWith(remainingSeconds: s.remainingSeconds - 1);
        }
        return _advanceToNextStep(s);

      default:
        return s;
    }
  }

  PlayerState _beginStep(PlayerState s) {
    final step = s.current.step;
    if (step is RestStep) {
      return s.copyWith(
        phase: PlayerPhase.resting,
        remainingSeconds: step.durationSeconds,
        stepElapsedSeconds: 0,
        isCountingUp: false,
        ringBellThisTick: false,
      );
    }
    final isCountingUp =
        step is ExerciseStep && step.mode != StepMode.timed;
    final totalSecs = step is ExerciseStep
        ? (step.workSeconds ?? 0)
        : (step as CountdownStep).durationSeconds;
    return s.copyWith(
      phase: PlayerPhase.working,
      remainingSeconds: isCountingUp ? 0 : totalSecs,
      stepElapsedSeconds: 0,
      isCountingUp: isCountingUp,
      ringBellThisTick: true,
    );
  }

  PlayerState _endStep(PlayerState s) {
    final step = s.current.step;
    final restSecs = step is ExerciseStep ? step.restSeconds : 0;
    if (restSecs > 0) {
      return s.copyWith(
        phase: PlayerPhase.resting,
        remainingSeconds: restSecs,
        stepElapsedSeconds: 0,
        isCountingUp: false,
        ringBellThisTick: true,
      );
    }
    return _advanceToNextStep(s);
  }

  // "Get Ready" only ever happens once, at the very start of a workout
  // (PlayerEvent.start). Every later transition — end of rest, end of work
  // with no rest, skip, back — jumps directly into the next/previous step's
  // real phase via _beginStep, with no countdown pause in between.
  PlayerState _advanceToNextStep(PlayerState s) {
    final nextIndex = s.currentStepIndex + 1;
    if (nextIndex >= s.sequence.length) {
      return s.copyWith(phase: PlayerPhase.complete, ringBellThisTick: true);
    }
    return _beginStep(
      s.copyWith(currentStepIndex: nextIndex, stepElapsedSeconds: 0),
    );
  }

  PlayerState _applySkip(PlayerState s) {
    final updated = List<FlatStep>.from(s.sequence);
    updated[s.currentStepIndex] = s.current.copyWith(skipped: true);
    final nextIndex = s.currentStepIndex + 1;
    if (nextIndex >= s.sequence.length) {
      return s.copyWith(
        phase: PlayerPhase.complete,
        sequence: List.unmodifiable(updated),
        ringBellThisTick: true,
      );
    }
    return _beginStep(s.copyWith(
      currentStepIndex: nextIndex,
      stepElapsedSeconds: 0,
      sequence: List.unmodifiable(updated),
    ));
  }

  PlayerState _applyBack(PlayerState s) {
    if (s.stepElapsedSeconds > 3) {
      return _beginStep(s.copyWith(stepElapsedSeconds: 0));
    }
    if (s.currentStepIndex > 0) {
      return _beginStep(
        s.copyWith(currentStepIndex: s.currentStepIndex - 1, stepElapsedSeconds: 0),
      );
    }
    return s;
  }
}
