import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';

class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({super.key, required this.sessionId});
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Full implementation in Task 14
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sessionDetailTitle)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
