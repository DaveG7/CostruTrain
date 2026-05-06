import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/session.dart';
import '../../../core/utils/extensions.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session});
  final Session session;

  String _fmtDuration(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String _fmtDate(DateTime dt) =>
      DateFormat('EEE d MMM yyyy · HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/history/${session.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: const Color(0xFF2E2E2E)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    session.workoutNameSnapshot,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StatusChip(completed: session.wasCompleted),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _fmtDate(session.startedAt),
              style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer_outlined,
                    size: 14, color: Color(0xFF9E9E9E)),
                const SizedBox(width: 4),
                Text(
                  _fmtDuration(session.totalSeconds),
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 14),
                const Icon(Icons.format_list_numbered,
                    size: 14, color: Color(0xFF9E9E9E)),
                const SizedBox(width: 4),
                Text(
                  context.l10n.sessionSteps(session.stepCount),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.completed});
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final color =
        completed ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E);
    final label = completed
        ? context.l10n.sessionCompleted
        : context.l10n.sessionAbandoned;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
