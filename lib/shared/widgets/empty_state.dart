import 'package:flutter/material.dart';

import '../theme/ct_colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.ctaLabel,
    this.onCta,
  });

  final IconData icon;
  final String message;
  final String? ctaLabel;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    final ct = Theme.of(context).extension<CTColors>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: ct?.elevated ?? Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ct?.surface ?? Colors.grey,
                fontSize: 16,
              ),
            ),
            if (ctaLabel != null && onCta != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onCta,
                child: Text(ctaLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
