import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:costrutrain/data/seed/seed_notifier.dart';
import 'package:costrutrain/data/seed/seed_state.dart';
import 'package:costrutrain/features/library/views/seed_splash_screen.dart';
import 'package:costrutrain/generated/l10n/app_localizations.dart';

Widget _wrap(Widget child, List<Override> overrides) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows indeterminate bar on AsyncLoading', (tester) async {
    await tester.pumpWidget(_wrap(
      const SeedSplashScreen(),
      [seedNotifierProvider.overrideWith(() => _LoadingNotifier())],
    ));
    await tester.pump();
    final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator));
    expect(bar.value, isNull); // indeterminate
  });

  testWidgets('shows determinate bar with value on progress', (tester) async {
    await tester.pumpWidget(_wrap(
      const SeedSplashScreen(),
      [seedNotifierProvider.overrideWith(() => _ProgressNotifier())],
    ));
    await tester.pump();
    final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator));
    expect(bar.value, closeTo(0.5, 0.01));
  });

  testWidgets('shows retry button on AsyncError', (tester) async {
    await tester.pumpWidget(_wrap(
      const SeedSplashScreen(),
      [seedNotifierProvider.overrideWith(() => _ErrorNotifier())],
    ));
    await tester.pump();
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}

class _LoadingNotifier extends SeedNotifier {
  @override
  Future<SeedState> build() => Completer<SeedState>().future; // never completes, no timer
}

class _ProgressNotifier extends SeedNotifier {
  @override
  Future<SeedState> build() async => const SeedState(done: 1, total: 2);
}

class _ErrorNotifier extends SeedNotifier {
  @override
  Future<SeedState> build() => Future.error('seed failed');
}
