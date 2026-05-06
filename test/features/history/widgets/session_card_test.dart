import 'package:costrutrain/core/models/session.dart';
import 'package:costrutrain/features/history/widgets/session_card.dart';
import 'package:costrutrain/generated/l10n/app_localizations.dart';
import 'package:costrutrain/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Session _session({bool wasCompleted = true}) => Session(
      id: 's1',
      workoutId: 'w1',
      workoutNameSnapshot: 'Fran',
      startedAt: DateTime(2026, 5, 1, 8, 30),
      completedAt: wasCompleted ? DateTime(2026, 5, 1, 8, 45) : null,
      totalSeconds: 900,
      stepCount: 6,
      wasCompleted: wasCompleted,
    );

Widget _wrap(Widget child) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => Scaffold(body: child),
        routes: [
          GoRoute(
            path: 'history/:id',
            builder: (_, __) => const Scaffold(body: Text('detail')),
          ),
        ],
      ),
    ],
  );
  return MaterialApp.router(
    routerConfig: router,
    theme: AppTheme.dark,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

void main() {
  testWidgets('renders workout name', (tester) async {
    await tester.pumpWidget(_wrap(SessionCard(session: _session())));
    await tester.pumpAndSettle();
    expect(find.text('Fran'), findsOneWidget);
  });

  testWidgets('shows COMPLETED chip when wasCompleted is true', (tester) async {
    await tester.pumpWidget(_wrap(SessionCard(session: _session(wasCompleted: true))));
    await tester.pumpAndSettle();
    expect(find.textContaining('COMPLETED'), findsOneWidget);
  });

  testWidgets('shows ABANDONED chip when wasCompleted is false', (tester) async {
    await tester.pumpWidget(
      _wrap(SessionCard(session: _session(wasCompleted: false))),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('ABANDONED'), findsOneWidget);
  });

  testWidgets('tap navigates to history detail route', (tester) async {
    await tester.pumpWidget(_wrap(SessionCard(session: _session())));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SessionCard));
    await tester.pumpAndSettle();
    expect(find.text('detail'), findsOneWidget);
  });
}
