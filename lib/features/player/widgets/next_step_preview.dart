import 'package:flutter/material.dart';

import '../../../core/player/player_state.dart';
import '../../../core/models/workout_step.dart';

class NextStepPreview extends StatelessWidget {
  const NextStepPreview({super.key, required this.nextFlat});

  final FlatStep nextFlat;

  String _stepName() {
    final step = nextFlat.step;
    if (step is ExerciseStep) return step.exerciseId;
    if (step is RestStep) return 'Rest';
    if (step is CountdownStep) return 'Countdown';
    if (step is CircuitBlock) return 'Circuit';
    return 'Next';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: const Color(0xFF2E2E2E)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.fitness_center, size: 20,
                color: Color(0xFF9E9E9E)),
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
                  _stepName(),
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
