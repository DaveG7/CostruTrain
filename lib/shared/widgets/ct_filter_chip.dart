import 'package:flutter/material.dart';

import '../theme/ct_colors.dart';

class CTFilterChip extends StatelessWidget {
  const CTFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    final ct = context.ct;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: ct.surface,
      selectedColor: ct.accent,
      checkmarkColor: ct.bg,
      labelStyle: TextStyle(
        fontSize: 12,
        color: selected ? ct.bg : Colors.white70,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: selected ? ct.accent : ct.elevated,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      showCheckmark: false,
    );
  }
}
