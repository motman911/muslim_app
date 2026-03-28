// lib/core/themes/app_theme.dart
import 'package:flutter/material.dart';
import '../constants/color_scheme.dart';

class AppTheme {
  static const _radius = 16.0;
  static const _largeRadius = 24.0;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: AppColors.lightGreenPrimary,
    scaffoldBackgroundColor: AppColors.lightBackgroundPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightGreenPrimary,
      secondary: AppColors.lightGoldPrimary,
      surface: AppColors.lightBackgroundElevated,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
      error: AppColors.error,
    ),
    fontFamily: 'Amiri',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Amiri',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.lightTextPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightBackgroundElevated,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
        side: const BorderSide(color: Color(0x0F000000)),
      ),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightBackgroundSecondary,
      hintStyle: const TextStyle(color: AppColors.lightTextMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: Color(0x12000000)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: Color(0x12000000)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: AppColors.lightGoldPrimary),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightBackgroundElevated,
      indicatorColor: AppColors.lightGoldPrimary.withValues(alpha: 0.12),
      shadowColor: Colors.black12,
      elevation: 8,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightGoldPrimary,
      foregroundColor: Colors.white,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.lightTextPrimary,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
      headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: AppColors.greenPrimary,
    scaffoldBackgroundColor: AppColors.darkBackgroundPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.greenPrimary,
      secondary: AppColors.goldPrimary,
      surface: AppColors.darkSurface,
      onPrimary: AppColors.darkBackgroundPrimary,
      onSecondary: AppColors.darkBackgroundPrimary,
      onSurface: AppColors.darkTextPrimary,
      error: Color(0xFFEF5350),
    ),
    fontFamily: 'Amiri',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Amiri',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.darkTextPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkBackgroundSecondary,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
        side: const BorderSide(color: AppColors.border),
      ),
      elevation: 0,
      shadowColor: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkBackgroundSecondary,
      hintStyle: const TextStyle(color: AppColors.darkTextMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: AppColors.borderActive),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor:
          AppColors.darkBackgroundSecondary.withValues(alpha: 0.96),
      indicatorColor: AppColors.goldSubtle,
      shadowColor: Colors.black.withValues(alpha: 0.45),
      elevation: 16,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.goldPrimary,
      foregroundColor: AppColors.darkBackgroundPrimary,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.darkBackgroundElevated,
      contentTextStyle: const TextStyle(color: AppColors.darkTextPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dividerColor: AppColors.divider,
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontFamily: 'Amiri',
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.darkTextPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Amiri',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.darkTextPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Amiri',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.darkTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Amiri',
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Amiri',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.darkTextSecondary,
      ),
    ),
  );

  static BorderRadius get sectionRadius =>
      const BorderRadius.all(Radius.circular(_largeRadius));
}
