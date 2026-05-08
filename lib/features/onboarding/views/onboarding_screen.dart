import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/extensions.dart';
import '../../../data/local/shared_prefs_provider.dart';
import '../providers/onboarding_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _page = 0;

  Future<void> _completeOnboarding(BuildContext context, {String? workoutId}) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool('onboarding_done', true);
    if (!context.mounted) return;
    final router = GoRouter.maybeOf(context);
    if (router == null) return;
    if (workoutId != null) {
      context.go('/compose/$workoutId');
    } else {
      context.go('/compose/new');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _page == 0 ? _buildScreen1(context) : _buildScreen2(context),
      ),
    );
  }

  Widget _buildScreen1(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            context.l10n.onboardingHeadline1,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.onboardingBody1,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _page = 1),
              child: Text(context.l10n.onboardingNext),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreen2(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            context.l10n.onboardingHeadline2,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _TemplateGrid(onTemplateSelected: (workoutId) {
              _completeOnboarding(context, workoutId: workoutId);
            }),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => _completeOnboarding(context),
              child: Text(context.l10n.onboardingStartEmpty),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateGrid extends ConsumerWidget {
  const _TemplateGrid({required this.onTemplateSelected});
  final void Function(String workoutId) onTemplateSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templateWorkoutsProvider);
    return templatesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
      data: (templates) => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: templates.length,
        itemBuilder: (context, i) {
          final t = templates[i];
          return GestureDetector(
            onTap: () => onTemplateSelected(t.id),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    t.name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (t.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      t.description!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
