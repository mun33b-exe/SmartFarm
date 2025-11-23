import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    const primaryColor = Color(0xFF2D5C3F);
    const secondaryColor = Color(0xFFE69A00);
    const backgroundColor = Color(0xFFF9F7F3);
    const surfaceColor = Color(0xFFFFFFFF);
    const charcoal = Color(0xFF2A2A2A);

    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onBackground: charcoal,
        onSurface: charcoal,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: charcoal),
        headlineSmall: TextStyle(color: Color(0xFF5C5C5C)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF5C5C5C),
      ),
    );
  }

  static ThemeData get darkTheme {
    const primaryColor = Color(0xFF2D5C3F);
    const secondaryColor = Color(0xFFE69A00);
    const backgroundColor = Color(0xFF121212);
    const surfaceColor = Color(0xFF1E1E1E);
    const lightTextColor = Color(0xFFEAEAEA);
    final unselectedNavColor = Colors.grey.shade600;

    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onBackground: lightTextColor,
        onSurface: lightTextColor,
        brightness: Brightness.dark,
      ),
      cardTheme: const CardThemeData(color: surfaceColor),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: lightTextColor),
        headlineSmall: TextStyle(color: lightTextColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: unselectedNavColor,
      ),
    );
  }
}
