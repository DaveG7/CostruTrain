import 'package:flutter/material.dart';

@immutable
class CTColors extends ThemeExtension<CTColors> {
  const CTColors({
    required this.bg,
    required this.surface,
    required this.elevated,
    required this.accent,
    required this.red,
    required this.amber,
    required this.green,
    required this.blue,
  });

  final Color bg;
  final Color surface;
  final Color elevated;
  final Color accent;
  final Color red;
  final Color amber;
  final Color green;
  final Color blue;

  @override
  CTColors copyWith({
    Color? bg,
    Color? surface,
    Color? elevated,
    Color? accent,
    Color? red,
    Color? amber,
    Color? green,
    Color? blue,
  }) =>
      CTColors(
        bg: bg ?? this.bg,
        surface: surface ?? this.surface,
        elevated: elevated ?? this.elevated,
        accent: accent ?? this.accent,
        red: red ?? this.red,
        amber: amber ?? this.amber,
        green: green ?? this.green,
        blue: blue ?? this.blue,
      );

  @override
  CTColors lerp(CTColors? other, double t) {
    if (other is! CTColors) return this;
    return CTColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      elevated: Color.lerp(elevated, other.elevated, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      red: Color.lerp(red, other.red, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      green: Color.lerp(green, other.green, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
    );
  }

  static const dark = CTColors(
    bg: Color(0xFF0F0F0F),
    surface: Color(0xFF1A1A1A),
    elevated: Color(0xFF242424),
    accent: Color(0xFFE8FF00),
    red: Color(0xFFE84040),
    amber: Color(0xFFF5A623),
    green: Color(0xFF4CAF50),
    blue: Color(0xFF3D8BFF),
  );
}

extension CTColorsX on BuildContext {
  CTColors get ct => Theme.of(this).extension<CTColors>()!;
}
