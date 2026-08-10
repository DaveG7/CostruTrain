import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/step_mode.dart';
import '../../../core/models/workout.dart';
import '../../../core/models/workout_step.dart';
import '../../../core/player/player_phase.dart';
import '../../../core/player/player_state.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/repositories/drift_workout_repository.dart';
import '../../../data/repositories/exercise_lookup_provider.dart';
import '../../../shared/widgets/gif_image.dart';
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
  Workout? _workout;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // A previously finished/abandoned session may still be sitting in the
      // (keepAlive) provider's state — clear it so this fresh entry always
      // lands on the ready-to-start view instead of flashing stale results.
      // Must run post-frame: modifying a provider inside initState() itself
      // throws "Tried to modify a provider while the widget tree was building".
      ref.read(playerNotifierProvider.notifier).resetToIdle();
      final workout =
          await ref.read(workoutRepositoryProvider).getById(widget.workoutId);
      if (!mounted) return;
      if (workout == null) {
        context.pop();
        return;
      }
      setState(() => _workout = workout);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playerNotifierProvider);
    if (state.phase == PlayerPhase.idle) {
      if (_workout == null) {
        return const Scaffold(
          backgroundColor: Color(0xFF0F0F0F),
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return _ReadyToStartView(
        workout: _workout!,
        onStart: () =>
            ref.read(playerNotifierProvider.notifier).start(_workout!),
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

class _ReadyToStartView extends StatelessWidget {
  const _ReadyToStartView({required this.workout, required this.onStart});
  final Workout workout;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
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
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.playerReadyTitle,
                      style: const TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 12,
                        color: Color(0xFF4CAF50),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        workout.name.isEmpty ? 'Untitled Workout' : workout.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.sessionSteps(workout.steps.length),
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF9E9E9E)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
              child: _PillBtn(
                label: '▶  ${context.l10n.playerStartCta}',
                color: const Color(0xFFE84040),
                onTap: onStart,
              ),
            ),
          ],
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
    final roundLabel = _roundLabel(context, state);
    final (phaseLabel, phaseColor) = switch (state.phase) {
      PlayerPhase.countdown => (context.l10n.playerPhaseCountdown, const Color(0xFF4CAF50)),
      PlayerPhase.working   => (context.l10n.playerPhaseWork,      const Color(0xFFE84040)),
      PlayerPhase.resting   => (context.l10n.playerPhaseRest,      const Color(0xFFF5A623)),
      PlayerPhase.complete  => (context.l10n.playerPhaseDone,      const Color(0xFF4CAF50)),
      _                     => ('',                                 const Color(0xFF555555)),
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PhaseBadge(label: phaseLabel, color: phaseColor),
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
              context.pop();
              notifier.quit();
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

  String? _roundLabel(BuildContext context, PlayerState state) {
    final flat = state.sequence.isEmpty ? null : state.current;
    if (flat == null || flat.circuitTotalRounds == null) return null;
    return context.l10n.playerRound(
      flat.circuitRound ?? 0,
      flat.circuitTotalRounds!,
    );
  }
}

class _PhaseBadge extends StatelessWidget {
  const _PhaseBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  // Source GIFs are square (180x180) — square container so
                  // the whole picture shows instead of being cropped.
                  width: 180,
                  height: 180,
                  child: switch (_currentGifUrl(ref, state)) {
                    final url? => GifImage(
                        url: url,
                        fit: BoxFit.contain,
                        placeholder: (_) => Container(
                          color: const Color(0xFF242424),
                          child: const Icon(Icons.fitness_center,
                              size: 40, color: Color(0xFF9E9E9E)),
                        ),
                        errorWidget: (_, __) => Container(
                          color: const Color(0xFF242424),
                          child: const Icon(Icons.fitness_center,
                              size: 40, color: Color(0xFF9E9E9E)),
                        ),
                      ),
                    _ => Container(
                        color: const Color(0xFF242424),
                        child: const Icon(Icons.fitness_center,
                            size: 40, color: Color(0xFF9E9E9E)),
                      ),
                  },
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _exerciseName(context, ref, state),
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
                      label: isPaused
                          ? '▶  ${context.l10n.playerResume}'
                          : '❚❚  ${context.l10n.playerPause}',
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

  String _exerciseName(BuildContext context, WidgetRef ref, PlayerState state) {
    if (state.sequence.isEmpty) return '';
    // The pre-work buffer (PlayerPhase.countdown) always reads "Get Ready",
    // regardless of what the upcoming step is.
    if (state.phase == PlayerPhase.countdown) {
      return context.l10n.playerGetReadyLabel;
    }
    final step = state.current.step;
    if (step is ExerciseStep) {
      final exercise = ref.watch(exerciseByIdProvider(step.exerciseId)).valueOrNull;
      return exercise?.name ?? step.exerciseId;
    }
    if (step is RestStep) return context.l10n.playerRestLabel;
    if (step is CountdownStep) return context.l10n.playerCountdownLabel;
    return '';
  }

  String? _currentGifUrl(WidgetRef ref, PlayerState state) {
    if (state.sequence.isEmpty || state.phase == PlayerPhase.countdown) {
      return null;
    }
    final step = state.current.step;
    if (step is! ExerciseStep) return null;
    return ref.watch(exerciseByIdProvider(step.exerciseId)).valueOrNull?.gifUrl;
  }

  String _detailLine(PlayerState state) {
    if (state.sequence.isEmpty) return '';
    final step = state.current.step;
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
    if (state.phase == PlayerPhase.countdown) {
      return state.getReadyCountdownSeconds;
    }
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
        Text(
          context.l10n.playerComplete,
          style: const TextStyle(
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
            label: '✓  ${context.l10n.playerSaveSession}',
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
