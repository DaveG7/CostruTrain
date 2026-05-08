import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/extensions.dart';
import '../../main.dart';

class DbErrorScreen extends StatelessWidget {
  const DbErrorScreen({super.key, required this.onRetry});
  final VoidCallback onRetry;

  Future<void> _resetAppData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.errorDbResetTitle),
        content: Text(ctx.l10n.errorDbResetBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(ctx.l10n.errorDbResetCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(ctx.l10n.errorDbResetConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    // Delete DB file
    final docsDir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(docsDir.path, 'costrutrain.db'));
    if (await dbFile.exists()) await dbFile.delete();

    // Clear all SharedPreferences flags
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Restart app — triggers onboarding + re-seed
    if (context.mounted) {
      runCostruTrainApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.errorDbHeadline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(context.l10n.seedRetry),
              ),
              const SizedBox(height: 24),
              ExpansionTile(
                title: Text(
                  context.l10n.errorDbAdvanced,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () => _resetAppData(context),
                      child: Text(context.l10n.errorDbReset),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
