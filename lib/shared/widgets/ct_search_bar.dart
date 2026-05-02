import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/ct_colors.dart';

class CTSearchBar extends StatelessWidget {
  const CTSearchBar({
    super.key,
    required this.onChanged,
    this.controller,
    this.hint = 'Search exercises…',
  });

  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final ct = context.ct;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: const Icon(LucideIcons.search, size: 18, color: Colors.white38),
        suffixIcon: controller != null
            ? ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller!,
                builder: (_, value, __) => value.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: const Icon(LucideIcons.x, size: 16),
                        color: Colors.white54,
                        onPressed: () {
                          controller!.clear();
                          onChanged('');
                        },
                      ),
              )
            : null,
        filled: true,
        fillColor: ct.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      ),
    );
  }
}
