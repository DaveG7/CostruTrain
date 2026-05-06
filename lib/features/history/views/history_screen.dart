import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../providers/history_notifier.dart';
import '../widgets/session_card.dart';

String _localizeGroupLabel(BuildContext context, String label) {
  return switch (label) {
    'THIS_WEEK' => context.l10n.historyGroupThisWeek,
    'LAST_WEEK' => context.l10n.historyGroupLastWeek,
    _ => label,
  };
}

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(historyNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navHistory)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (groups) {
          if (groups.isEmpty) {
            return Center(
              child: Text(
                context.l10n.historyEmpty,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groups.fold<int>(0, (acc, g) => acc + g.sessions.length + 1),
            itemBuilder: (context, i) {
              int offset = 0;
              for (final group in groups) {
                if (i == offset) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Text(
                      _localizeGroupLabel(context, group.label),
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: 1.6,
                      ),
                    ),
                  );
                }
                offset++;
                final sessionIdx = i - offset;
                if (sessionIdx < group.sessions.length) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SessionCard(session: group.sessions[sessionIdx]),
                  );
                }
                offset += group.sessions.length;
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
