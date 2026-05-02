import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/models/exercise.dart';
import '../theme/ct_colors.dart';
import 'ct_filter_chip.dart';

class CTExerciseCard extends StatelessWidget {
  const CTExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  final Exercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ct = context.ct;
    return Card(
      color: ct.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: ct.elevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.dumbbell, color: Colors.white38, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: [
                        CTFilterChip(
                          label: exercise.bodyPart,
                          selected: false,
                          onSelected: null,
                        ),
                        CTFilterChip(
                          label: exercise.equipment,
                          selected: false,
                          onSelected: null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, size: 16, color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }
}
