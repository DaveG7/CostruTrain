import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/extensions.dart';
import '../../../data/seed/seed_notifier.dart';
import '../../../data/seed/seed_state.dart';

class SeedSplashScreen extends ConsumerWidget {
  const SeedSplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<SeedState>>(seedNotifierProvider, (_, next) {
      if (next case AsyncData(value: SeedState(isDone: true))) {
        context.go('/library');
      }
    });

    final asyncState = ref.watch(seedNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'CostruTrain',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
              ),
              const Spacer(),
              switch (asyncState) {
                AsyncLoading() => Column(
                    children: [
                      const LinearProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(context.l10n.seedingProgress),
                    ],
                  ),
                AsyncData(:final value) when !value.isDone => Column(
                    children: [
                      LinearProgressIndicator(
                        value: value.total > 0 ? value.done / value.total : null,
                      ),
                      const SizedBox(height: 12),
                      Text(context.l10n.seedingProgress),
                    ],
                  ),
                AsyncData() => const SizedBox.shrink(),
                AsyncError() => Column(
                    children: [
                      Text(context.l10n.seedError),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(seedNotifierProvider),
                        child: Text(context.l10n.seedRetry),
                      ),
                    ],
                  ),
                _ => const SizedBox.shrink(),
              },
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
