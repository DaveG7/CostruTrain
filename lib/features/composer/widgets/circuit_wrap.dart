import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/models/workout_step.dart';
import '../../../shared/theme/ct_colors.dart';

class CircuitBlockRow extends StatelessWidget {
  const CircuitBlockRow({
    super.key,
    required this.block,
    required this.exerciseNames,
    required this.onHeaderTap,
    required this.onChildTap,
  });

  final CircuitBlock block;
  final Map<String, String> exerciseNames;
  final VoidCallback onHeaderTap;
  final void Function(ExerciseStep step) onChildTap;

  @override
  Widget build(BuildContext context) {
    final ct = Theme.of(context).extension<CTColors>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3A7BD5), width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: onHeaderTap,
            leading: const Icon(LucideIcons.repeat,
                color: Color(0xFF3A7BD5), size: 20),
            title: Text(
              'Circuit — ${block.rounds} rounds',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(LucideIcons.gripVertical, size: 18),
          ),
          const Divider(height: 1),
          ...block.steps.map(
            (step) => Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ListTile(
                onTap: () => onChildTap(step),
                leading: Icon(LucideIcons.dumbbell,
                    color: ct?.accent ?? const Color(0xFFE8FF00), size: 16),
                title: Text(
                  exerciseNames[step.exerciseId] ?? step.exerciseId,
                  style: TextStyle(
                    color: step.isConfigured
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).disabledColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
