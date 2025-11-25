import 'package:flutter/material.dart';

/// App-wide theme definitions for light and dark modes.
/// Colours are based on your brand palette:
/// Light Mode:
/// - Primary: Electric Blue (#0066FF)
/// - Secondary: White (#FFFFFF)
/// - Tertiary (Accent): Neon Green (#39FF14)
/// Dark Mode:
/// - Primary: Deep Navy (#000B1E)
/// - Tertiary (Accent): Neon Green (#39FF14)

class AppTheme {
  // Electric Blue
  static const Color primaryBlue = Color(0xFF0066FF);

  // Neon Green Accent
  static const Color neonGreen = Color(0xFF39FF14);

  // Deep Navy (Dark Mode Primary)
  static const Color deepNavy = Color(0xFF000B1E);

  /// Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
    ).copyWith(
      primary: primaryBlue,
      secondary: Colors.white,
      tertiary: neonGreen,
    ),
  );

  /// Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: deepNavy,
      brightness: Brightness.dark,
    ).copyWith(
      primary: deepNavy,
      tertiary: neonGreen,
    ),
  );
}
