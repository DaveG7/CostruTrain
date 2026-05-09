import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/local/shared_prefs_provider.dart';
import '../features/composer/views/composer_screen.dart';
import '../features/history/views/history_screen.dart';
import '../features/history/views/session_detail_screen.dart';
import '../features/library/views/exercise_detail_screen.dart';
import '../features/library/views/exercise_list_screen.dart';
import '../features/library/views/seed_splash_screen.dart';
import '../features/my_workouts/views/my_workouts_screen.dart';
import '../features/onboarding/views/onboarding_screen.dart';
import '../features/player/views/player_screen.dart';
import '../features/settings/views/settings_screen.dart';
import '../shared/widgets/scaffold_with_nav.dart';

part 'router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final prefs = ref.read(sharedPrefsProvider);
  return GoRouter(
    initialLocation: '/library',
    redirect: (context, state) {
      final seeded = prefs.getBool('seeded') ?? false;
      final onboardingDone = prefs.getBool('onboarding_done') ?? false;

      if (!seeded && state.matchedLocation != '/splash') return '/splash';
      if (seeded && !onboardingDone && state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SeedSplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Detail routes — OUTSIDE ShellRoute (full-screen push, no bottom nav).
      GoRoute(
        path: '/library/:exerciseId',
        builder: (context, state) => ExerciseDetailScreen(
          exerciseId: state.pathParameters['exerciseId']!,
        ),
      ),
      GoRoute(
        path: '/compose/new',
        builder: (context, state) => const ComposerScreen(),
      ),
      GoRoute(
        path: '/compose/:workoutId',
        builder: (context, state) => ComposerScreen(
          workoutId: state.pathParameters['workoutId'],
        ),
      ),
      GoRoute(
        path: '/play/:workoutId',
        builder: (context, state) => PlayerScreen(
          workoutId: state.pathParameters['workoutId']!,
        ),
      ),
      GoRoute(
        path: '/history/:sessionId',
        builder: (context, state) => SessionDetailScreen(
          sessionId: state.pathParameters['sessionId']!,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNav(child: child),
        routes: [
          GoRoute(
            path: '/library',
            builder: (context, state) => const ExerciseListScreen(),
          ),
          GoRoute(
            path: '/compose',
            builder: (context, state) => const MyWorkoutsScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
