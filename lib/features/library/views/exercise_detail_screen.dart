import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/utils/extensions.dart';
import '../../../data/repositories/exercise_lookup_provider.dart';
import '../../../shared/theme/ct_colors.dart';
import '../../../shared/widgets/ct_filter_chip.dart';
import '../../../shared/widgets/ct_gif_placeholder.dart';
import '../../../shared/widgets/gif_image.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncExercise = ref.watch(
      exerciseByIdProvider(exerciseId),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.ct.bg,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: asyncExercise.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.l10n.commonError('$e'))),
        data: (exercise) {
          if (exercise == null) {
            return Center(child: Text(context.l10n.exerciseNotFound));
          }
          final ct = context.ct;
          // GIFs from the source dataset are square and only 180x180 native —
          // the hero area gets the whole picture (BoxFit.contain, not cover),
          // sized up to 2/3 of screen height (capped by screen width so it
          // never overflows on a phone-width screen), but never larger than
          // 2x native resolution — past that it's just a bigger, softer blur
          // with no extra detail.
          const gifNativeSide = 180.0;
          const gifMaxScale = 2.0;
          final screenSize = MediaQuery.of(context).size;
          final fitSide = screenSize.width < screenSize.height * 2 / 3
              ? screenSize.width
              : screenSize.height * 2 / 3;
          final gifSide = fitSide < gifNativeSide * gifMaxScale
              ? fitSide
              : gifNativeSide * gifMaxScale;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: gifSide,
                    height: gifSide,
                    child: exercise.gifUrl != null
                        ? GifImage(
                            url: exercise.gifUrl!,
                            fit: BoxFit.contain,
                            placeholder: (_) =>
                                CTGifPlaceholder(height: gifSide),
                            errorWidget: (context, error) => Container(
                              color: Theme.of(context).extension<CTColors>()?.surface,
                              child: const Icon(
                                Icons.fitness_center,
                                color: Colors.grey,
                                size: 48,
                              ),
                            ),
                          )
                        : Container(
                            color: ct.elevated,
                            child: const Icon(
                              LucideIcons.dumbbell,
                              size: 64,
                              color: Colors.white24,
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
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
                      const SizedBox(height: 24),
                      _InfoRow(label: 'Primary muscle', value: exercise.targetPrimary),
                      if (exercise.muscleGroup != null &&
                          exercise.muscleGroup != exercise.targetPrimary)
                        _InfoRow(label: 'Muscle group', value: exercise.muscleGroup!),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
