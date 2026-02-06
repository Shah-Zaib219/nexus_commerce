import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors extracted from Nexus Commerce logo
  static const Color _brandCyan = Color(0xFF29C9D6);
  static const Color _brandPurple = Color(0xFF6339A6);
  static const Color _darkBackground = Color(0xFF0F172A);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _brandCyan,
      brightness: Brightness.light,
      primary: _brandCyan,
      secondary: _brandPurple,
      surface: Colors.white,
      onSurface: _darkBackground,
    ),
    scaffoldBackgroundColor: const Color(
      0xFFF8FAFC,
    ), // Slight off-white for modern UI
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: _brandPurple, // Using purple for contrast on light
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _brandCyan,
      brightness: Brightness.dark,
      primary: _brandCyan,
      secondary: _brandPurple,
      surface: const Color(0xFF1E293B), // Modern slate dark
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: _darkBackground,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: _darkBackground,
      foregroundColor: Colors.white,
    ),
  );
}
