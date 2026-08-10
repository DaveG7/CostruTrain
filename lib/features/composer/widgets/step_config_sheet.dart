import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/models/step_mode.dart';
import '../../../core/models/workout_step.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/theme/ct_colors.dart';

class StepConfigSheet extends StatefulWidget {
  const StepConfigSheet({
    super.key,
    required this.step,
    required this.exerciseName,
    required this.onSave,
  });

  final WorkoutStep step;
  final String exerciseName;
  final void Function(WorkoutStep updated) onSave;

  static Future<void> show(
    BuildContext context, {
    required WorkoutStep step,
    required String exerciseName,
    required void Function(WorkoutStep) onSave,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        minChildSize: 0.6,
        initialChildSize: 0.6,
        maxChildSize: 0.92,
        snap: true,
        snapSizes: const [0.6, 0.92],
        builder: (_, controller) => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: StepConfigSheet(
            step: step,
            exerciseName: exerciseName,
            onSave: (updated) {
              onSave(updated);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  State<StepConfigSheet> createState() => _StepConfigSheetState();
}

class _StepConfigSheetState extends State<StepConfigSheet> {
  late StepMode _mode;
  late TextEditingController _sets;
  late TextEditingController _reps;
  late TextEditingController _work;
  late TextEditingController _rest;
  late TextEditingController _eccentric;
  late TextEditingController _pause;
  late TextEditingController _concentric;
  late TextEditingController _duration;
  late TextEditingController _rounds;

  @override
  void initState() {
    super.initState();
    final s = widget.step;
    if (s is ExerciseStep) {
      _mode = s.mode;
      _sets = TextEditingController(text: s.sets?.toString() ?? '');
      _reps = TextEditingController(text: s.reps?.toString() ?? '');
      _work = TextEditingController(text: s.workSeconds?.toString() ?? '');
      _rest = TextEditingController(text: s.restSeconds.toString());
      final parts = s.tempo?.split('-');
      _eccentric = TextEditingController(text: parts?.elementAtOrNull(0) ?? '');
      _pause = TextEditingController(text: parts?.elementAtOrNull(1) ?? '');
      _concentric = TextEditingController(text: parts?.elementAtOrNull(2) ?? '');
    } else {
      _mode = StepMode.reps;
      _sets = TextEditingController();
      _reps = TextEditingController();
      _work = TextEditingController();
      _rest = TextEditingController();
      _eccentric = TextEditingController();
      _pause = TextEditingController();
      _concentric = TextEditingController();
    }
    final dur = switch (s) {
      RestStep r => r.durationSeconds,
      CountdownStep c => c.durationSeconds,
      _ => 60,
    };
    _duration = TextEditingController(text: dur.toString());
    final rounds = s is CircuitBlock ? s.rounds : 3;
    _rounds = TextEditingController(text: rounds.toString());
  }

  @override
  void dispose() {
    for (final c in [
      _sets,
      _reps,
      _work,
      _rest,
      _eccentric,
      _pause,
      _concentric,
      _duration,
      _rounds,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final step = widget.step;
    final updated = switch (step) {
      ExerciseStep s => _buildExerciseStep(s),
      RestStep s => RestStep(
          id: s.id,
          orderIndex: s.orderIndex,
          durationSeconds: int.tryParse(_duration.text) ?? s.durationSeconds,
        ),
      CountdownStep s => CountdownStep(
          id: s.id,
          orderIndex: s.orderIndex,
          durationSeconds: int.tryParse(_duration.text) ?? s.durationSeconds,
        ),
      CircuitBlock s => s.copyWith(rounds: int.tryParse(_rounds.text) ?? s.rounds),
    };
    widget.onSave(updated);
  }

  ExerciseStep _buildExerciseStep(ExerciseStep s) {
    final tempoStr = [_eccentric.text, _pause.text, _concentric.text]
            .every((t) => t.isEmpty)
        ? null
        : '${_eccentric.text.isEmpty ? "0" : _eccentric.text}'
            '-${_pause.text.isEmpty ? "0" : _pause.text}'
            '-${_concentric.text.isEmpty ? "0" : _concentric.text}';

    return switch (_mode) {
      StepMode.reps => s.copyWith(
          mode: StepMode.reps,
          sets: int.tryParse(_sets.text),
          reps: int.tryParse(_reps.text),
          workSeconds: null,
          restSeconds: int.tryParse(_rest.text) ?? s.restSeconds,
          tempo: tempoStr,
          clearTempo: tempoStr == null,
          isConfigured: true,
        ),
      StepMode.timed => s.copyWith(
          mode: StepMode.timed,
          sets: null,
          reps: null,
          workSeconds: int.tryParse(_work.text),
          restSeconds: int.tryParse(_rest.text) ?? s.restSeconds,
          tempo: tempoStr,
          clearTempo: tempoStr == null,
          isConfigured: true,
        ),
      StepMode.amrap => s.copyWith(
          mode: StepMode.amrap,
          sets: null,
          reps: null,
          workSeconds: int.tryParse(_work.text),
          restSeconds: int.tryParse(_rest.text) ?? s.restSeconds,
          tempo: tempoStr,
          clearTempo: tempoStr == null,
          isConfigured: true,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final ct = Theme.of(context).extension<CTColors>();
    final bg = ct?.surface ?? const Color(0xFF1A1A1A);

    return Container(
      color: bg,
      child: Column(
        children: [
          Expanded(child: _buildContent(ct)),
          _buildSaveBar(context),
        ],
      ),
    );
  }

  Widget _buildContent(CTColors? ct) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: switch (widget.step) {
        ExerciseStep _ => _buildExerciseFields(ct),
        RestStep _ || CountdownStep _ => _buildDurationField(),
        CircuitBlock _ => _buildCircuitField(),
      },
    );
  }

  Widget _buildExerciseFields(CTColors? ct) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.exerciseName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            )),
        const SizedBox(height: 20),
        SegmentedButton<StepMode>(
          segments: [
            ButtonSegment(
                value: StepMode.reps, label: Text(context.l10n.stepModeCount)),
            ButtonSegment(
                value: StepMode.timed, label: Text(context.l10n.stepModeTimed)),
            ButtonSegment(
                value: StepMode.amrap, label: Text(context.l10n.stepModeAmrap)),
          ],
          selected: {_mode},
          onSelectionChanged: (s) => setState(() => _mode = s.first),
        ),
        const SizedBox(height: 20),
        if (_mode == StepMode.reps) ...[
          _field(context.l10n.sets, _sets),
          const SizedBox(height: 12),
          _field(context.l10n.reps, _reps),
        ] else ...[
          _field(context.l10n.duration, _work, suffix: 's'),
        ],
        const SizedBox(height: 12),
        _field(context.l10n.rest, _rest, suffix: 's'),
        const SizedBox(height: 16),
        ExpansionTile(
          title: Text(context.l10n.tempo),
          tilePadding: EdgeInsets.zero,
          children: [
            Row(
              children: [
                Expanded(child: _field('Eccentric', _eccentric)),
                const SizedBox(width: 8),
                Expanded(child: _field('Pause', _pause)),
                const SizedBox(width: 8),
                Expanded(child: _field('Concentric', _concentric)),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationField() => _field('Duration', _duration, suffix: 's');
  Widget _buildCircuitField() => _field('Rounds', _rounds);

  Widget _field(String label, TextEditingController ctrl, {String? suffix}) =>
      TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      );

  Widget _buildSaveBar(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
            16, 8, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _save,
            child: Text(context.l10n.saveStep),
          ),
        ),
      );
}
