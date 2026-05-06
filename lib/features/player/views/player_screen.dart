import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/step_mode.dart';
import '../../../core/models/workout_step.dart';
import '../../../core/player/player_phase.dart';
import '../../../core/player/player_state.dart';
import '../../../data/repositories/drift_workout_repository.dart';
import '../providers/player_notifier.dart';
import '../widgets/countdown_ring.dart';
import '../widgets/next_step_preview.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key, required this.workoutId});
  final String workoutId;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final workout =
          await ref.read(workoutRepositoryProvider).getById(widget.workoutId);
      if (!mounted) return;
      if (workout == null) {
        context.pop();
        return;
      }
      ref.read(playerNotifierProvider.notifier).start(workout);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playerNotifierProvider);
    if (state.phase == PlayerPhase.idle) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F0F0F),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return PopScope(
      canPop: state.phase == PlayerPhase.complete,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ref.read(playerNotifierProvider.notifier).pause();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        body: SafeArea(
          child: state.phase == PlayerPhase.complete
              ? _FinishedView(state: state)
              : _ActiveView(state: state),
        ),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar({required this.state});
  final PlayerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(playerNotifierProvider.notifier);
    final roundLabel = _roundLabel(state);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PhaseBadge(phase: state.phase),
          if (roundLabel != null)
            Text(
              roundLabel,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 11,
                color: Color(0xFF9E9E9E),
                letterSpacing: 1.2,
              ),
            ),
          GestureDetector(
            onTap: () {
              notifier.quit();
              context.pop();
            },
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2E2E2E)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text('✕',
                    style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 14,
                        color: Color(0xFF9E9E9E))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _roundLabel(PlayerState state) {
    final flat = state.sequence.isEmpty ? null : state.current;
    if (flat == null || flat.circuitTotalRounds == null) return null;
    return 'ROUND ${flat.circuitRound} / ${flat.circuitTotalRounds}';
  }
}

class _PhaseBadge extends StatelessWidget {
  const _PhaseBadge({required this.phase});
  final PlayerPhase phase;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (phase) {
      PlayerPhase.countdown => ('GET READY', const Color(0xFF4CAF50)),
      PlayerPhase.working   => ('WORK',      const Color(0xFFE84040)),
      PlayerPhase.resting   => ('REST',      const Color(0xFFF5A623)),
      PlayerPhase.complete  => ('DONE',      const Color(0xFF4CAF50)),
      _                     => ('',          const Color(0xFF555555)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ActiveView extends ConsumerWidget {
  const _ActiveView({required this.state});
  final PlayerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(playerNotifierProvider.notifier);
    final isPaused = state.isPaused;
    final backDisabled =
        state.currentStepIndex == 0 && state.stepElapsedSeconds < 3;

    return Column(
      children: [
        _TopBar(state: state),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 220,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF242424),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.fitness_center,
                    size: 40, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(height: 14),
              Text(
                _exerciseName(state),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _detailLine(state),
                style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(height: 14),
              CountdownRing(
                phase: state.phase,
                remainingSeconds: state.remainingSeconds,
                totalSeconds: _totalSeconds(state),
                isCountingUp: state.isCountingUp,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
          child: Column(
            children: [
              if (state.nextFlat != null) ...[
                NextStepPreview(nextFlat: state.nextFlat!),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  _CircleBtn(
                    label: '‹‹',
                    onTap: backDisabled ? null : notifier.back,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PillBtn(
                      label: isPaused ? '▶  RESUME' : '❚❚  PAUSE',
                      color: const Color(0xFFE84040),
                      onTap: isPaused ? notifier.resume : notifier.pause,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _CircleBtn(label: '››', onTap: notifier.skip),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _exerciseName(PlayerState state) {
    if (state.sequence.isEmpty) return '';
    final step = state.current.step;
    if (step is ExerciseStep) return step.exerciseId;
    if (step is RestStep) return 'Rest';
    if (step is CountdownStep) return 'Get Ready';
    return '';
  }

  String _detailLine(PlayerState state) {
    if (state.sequence.isEmpty) return '';
    final flat = state.current;
    if (flat.circuitRound != null) {
      return 'Round ${flat.circuitRound} / ${flat.circuitTotalRounds}';
    }
    final step = flat.step;
    if (step is ExerciseStep) {
      return switch (step.mode) {
        StepMode.reps  => '${step.reps ?? '?'} reps',
        StepMode.amrap => 'AMRAP',
        StepMode.timed => '${step.workSeconds ?? 0}s',
      };
    }
    return '';
  }

  int _totalSeconds(PlayerState state) {
    if (state.phase == PlayerPhase.countdown) return 3;
    if (state.sequence.isEmpty) return 0;
    final step = state.current.step;
    if (step is ExerciseStep) return step.workSeconds ?? 0;
    if (step is RestStep) return step.durationSeconds;
    if (step is CountdownStep) return step.durationSeconds;
    return 0;
  }
}

class _FinishedView extends ConsumerWidget {
  const _FinishedView({required this.state});
  final PlayerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'WORKOUT COMPLETE',
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 11,
            color: Color(0xFF4CAF50),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 32),
        Chip(
          label: Text('${state.sequence.length} steps'),
          backgroundColor: const Color(0xFF1A1A1A),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: _PillBtn(
            label: '✓  SAVE SESSION',
            color: const Color(0xFF4CAF50),
            onTap: () => context.go('/compose'),
          ),
        ),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.label, required this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: onTap == null
                ? const Color(0xFF333333)
                : const Color(0xFF2E2E2E),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'RobotoMono',
              fontSize: 18,
              color: onTap == null
                  ? const Color(0xFF333333)
                  : const Color(0xFF9E9E9E),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillBtn extends StatelessWidget {
  const _PillBtn({
    required this.label,
    required this.color,
    required this.onTap,
  });
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F0F0F),
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
