import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/extensions.dart';
import '../providers/settings_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(context.l10n.settingsAudioCues),
            value: state.audioCuesEnabled,
            onChanged: notifier.setAudioCuesEnabled,
          ),
          SwitchListTile(
            title: Text(context.l10n.settingsHaptics),
            value: state.hapticsEnabled,
            onChanged: notifier.setHapticsEnabled,
          ),
          ListTile(
            title: Text(context.l10n.settingsDefaultRestTime),
            subtitle: Text(
              context.l10n.settingsDefaultRestTimeValue(state.defaultRestTime),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Slider(
              value: state.defaultRestTime.toDouble(),
              min: 10,
              max: 180,
              divisions: 34, // (180 - 10) / 5 = 34 steps of 5 seconds
              label: context.l10n.settingsDefaultRestTimeValue(state.defaultRestTime),
              onChanged: (v) => notifier.setDefaultRestTime(v.round()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(context.l10n.settingsExportData),
            onTap: () => _exportDb(context),
          ),
        ],
      ),
    );
  }
}

Future<void> _exportDb(BuildContext context) async {
  // path_provider's application-documents directory (and therefore a
  // sharable local DB file path) doesn't exist on web — the database
  // lives in browser storage instead. Fixing this properly requires
  // exporting the WASM-backed DB's bytes, not just guarding the call, so
  // for now give an honest heads-up instead of silently doing nothing.
  if (kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.settingsExportNotSupportedOnWeb)),
    );
    return;
  }
  try {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(docsDir.path, 'costrutrain.db');
    await SharePlus.instance.share(
      ShareParams(files: [XFile(dbPath)]),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.settingsExportSuccess)),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.settingsExportFailed)),
      );
    }
  }
}
