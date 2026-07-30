import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/player/player_state.dart';
import '../../../core/models/workout_step.dart';
import '../../../data/repositories/exercise_lookup_provider.dart';

class NextStepPreview extends ConsumerWidget {
  const NextStepPreview({super.key, required this.nextFlat});

  final FlatStep nextFlat;

  String _stepName(WidgetRef ref) {
    final step = nextFlat.step;
    if (step is ExerciseStep) {
      final exercise = ref.watch(exerciseByIdProvider(step.exerciseId)).valueOrNull;
      return exercise?.name ?? step.exerciseId;
    }
    if (step is RestStep) return 'Rest';
    if (step is CountdownStep) return 'Countdown';
    if (step is CircuitBlock) return 'Circuit';
    return 'Next';
  }

  String? _gifUrl(WidgetRef ref) {
    final step = nextFlat.step;
    if (step is! ExerciseStep) return null;
    return ref.watch(exerciseByIdProvider(step.exerciseId)).valueOrNull?.gifUrl;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gifUrl = _gifUrl(ref);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: const Color(0xFF2E2E2E)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: 42,
              height: 42,
              child: gifUrl != null
                  ? CachedNetworkImage(
                      imageUrl: gifUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: const Color(0xFF242424),
                        child: const Icon(Icons.fitness_center, size: 20,
                            color: Color(0xFF9E9E9E)),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: const Color(0xFF242424),
                        child: const Icon(Icons.fitness_center, size: 20,
                            color: Color(0xFF9E9E9E)),
                      ),
                    )
                  : Container(
                      color: const Color(0xFF242424),
                      child: const Icon(Icons.fitness_center, size: 20,
                          color: Color(0xFF9E9E9E)),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NEXT UP',
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFF9E9E9E),
                    letterSpacing: 1.4,
                    fontFamily: 'RobotoMono',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _stepName(ref),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Text('›', style: TextStyle(fontSize: 18, color: Color(0xFF555555))),
        ],
      ),
    );
  }
}
