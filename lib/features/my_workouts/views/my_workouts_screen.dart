import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/utils/extensions.dart';
import '../../../data/services/workout_service.dart';
import '../providers/my_workouts_notifier.dart';
import '../widgets/workout_card.dart';

class MyWorkoutsScreen extends ConsumerWidget {
  const MyWorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myWorkoutsNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.myWorkouts)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (workouts) => workouts.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.l10n.noWorkoutsYet,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(context.l10n.noWorkoutsYetHint,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: workouts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final w = workouts[i];
                  return GestureDetector(
                    onLongPress: () => _showActions(context, ref, w.id, w.name),
                    child: WorkoutCard(
                      workout: w,
                      onTap: () => context.push('/compose/${w.id}'),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/compose/new'),
        label: Text(context.l10n.newWorkout),
        icon: const Icon(LucideIcons.plus),
      ),
    );
  }

  void _showActions(BuildContext context, WidgetRef ref, String id, String name) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.copy),
              title: Text(context.l10n.duplicate),
              onTap: () async {
                Navigator.pop(context);
                final copy = await ref.read(workoutServiceProvider).duplicate(id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(context.l10n
                            .workoutDuplicated(copy.name.replaceAll(' (copy)', '')))),
                  );
                  ref.read(myWorkoutsNotifierProvider.notifier).refresh();
                }
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, ref, id, name);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id, String name) {
    ref.read(myWorkoutsNotifierProvider.notifier).scheduleDelete(id);
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.workoutDeleted(name)),
          action: SnackBarAction(
            label: context.l10n.undo,
            onPressed: () =>
                ref.read(myWorkoutsNotifierProvider.notifier).undoDelete(id),
          ),
        ),
      );
  }
}
