import 'package:flutter/material.dart';

class AppTheme {
  static const Color _bg = Color(0xFF0F0F0F);
  static const Color _surface = Color(0xFF1A1A1A);
  static const Color _accent = Color(0xFFE8FF00); // CrossFit yellow-green

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _bg,
        colorScheme: const ColorScheme.dark(
          primary: _accent,
          secondary: _accent,
          surface: _surface,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: _surface,
          indicatorColor: Color(0x33E8FF00),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: _surface,
          labelStyle: const TextStyle(fontSize: 12),
          side: BorderSide(color: _accent.withValues(alpha: 0.4)),
        ),
        useMaterial3: true,
      );
}
