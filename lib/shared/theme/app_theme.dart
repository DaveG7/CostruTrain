import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ct_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: CTColors.dark.bg,
        colorScheme: ColorScheme.dark(
          primary: CTColors.dark.accent,
          secondary: CTColors.dark.accent,
          surface: CTColors.dark.surface,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        extensions: const [CTColors.dark],
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: CTColors.dark.surface,
          indicatorColor: CTColors.dark.accent.withValues(alpha: 0.2),
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: CTColors.dark.surface,
          labelStyle: const TextStyle(fontSize: 12),
          side: BorderSide(color: CTColors.dark.accent.withValues(alpha: 0.4)),
        ),
        useMaterial3: true,
      );
}
