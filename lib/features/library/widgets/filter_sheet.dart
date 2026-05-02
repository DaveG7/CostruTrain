import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/ct_colors.dart';
import '../../../shared/widgets/ct_filter_chip.dart';
import '../providers/library_filter_notifier.dart';

const _bodyParts = [
  'back', 'cardio', 'chest', 'lower arms', 'lower legs',
  'neck', 'shoulders', 'upper arms', 'upper legs', 'waist',
];

const _equipment = [
  'assisted', 'band', 'barbell', 'body weight', 'bosu ball',
  'cable', 'dumbbell', 'ez barbell', 'leverage machine',
  'medicine ball', 'resistance band', 'roller', 'rope',
  'smith machine', 'stability ball', 'stationary bike',
  'trap bar', 'wheel roller',
];

const _muscleGroups = [
  'abs', 'adductors', 'biceps', 'calves', 'cardiovascular system',
  'delts', 'glutes', 'hamstrings', 'lats', 'levator scapulae',
  'pectorals', 'quads', 'serratus anterior', 'spine', 'traps',
  'triceps', 'upper back',
];

class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(libraryFilterProvider);
    final notifier = ref.read(libraryFilterProvider.notifier);
    final ct = context.ct;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: ct.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ct.elevated,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                children: [
                  _Section(
                    title: 'Body Part',
                    values: _bodyParts,
                    selected: filter.bodyPart,
                    onSelect: (v) => notifier.setBodyPart(v == filter.bodyPart ? null : v),
                  ),
                  _Section(
                    title: 'Equipment',
                    values: _equipment,
                    selected: filter.equipment,
                    onSelect: (v) => notifier.setEquipment(v == filter.equipment ? null : v),
                  ),
                  _Section(
                    title: 'Muscle Group',
                    values: _muscleGroups,
                    selected: filter.muscleGroup,
                    onSelect: (v) => notifier.setMuscleGroup(v == filter.muscleGroup ? null : v),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        notifier.clearAll();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Clear all'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.values,
    required this.selected,
    required this.onSelect,
  });

  final String title;
  final List<String> values;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white54),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: values
              .map((v) => CTFilterChip(
                    label: v,
                    selected: selected == v,
                    onSelected: (_) => onSelect(v),
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
