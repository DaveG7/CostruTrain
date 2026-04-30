import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../providers/exercises_provider.dart';

class ExerciseListScreen extends ConsumerWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncExercises = ref.watch(exercisesProvider);

    return Scaffold(
      body: switch (asyncExercises) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        AsyncData(:final value) when value.isEmpty => Center(
            child: Text(context.l10n.exercisesEmpty),
          ),
        AsyncData(:final value) => ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, i) {
              final e = value[i];
              return ListTile(
                title: Text(e.name),
                trailing: Chip(label: Text(e.bodyPart)),
              );
            },
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
