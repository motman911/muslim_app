// lib/core/themes/app_theme.dart
import 'package:flutter/material.dart';
import '../constants/color_scheme.dart';

class AppTheme {
  // 🌞 الوضع الفاتح
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryGreen,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Lateef',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundLight,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Amiri', color: AppColors.textPrimary),
      bodyMedium:
          TextStyle(fontFamily: 'Amiri', color: AppColors.textSecondary),
      titleLarge: TextStyle(
          fontFamily: 'Lateef', fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  // 🌙 الوضع الداكن
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryGreen,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Lateef',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.darkTextPrimary,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge:
          TextStyle(fontFamily: 'Amiri', color: AppColors.darkTextPrimary),
      bodyMedium:
          TextStyle(fontFamily: 'Amiri', color: AppColors.darkTextSecondary),
      titleLarge: TextStyle(
          fontFamily: 'Lateef', fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
