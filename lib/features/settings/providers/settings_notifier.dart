import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/local/shared_prefs_provider.dart';

part 'settings_notifier.g.dart';

class SettingsState {
  const SettingsState({
    required this.audioCuesEnabled,
    required this.hapticsEnabled,
    required this.defaultRestTime,
  });

  final bool audioCuesEnabled;
  final bool hapticsEnabled;
  final int defaultRestTime; // seconds, range 10–180
}

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsState build() {
    final prefs = ref.read(sharedPrefsProvider);
    return SettingsState(
      audioCuesEnabled: prefs.getBool('audioCuesEnabled') ?? true,
      hapticsEnabled: prefs.getBool('hapticsEnabled') ?? true,
      defaultRestTime: prefs.getInt('defaultRestTime') ?? 60,
    );
  }

  void setAudioCuesEnabled(bool value) {
    ref.read(sharedPrefsProvider).setBool('audioCuesEnabled', value);
    state = SettingsState(
      audioCuesEnabled: value,
      hapticsEnabled: state.hapticsEnabled,
      defaultRestTime: state.defaultRestTime,
    );
  }

  void setHapticsEnabled(bool value) {
    ref.read(sharedPrefsProvider).setBool('hapticsEnabled', value);
    state = SettingsState(
      audioCuesEnabled: state.audioCuesEnabled,
      hapticsEnabled: value,
      defaultRestTime: state.defaultRestTime,
    );
  }

  void setDefaultRestTime(int seconds) {
    ref.read(sharedPrefsProvider).setInt('defaultRestTime', seconds);
    state = SettingsState(
      audioCuesEnabled: state.audioCuesEnabled,
      hapticsEnabled: state.hapticsEnabled,
      defaultRestTime: seconds,
    );
  }
}
