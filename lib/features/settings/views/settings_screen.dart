import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../providers/settings_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(context.l10n.settingsAudioCues),
            value: settings.audioCuesEnabled,
            onChanged: (v) =>
                ref.read(settingsNotifierProvider.notifier).setAudioCuesEnabled(v),
          ),
        ],
      ),
    );
  }
}
