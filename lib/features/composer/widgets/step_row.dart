import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/models/step_mode.dart';
import '../../../core/models/workout_step.dart';
import '../../../core/utils/extensions.dart';
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
    this.onDelete,
  });

  final ExerciseStep step;
  final String exerciseName;
  final VoidCallback onTap;
  final bool isSelectMode;
  final bool isSelected;
  final ValueChanged<bool>? onSelectToggle;
  final VoidCallback? onDelete;

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
      trailing: _RowTrailing(isSelectMode: isSelectMode, onDelete: onDelete),
    );
  }
}

class _RowTrailing extends StatelessWidget {
  const _RowTrailing({required this.isSelectMode, this.onDelete});
  final bool isSelectMode;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (isSelectMode) return const Icon(LucideIcons.gripVertical, size: 18);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(LucideIcons.trash2, size: 18),
          color: Theme.of(context).colorScheme.error,
          onPressed: onDelete,
          tooltip: context.l10n.removeStep,
        ),
        const Icon(LucideIcons.gripVertical, size: 18),
      ],
    );
  }
}

class RestStepRow extends StatelessWidget {
  const RestStepRow({
    super.key,
    required this.step,
    required this.onTap,
    this.onDelete,
  });
  final RestStep step;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(LucideIcons.timer,
          color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
      title: Text(context.l10n.restStepLabel(step.durationSeconds),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
      trailing: _RowTrailing(isSelectMode: false, onDelete: onDelete),
    );
  }
}

class CountdownStepRow extends StatelessWidget {
  const CountdownStepRow({
    super.key,
    required this.step,
    required this.onTap,
    this.onDelete,
  });
  final CountdownStep step;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(LucideIcons.clock,
          color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
      title: Text(context.l10n.countdownStepLabel(step.durationSeconds),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
      trailing: _RowTrailing(isSelectMode: false, onDelete: onDelete),
    );
  }
}
