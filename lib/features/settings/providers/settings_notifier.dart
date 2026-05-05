import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/local/shared_prefs_provider.dart';

part 'settings_notifier.g.dart';

class SettingsState {
  const SettingsState({required this.audioCuesEnabled});
  final bool audioCuesEnabled;
}

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsState build() {
    final prefs = ref.read(sharedPrefsProvider);
    return SettingsState(
      audioCuesEnabled: prefs.getBool('audioCuesEnabled') ?? true,
    );
  }

  void setAudioCuesEnabled(bool value) {
    ref.read(sharedPrefsProvider).setBool('audioCuesEnabled', value);
    state = SettingsState(audioCuesEnabled: value);
  }
}
