import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/models/session.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/repositories/drift_session_repository.dart';
import '../../../shared/theme/ct_colors.dart';

class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({super.key, required this.sessionId});
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(
      _sessionDetailProvider(sessionId),
    );
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sessionDetailTitle)),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (session) {
          if (session == null) {
            return const Center(child: Text('Session not found'));
          }
          return _DetailBody(session: session);
        },
      ),
    );
  }
}

final _sessionDetailProvider = FutureProvider.family<Session?, String>(
  (ref, id) => ref.watch(sessionRepositoryProvider).getById(id),
);

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.session});
  final Session session;

  String _fmtDuration(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('EEEE d MMMM yyyy · HH:mm').format(session.startedAt);
    final isCompleted = session.wasCompleted;
    final ct = Theme.of(context).extension<CTColors>();
    final badgeColor = isCompleted
        ? (ct?.green ?? const Color(0xFF4CAF50))
        : Theme.of(context).colorScheme.onSurfaceVariant;
    final badgeLabel = isCompleted
        ? context.l10n.sessionCompleted
        : context.l10n.sessionAbandoned;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session.workoutNameSnapshot,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            dateLabel,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: badgeColor,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ct?.surface ?? Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _StatRow(
                  label: context.l10n.sessionDetailDuration,
                  value: _fmtDuration(session.totalSeconds),
                  mono: true,
                ),
                Divider(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  height: 20,
                ),
                _StatRow(
                  label: context.l10n.sessionDetailStarted,
                  value: DateFormat('HH:mm').format(session.startedAt),
                  mono: true,
                ),
                Divider(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  height: 20,
                ),
                _StatRow(
                  label: context.l10n.sessionDetailSteps,
                  value: session.stepCount.toString(),
                  mono: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, this.mono = false});
  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: mono ? 'RobotoMono' : null,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
