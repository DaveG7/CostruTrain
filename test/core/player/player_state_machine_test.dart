import 'package:flutter_test/flutter_test.dart';
import 'package:costrutrain/core/models/workout.dart';
import 'package:costrutrain/core/models/workout_step.dart';
import 'package:costrutrain/core/models/step_mode.dart';
import 'package:costrutrain/core/player/player_phase.dart';
import 'package:costrutrain/core/player/player_state.dart';
import 'package:costrutrain/core/player/player_state_machine.dart';

// Helpers
ExerciseStep _exStep({
  String id = 's1',
  int orderIndex = 0,
  StepMode mode = StepMode.timed,
  int workSeconds = 30,
  int restSeconds = 10,
}) =>
    ExerciseStep(
      id: id,
      orderIndex: orderIndex,
      exerciseId: 'ex1',
      mode: mode,
      workSeconds: workSeconds,
      restSeconds: restSeconds,
    );

RestStep _restStep({int duration = 60}) =>
    RestStep(id: 'r1', orderIndex: 0, durationSeconds: duration);

Workout _workout(List<WorkoutStep> steps) => Workout(
      id: 'w1',
      name: 'Test',
      tags: const [],
      steps: steps,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

PlayerState _tick(PlayerStateMachine m, PlayerState s, {int times = 1}) {
  for (int i = 0; i < times; i++) {
    s = m.transition(s, PlayerEvent.tick);
  }
  return s;
}

void main() {
  late PlayerStateMachine m;

  setUp(() => m = PlayerStateMachine());

  group('start', () {
    test('transitions idle → countdown with 3s and flattened sequence', () {
      final w = _workout([_exStep()]);
      final s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      expect(s.phase, PlayerPhase.countdown);
      expect(s.remainingSeconds, 3);
      expect(s.currentStepIndex, 0);
      expect(s.sequence.length, 1);
      expect(s.isPaused, false);
    });

    test('empty workout stays idle', () {
      final w = _workout([]);
      final s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      expect(s.phase, PlayerPhase.idle);
    });
  });

  group('countdown → working', () {
    test('3 ticks advance countdown then start step', () {
      final w = _workout([_exStep(workSeconds: 20, restSeconds: 0)]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      // tick 1: 3→2
      s = m.transition(s, PlayerEvent.tick);
      expect(s.phase, PlayerPhase.countdown);
      expect(s.remainingSeconds, 2);
      // tick 2: 2→1
      s = m.transition(s, PlayerEvent.tick);
      expect(s.remainingSeconds, 1);
      // tick 3: 1→0 → working
      s = m.transition(s, PlayerEvent.tick);
      expect(s.phase, PlayerPhase.working);
      expect(s.remainingSeconds, 20);
      expect(s.ringBellThisTick, true);
    });
  });

  group('working — timed', () {
    test('counts down and rings bell on step complete → rest', () {
      final w = _workout([_exStep(workSeconds: 2, restSeconds: 15)]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3); // finish countdown
      expect(s.phase, PlayerPhase.working);
      s = _tick(m, s); // 2→1
      expect(s.remainingSeconds, 1);
      s = _tick(m, s); // 1→0 → resting
      expect(s.phase, PlayerPhase.resting);
      expect(s.remainingSeconds, 15);
      expect(s.ringBellThisTick, true);
    });

    test('no rest → advance to next step countdown', () {
      final w = _workout([
        _exStep(id: 's1', orderIndex: 0, workSeconds: 1, restSeconds: 0),
        _exStep(id: 's2', orderIndex: 1, workSeconds: 10, restSeconds: 0),
      ]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3); // countdown
      s = _tick(m, s); // work 1→0 → countdown for s2
      expect(s.phase, PlayerPhase.countdown);
      expect(s.currentStepIndex, 1);
      expect(s.remainingSeconds, 3);
    });

    test('last step with no rest → complete', () {
      final w = _workout([_exStep(workSeconds: 1, restSeconds: 0)]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3); // countdown
      s = _tick(m, s); // work done → complete
      expect(s.phase, PlayerPhase.complete);
      expect(s.ringBellThisTick, true);
    });
  });

  group('working — AMRAP', () {
    test('counts up, does not auto-advance', () {
      final w = _workout([_exStep(mode: StepMode.amrap, workSeconds: 0)]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3); // countdown
      expect(s.phase, PlayerPhase.working);
      expect(s.isCountingUp, true);
      expect(s.remainingSeconds, 0);
      s = _tick(m, s);
      expect(s.remainingSeconds, 1);
      s = _tick(m, s);
      expect(s.remainingSeconds, 2);
      expect(s.phase, PlayerPhase.working); // no auto-advance
    });
  });

  group('resting', () {
    test('rest counts down → next step countdown', () {
      final w = _workout([
        _exStep(id: 's1', orderIndex: 0, workSeconds: 1, restSeconds: 2),
        _exStep(id: 's2', orderIndex: 1, workSeconds: 10, restSeconds: 0),
      ]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3); // countdown s1
      s = _tick(m, s); // s1 done → resting(2s)
      expect(s.phase, PlayerPhase.resting);
      s = _tick(m, s); // 2→1
      expect(s.remainingSeconds, 1);
      s = _tick(m, s); // 1→0 → countdown s2
      expect(s.phase, PlayerPhase.countdown);
      expect(s.currentStepIndex, 1);
    });
  });

  group('RestStep in sequence', () {
    test('RestStep in sequence starts resting phase', () {
      final w = _workout([_restStep(duration: 30)]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3); // countdown
      expect(s.phase, PlayerPhase.resting);
      expect(s.remainingSeconds, 30);
    });
  });

  group('skip', () {
    test('marks current as skipped and advances', () {
      final w = _workout([
        _exStep(id: 's1', orderIndex: 0, workSeconds: 30, restSeconds: 0),
        _exStep(id: 's2', orderIndex: 1, workSeconds: 10, restSeconds: 0),
      ]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3); // countdown
      s = m.transition(s, PlayerEvent.skip);
      expect(s.sequence[0].skipped, true);
      expect(s.currentStepIndex, 1);
      expect(s.phase, PlayerPhase.countdown);
    });

    test('skip on last step → complete', () {
      final w = _workout([_exStep()]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3);
      s = m.transition(s, PlayerEvent.skip);
      expect(s.phase, PlayerPhase.complete);
    });
  });

  group('back', () {
    test('elapsed > 3s → restart current (back to countdown)', () {
      final w = _workout([_exStep(workSeconds: 30, restSeconds: 0)]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3); // finish countdown
      s = _tick(m, s, times: 5); // elapsed = 5s
      expect(s.stepElapsedSeconds, 5);
      s = m.transition(s, PlayerEvent.back);
      expect(s.phase, PlayerPhase.countdown);
      expect(s.currentStepIndex, 0);
      expect(s.remainingSeconds, 3);
    });

    test('elapsed ≤ 3s, index > 0 → go to previous step', () {
      final w = _workout([
        _exStep(id: 's1', orderIndex: 0, workSeconds: 1, restSeconds: 0),
        _exStep(id: 's2', orderIndex: 1, workSeconds: 30, restSeconds: 0),
      ]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3); // countdown s1
      s = _tick(m, s); // s1 done → countdown s2
      s = _tick(m, s); // countdown 3→2 (stepElapsed resets to 0 per countdown)
      // We are now in countdown for s2 — stepElapsedSeconds = 0
      // back should go to s1
      s = m.transition(s, PlayerEvent.back);
      expect(s.currentStepIndex, 0);
      expect(s.phase, PlayerPhase.countdown);
    });

    test('elapsed ≤ 3s, index = 0 → no-op', () {
      final w = _workout([_exStep()]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3); // finish countdown
      // stepElapsedSeconds = 0 after countdown → working
      final before = s;
      s = m.transition(s, PlayerEvent.back);
      expect(s.currentStepIndex, before.currentStepIndex);
      expect(s.remainingSeconds, before.remainingSeconds);
    });
  });

  group('pause / resume', () {
    test('pause sets isPaused; tick is ignored while paused', () {
      final w = _workout([_exStep(workSeconds: 30, restSeconds: 0)]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3);
      final remaining = s.remainingSeconds;
      s = m.transition(s, PlayerEvent.pause);
      expect(s.isPaused, true);
      s = m.transition(s, PlayerEvent.tick);
      expect(s.remainingSeconds, remaining); // unchanged
      s = m.transition(s, PlayerEvent.resume);
      expect(s.isPaused, false);
      s = m.transition(s, PlayerEvent.tick);
      expect(s.remainingSeconds, remaining - 1); // ticking again
    });
  });

  group('quit', () {
    test('quit → idle regardless of phase', () {
      final w = _workout([_exStep()]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3);
      s = m.transition(s, PlayerEvent.quit);
      expect(s.phase, PlayerPhase.idle);
      expect(s.sequence, isEmpty);
    });
  });

  group('circuit flattening', () {
    test('2 rounds × 2 steps → 4 FlatSteps with circuitRound set', () {
      final circuit = CircuitBlock(
        id: 'c1',
        orderIndex: 0,
        rounds: 2,
        steps: [
          _exStep(id: 'cs1', orderIndex: 0, workSeconds: 10, restSeconds: 0),
          _exStep(id: 'cs2', orderIndex: 1, workSeconds: 10, restSeconds: 0),
        ],
      );
      final w = _workout([circuit]);
      final s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      expect(s.sequence.length, 4);
      expect(s.sequence[0].circuitRound, 1);
      expect(s.sequence[1].circuitRound, 1);
      expect(s.sequence[2].circuitRound, 2);
      expect(s.sequence[3].circuitRound, 2);
      expect(s.sequence[0].circuitTotalRounds, 2);
    });
  });

  group('ringBellThisTick', () {
    test('cleared after one tick', () {
      final w = _workout([_exStep(workSeconds: 10, restSeconds: 0)]);
      var s = m.transition(PlayerState.idle(), PlayerEvent.start, workout: w);
      s = _tick(m, s, times: 3); // transition to working — bell fires
      expect(s.ringBellThisTick, true);
      s = m.transition(s, PlayerEvent.tick); // next tick clears it
      expect(s.ringBellThisTick, false);
    });
  });

  group('shouldPlayBeep', () {
    test('true when remainingSeconds ∈ {3,2,1} and not paused', () {
      final base = PlayerState.idle().copyWith(
        phase: PlayerPhase.working,
        remainingSeconds: 3,
        isPaused: false,
        sequence: const [],
      );
      expect(base.shouldPlayBeep, true);
      expect(base.copyWith(remainingSeconds: 1).shouldPlayBeep, true);
      expect(base.copyWith(remainingSeconds: 0).shouldPlayBeep, false);
      expect(base.copyWith(remainingSeconds: 4).shouldPlayBeep, false);
      expect(base.copyWith(isPaused: true).shouldPlayBeep, false);
    });
  });
}
