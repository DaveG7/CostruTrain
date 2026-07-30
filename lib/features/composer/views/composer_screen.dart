import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/models/workout.dart';
import '../../../core/models/workout_step.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/repositories/drift_workout_repository.dart';
import '../../../data/repositories/exercise_lookup_provider.dart';
import '../../../features/library/views/exercise_list_screen.dart';
import '../../../features/my_workouts/providers/my_workouts_notifier.dart';
import '../providers/composer_notifier.dart';
import '../widgets/circuit_wrap.dart';
import '../widgets/step_config_panel.dart';
import '../widgets/step_config_sheet.dart';
import '../widgets/step_row.dart';

class ComposerScreen extends ConsumerStatefulWidget {
  const ComposerScreen({super.key, this.workoutId});
  final String? workoutId;

  @override
  ConsumerState<ComposerScreen> createState() => _ComposerScreenState();
}

class _ComposerScreenState extends ConsumerState<ComposerScreen> {
  WorkoutStep? _selectedStep;
  bool _isCircuitSelectMode = false;
  final Set<int> _circuitSelectedIndices = {};

  @override
  void initState() {
    super.initState();
    _loadIfEditing();
  }

  Future<void> _loadIfEditing() async {
    final id = widget.workoutId;
    if (id == null) return;
    final repo = ref.read(workoutRepositoryProvider);
    final workout = await repo.getById(id);
    if (workout != null && mounted) {
      ref.read(composerNotifierProvider.notifier).loadWorkout(workout);
    }
  }

  Future<bool> _onWillPop() async {
    if (!ref.read(composerNotifierProvider).isDirty) return true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.discardChanges),
        content: Text(context.l10n.discardChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.discard),
          ),
        ],
      ),
    );
    if (discard == true) {
      ref.read(composerNotifierProvider.notifier).discardDraft();
    }
    return discard ?? false;
  }

  void _openPicker() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => ExerciseListScreen(
        onSelected: (ex) {
          ref.read(composerNotifierProvider.notifier).addExerciseStep(ex);
          Navigator.pop(context);
        },
      ),
    ));
  }

  void _showAddStep() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.dumbbell),
              title: Text(context.l10n.addExercise),
              onTap: () {
                Navigator.pop(context);
                _openPicker();
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.timer),
              title: Text(context.l10n.addRest),
              onTap: () {
                Navigator.pop(context);
                ref.read(composerNotifierProvider.notifier).addRestStep();
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.clock),
              title: Text(context.l10n.addCountdown),
              onTap: () {
                Navigator.pop(context);
                ref.read(composerNotifierProvider.notifier).addCountdownStep();
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.repeat),
              title: Text(context.l10n.addCircuit),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _isCircuitSelectMode = true;
                  _circuitSelectedIndices.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmWrapInCircuit() async {
    if (_circuitSelectedIndices.length < 2) return;
    final sorted = _circuitSelectedIndices.toList()..sort();
    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i] != sorted[i - 1] + 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.selectContiguousSteps)),
        );
        return;
      }
    }
    final steps = ref.read(composerNotifierProvider).draft.steps;
    if (sorted.any((i) => steps[i] is! ExerciseStep)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only exercise steps can be wrapped in a circuit')),
      );
      return;
    }

    final rounds = await showDialog<int>(
      context: context,
      builder: (_) {
        final ctrl = TextEditingController(text: '3');
        return AlertDialog(
          title: Text(context.l10n.circuitRounds),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Rounds'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, int.tryParse(ctrl.text) ?? 3),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (rounds != null) {
      ref
          .read(composerNotifierProvider.notifier)
          .wrapInCircuit(sorted.first, sorted.last, rounds);
    }
    setState(() {
      _isCircuitSelectMode = false;
      _circuitSelectedIndices.clear();
    });
  }

  void _cancelCircuitSelect() {
    setState(() {
      _isCircuitSelectMode = false;
      _circuitSelectedIndices.clear();
    });
  }

  Future<void> _save() async {
    await ref.read(composerNotifierProvider.notifier).save();
    ref.read(myWorkoutsNotifierProvider.notifier).refresh();
    if (mounted) Navigator.pop(context);
  }

  String _stepExerciseName(WorkoutStep step, Map<String, String> cache) {
    if (step is ExerciseStep) return cache[step.exerciseId] ?? step.exerciseId;
    return '';
  }

  Set<String> _collectExerciseIds(List<WorkoutStep> steps) {
    final ids = <String>{};
    for (final step in steps) {
      switch (step) {
        case ExerciseStep s:
          ids.add(s.exerciseId);
        case CircuitBlock b:
          for (final child in b.steps) {
            ids.add(child.exerciseId);
          }
        case RestStep _:
        case CountdownStep _:
          break;
      }
    }
    return ids;
  }

  @override
  Widget build(BuildContext context) {
    final composerState = ref.watch(composerNotifierProvider);
    final draft = composerState.draft;
    final isWide = MediaQuery.of(context).size.width >= 900;

    final exerciseNames = <String, String>{
      for (final id in _collectExerciseIds(draft.steps))
        id: ref.watch(exerciseByIdProvider(id)).valueOrNull?.name ?? id,
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final nav = Navigator.of(context);
        if (await _onWillPop() && mounted) nav.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () => _editMeta(draft),
            child: Text(
              draft.name.isEmpty ? context.l10n.composerTitle : draft.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          actions: [
            if (_isCircuitSelectMode) ...[
              TextButton(
                onPressed: _cancelCircuitSelect,
                child: Text(context.l10n.cancelCircuitSelect),
              ),
              TextButton(
                onPressed: _circuitSelectedIndices.length >= 2
                    ? _confirmWrapInCircuit
                    : null,
                child: Text(
                  context.l10n.wrapInCircuit(_circuitSelectedIndices.length),
                  style: TextStyle(
                    color: _circuitSelectedIndices.length >= 2
                        ? const Color(0xFFE8FF00)
                        : Theme.of(context).disabledColor,
                  ),
                ),
              ),
            ] else ...[
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: widget.workoutId != null
                    ? () => context.push('/play/${widget.workoutId}')
                    : null,
                tooltip: null,
              ),
              TextButton(
                onPressed: composerState.isDirty ? _save : null,
                child: Text(context.l10n.saveWorkout),
              ),
            ],
          ],
        ),
        body: isWide
            ? _buildDesktop(draft, exerciseNames)
            : _buildMobile(draft, exerciseNames),
        floatingActionButton: isWide || _isCircuitSelectMode
            ? null
            : FloatingActionButton(
                onPressed: _showAddStep,
                child: const Icon(LucideIcons.plus),
              ),
      ),
    );
  }

  Widget _buildMobile(Workout draft, Map<String, String> exerciseNames) {
    if (draft.steps.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.dumbbell, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(context.l10n.addStep,
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: draft.steps.length,
      onReorder: (o, n) =>
          ref.read(composerNotifierProvider.notifier).reorderSteps(o, n),
      itemBuilder: (_, i) {
        final step = draft.steps[i];
        return _buildStepRow(step, i, exerciseNames, key: ValueKey(step.id));
      },
    );
  }

  Widget _buildDesktop(Workout draft, Map<String, String> exerciseNames) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: ExerciseListScreen(
            onSelected: (ex) =>
                ref.read(composerNotifierProvider.notifier).addExerciseStep(ex),
            embedded: true,
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _buildMobile(draft, exerciseNames),
        ),
        if (_selectedStep != null) ...[
          const VerticalDivider(width: 1),
          StepConfigPanel(
            step: _selectedStep!,
            exerciseName:
                _stepExerciseName(_selectedStep!, exerciseNames),
            onSave: (updated) {
              ref
                  .read(composerNotifierProvider.notifier)
                  .updateStep(updated);
              setState(() => _selectedStep = updated);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildStepRow(
    WorkoutStep step,
    int index,
    Map<String, String> names, {
    required Key key,
  }) {
    return switch (step) {
      ExerciseStep s => ExerciseStepRow(
          key: key,
          step: s,
          exerciseName: names[s.exerciseId] ?? s.exerciseId,
          isSelectMode: _isCircuitSelectMode,
          isSelected: _circuitSelectedIndices.contains(index),
          onSelectToggle: (v) => setState(() {
            if (v) {
              _circuitSelectedIndices.add(index);
            } else {
              _circuitSelectedIndices.remove(index);
            }
          }),
          onTap: () => _openStepConfig(step, names),
        ),
      RestStep s => RestStepRow(
          key: key, step: s, onTap: () => _openStepConfig(step, names)),
      CountdownStep s => CountdownStepRow(
          key: key, step: s, onTap: () => _openStepConfig(step, names)),
      CircuitBlock b => CircuitBlockRow(
          key: key,
          block: b,
          exerciseNames: names,
          onHeaderTap: () => _openStepConfig(step, names),
          onChildTap: (child) => _openStepConfig(child, names),
        ),
    };
  }

  void _openStepConfig(WorkoutStep step, Map<String, String> names) {
    if (MediaQuery.of(context).size.width >= 900) {
      setState(() => _selectedStep = step);
    } else {
      StepConfigSheet.show(
        context,
        step: step,
        exerciseName: step is ExerciseStep
            ? (names[step.exerciseId] ?? step.exerciseId)
            : '',
        onSave: (updated) =>
            ref.read(composerNotifierProvider.notifier).updateStep(updated),
      );
    }
  }

  void _editMeta(Workout draft) {
    final nameCtrl = TextEditingController(text: draft.name);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Workout Name'),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          decoration:
              InputDecoration(hintText: context.l10n.workoutNameHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(composerNotifierProvider.notifier)
                  .updateMeta(name: nameCtrl.text.trim());
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
