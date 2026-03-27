// lib/core/themes/app_theme.dart
import 'package:flutter/material.dart';
import '../constants/color_scheme.dart';

class AppTheme {
  static const _radius = 16.0;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: AppColors.primaryGreen,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryGreen,
      secondary: AppColors.secondaryYellow,
      surface: Colors.white,
    ),
    fontFamily: 'Amiri',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.primaryGreen,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Amiri',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryGreen,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide.none,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Color(0x2252B788),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentGreen,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 18),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: AppColors.primaryGreen,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentGreen,
      secondary: AppColors.secondaryYellow,
      surface: AppColors.darkSurface,
    ),
    fontFamily: 'Amiri',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Amiri',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.darkTextPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF13271B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide.none,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      indicatorColor: Color(0x334CAF50),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentGreen,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge:
          TextStyle(fontFamily: 'Amiri', color: AppColors.darkTextPrimary),
      bodyMedium:
          TextStyle(fontFamily: 'Amiri', color: AppColors.darkTextSecondary),
      titleLarge: TextStyle(
          fontFamily: 'Amiri', fontSize: 22, fontWeight: FontWeight.bold),
    ),
  );
}
