import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/models/step_mode.dart';
import '../../../core/models/workout_step.dart';
import '../../../shared/theme/ct_colors.dart';

class ExerciseStepRow extends StatelessWidget {
  const ExerciseStepRow({
    super.key,
    required this.step,
    required this.exerciseName,
    required this.onTap,
    this.isSelectMode = false,
    this.isSelected = false,
    this.onSelectToggle,
  });

  final ExerciseStep step;
  final String exerciseName;
  final VoidCallback onTap;
  final bool isSelectMode;
  final bool isSelected;
  final ValueChanged<bool>? onSelectToggle;

  @override
  Widget build(BuildContext context) {
    final ct = Theme.of(context).extension<CTColors>();
    final valueColor = step.isConfigured
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).disabledColor;
    final subtitle = switch (step.mode) {
      _ when !step.isConfigured => 'Tap to configure',
      StepMode.reps =>
        '${step.sets != null ? "${step.sets} × " : ""}${step.reps ?? "?"}  •  rest ${step.restSeconds}s',
      StepMode.timed =>
        '${step.workSeconds ?? "?"}s  •  rest ${step.restSeconds}s',
      StepMode.amrap =>
        'AMRAP ${step.workSeconds ?? "?"}s',
    };

    return ListTile(
      onTap: isSelectMode ? null : onTap,
      leading: isSelectMode
          ? Checkbox(
              value: isSelected,
              onChanged: (v) => onSelectToggle?.call(v ?? false),
            )
          : Icon(LucideIcons.dumbbell,
              color: ct?.accent ?? const Color(0xFFE8FF00), size: 20),
      title: Text(exerciseName,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: valueColor, fontSize: 12)),
      trailing: const Icon(LucideIcons.gripVertical, size: 18),
    );
  }
}

class RestStepRow extends StatelessWidget {
  const RestStepRow({super.key, required this.step, required this.onTap});
  final RestStep step;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(LucideIcons.timer,
          color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
      title: Text('Rest — ${step.durationSeconds}s',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
      trailing: const Icon(LucideIcons.gripVertical, size: 18),
    );
  }
}

class CountdownStepRow extends StatelessWidget {
  const CountdownStepRow({super.key, required this.step, required this.onTap});
  final CountdownStep step;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(LucideIcons.clock,
          color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
      title: Text('Countdown — ${step.durationSeconds}s',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
      trailing: const Icon(LucideIcons.gripVertical, size: 18),
    );
  }
}
