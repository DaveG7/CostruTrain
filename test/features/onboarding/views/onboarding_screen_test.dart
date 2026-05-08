import 'package:costrutrain/core/models/workout.dart';
import 'package:costrutrain/data/local/shared_prefs_provider.dart';
import 'package:costrutrain/features/onboarding/providers/onboarding_providers.dart';
import 'package:costrutrain/features/onboarding/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:costrutrain/generated/l10n/app_localizations.dart';

Widget _wrap(Widget child, SharedPreferences prefs) => ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        templateWorkoutsProvider.overrideWith((_) async => <Workout>[]),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );

void main() {
  late SharedPreferences prefs;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  testWidgets('screen 1 shows headline and Next button', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingScreen(), prefs));
    await tester.pumpAndSettle();
    expect(find.text('Build your training.'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Next button advances to screen 2', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingScreen(), prefs));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Start with a template or build from scratch.'), findsOneWidget);
    expect(find.text('Start empty'), findsOneWidget);
  });

  testWidgets('Start empty sets onboarding_done flag', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingScreen(), prefs));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start empty'));
    await tester.pump();
    expect(prefs.getBool('onboarding_done'), isTrue);
  });
}
