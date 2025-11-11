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
    final base = ThemeData.dark();
    return base.copyWith(
      primaryColor: const Color(0xFF2D5C3F),
      colorScheme: base.colorScheme.copyWith(
        secondary: const Color(0xFFE69A00),
        primary: const Color(0xFF2D5C3F),
      ),
    );
  }
}
