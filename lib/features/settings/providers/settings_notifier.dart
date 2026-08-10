import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/local/shared_prefs_provider.dart';

part 'settings_notifier.g.dart';

class SettingsState {
  const SettingsState({
    required this.audioCuesEnabled,
    required this.hapticsEnabled,
    required this.defaultRestTime,
    required this.startCountdownSeconds,
    required this.showExercisesWithoutMedia,
  });

  final bool audioCuesEnabled;
  final bool hapticsEnabled;
  final int defaultRestTime; // seconds, range 10–180
  final int startCountdownSeconds; // "Get Ready" countdown, range 3–15
  final bool showExercisesWithoutMedia; // include dead-GIF exercises in search
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
      startCountdownSeconds: prefs.getInt('startCountdownSeconds') ?? 5,
      showExercisesWithoutMedia:
          prefs.getBool('showExercisesWithoutMedia') ?? false,
    );
  }

  void setAudioCuesEnabled(bool value) {
    ref.read(sharedPrefsProvider).setBool('audioCuesEnabled', value);
    state = SettingsState(
      audioCuesEnabled: value,
      hapticsEnabled: state.hapticsEnabled,
      defaultRestTime: state.defaultRestTime,
      startCountdownSeconds: state.startCountdownSeconds,
      showExercisesWithoutMedia: state.showExercisesWithoutMedia,
    );
  }

  void setHapticsEnabled(bool value) {
    ref.read(sharedPrefsProvider).setBool('hapticsEnabled', value);
    state = SettingsState(
      audioCuesEnabled: state.audioCuesEnabled,
      hapticsEnabled: value,
      defaultRestTime: state.defaultRestTime,
      startCountdownSeconds: state.startCountdownSeconds,
      showExercisesWithoutMedia: state.showExercisesWithoutMedia,
    );
  }

  void setDefaultRestTime(int seconds) {
    ref.read(sharedPrefsProvider).setInt('defaultRestTime', seconds);
    state = SettingsState(
      audioCuesEnabled: state.audioCuesEnabled,
      hapticsEnabled: state.hapticsEnabled,
      defaultRestTime: seconds,
      startCountdownSeconds: state.startCountdownSeconds,
      showExercisesWithoutMedia: state.showExercisesWithoutMedia,
    );
  }

  void setStartCountdownSeconds(int seconds) {
    ref.read(sharedPrefsProvider).setInt('startCountdownSeconds', seconds);
    state = SettingsState(
      audioCuesEnabled: state.audioCuesEnabled,
      hapticsEnabled: state.hapticsEnabled,
      defaultRestTime: state.defaultRestTime,
      startCountdownSeconds: seconds,
      showExercisesWithoutMedia: state.showExercisesWithoutMedia,
    );
  }

  void setShowExercisesWithoutMedia(bool value) {
    ref.read(sharedPrefsProvider).setBool('showExercisesWithoutMedia', value);
    state = SettingsState(
      audioCuesEnabled: state.audioCuesEnabled,
      hapticsEnabled: state.hapticsEnabled,
      defaultRestTime: state.defaultRestTime,
      startCountdownSeconds: state.startCountdownSeconds,
      showExercisesWithoutMedia: value,
    );
  }
}
