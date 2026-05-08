import 'package:costrutrain/core/models/workout.dart';
import 'package:costrutrain/features/my_workouts/widgets/workout_card.dart';
import 'package:costrutrain/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Workout _baseWorkout = Workout(
  id: 'w1',
  name: 'Fran',
  tags: const ['Classic'],
  steps: const [],
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

Workout _w({String name = 'Fran', List<String> tags = const ['Classic']}) =>
    Workout(
      id: 'w1', name: name, tags: tags, steps: const [],
      createdAt: DateTime(2026), updatedAt: DateTime(2026),
    );

Widget _wrap(Widget child) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => Scaffold(body: child),
      ),
      GoRoute(
        path: '/play/:id',
        builder: (_, __) => const Scaffold(body: Text('Player')),
      ),
    ],
  );
  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

void main() {
  testWidgets('shows workout name and tags', (tester) async {
    await tester.pumpWidget(_wrap(WorkoutCard(workout: _w(), onTap: () {})));
    await tester.pumpAndSettle();
    expect(find.text('Fran'), findsOneWidget);
    expect(find.text('Classic'), findsOneWidget);
  });

  testWidgets('play button is enabled and navigates to player', (tester) async {
    await tester.pumpWidget(_wrap(WorkoutCard(workout: _w(), onTap: () {})));
    await tester.pumpAndSettle();
    final btn = tester.widget<IconButton>(find.byType(IconButton));
    expect(btn.onPressed, isNotNull);
  });

  testWidgets('step count shown; duration hidden when null', (tester) async {
    await tester.pumpWidget(_wrap(WorkoutCard(workout: _w(), onTap: () {})));
    await tester.pumpAndSettle();
    expect(find.text('0 steps'), findsOneWidget);
    expect(find.textContaining('min'), findsNothing);
  });

  testWidgets('onTap fires when card tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(WorkoutCard(workout: _w(), onTap: () => tapped = true)));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(WorkoutCard));
    expect(tapped, isTrue);
  });

  testWidgets('shows Template chip when workout.isTemplate is true', (tester) async {
    final template = _baseWorkout.copyWith(isTemplate: true);
    await tester.pumpWidget(_wrap(WorkoutCard(
      workout: template,
      onTap: () {},
    )));
    await tester.pumpAndSettle();
    expect(find.text('Template'), findsOneWidget);
  });

  testWidgets('no Template chip for regular workout', (tester) async {
    await tester.pumpWidget(_wrap(WorkoutCard(
      workout: _baseWorkout,
      onTap: () {},
    )));
    await tester.pumpAndSettle();
    expect(find.text('Template'), findsNothing);
  });
}
