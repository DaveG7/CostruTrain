import 'package:costrutrain/data/local/shared_prefs_provider.dart';
import 'package:costrutrain/features/settings/providers/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  ProviderContainer container() => ProviderContainer(overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
      ]);

  test('hapticsEnabled defaults to true', () {
    expect(container().read(settingsNotifierProvider).hapticsEnabled, isTrue);
  });

  test('defaultRestTime defaults to 60', () {
    expect(
        container().read(settingsNotifierProvider).defaultRestTime, equals(60));
  });

  test('setHapticsEnabled persists to prefs', () {
    final c = container();
    c.read(settingsNotifierProvider.notifier).setHapticsEnabled(false);
    expect(c.read(settingsNotifierProvider).hapticsEnabled, isFalse);
    expect(prefs.getBool('hapticsEnabled'), isFalse);
  });

  test('setDefaultRestTime persists to prefs', () {
    final c = container();
    c.read(settingsNotifierProvider.notifier).setDefaultRestTime(90);
    expect(c.read(settingsNotifierProvider).defaultRestTime, equals(90));
    expect(prefs.getInt('defaultRestTime'), equals(90));
  });

  test('reads saved values from prefs', () async {
    SharedPreferences.setMockInitialValues({
      'hapticsEnabled': false,
      'defaultRestTime': 120,
    });
    final newPrefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [
      sharedPrefsProvider.overrideWithValue(newPrefs),
    ]);
    expect(c.read(settingsNotifierProvider).hapticsEnabled, isFalse);
    expect(c.read(settingsNotifierProvider).defaultRestTime, equals(120));
  });
}
