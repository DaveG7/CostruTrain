import 'package:flutter/material.dart';

import '../../../core/models/workout_step.dart';
import '../../../shared/theme/ct_colors.dart';
import 'step_config_sheet.dart';

/// Desktop right-panel: always visible when a step is selected.
class StepConfigPanel extends StatelessWidget {
  const StepConfigPanel({
    super.key,
    required this.step,
    required this.exerciseName,
    required this.onSave,
  });

  final WorkoutStep step;
  final String exerciseName;
  final void Function(WorkoutStep updated) onSave;

  @override
  Widget build(BuildContext context) {
    final ct = Theme.of(context).extension<CTColors>();
    return Container(
      width: 320,
      color: ct?.surface ?? const Color(0xFF1A1A1A),
      child: StepConfigSheet(
        step: step,
        exerciseName: exerciseName,
        onSave: onSave,
      ),
    );
  }
}
