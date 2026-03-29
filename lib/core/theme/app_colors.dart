import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // DARK MODE
  static const Color darkBg = Color(0xFF0A0F0D);
  static const Color darkBgSecondary = Color(0xFF111A14);
  static const Color darkBgElevated = Color(0xFF1A2E20);
  static const Color darkSurface = Color(0xFF1E3326);

  // GOLD
  static const Color goldPrimary = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFE8C87A);
  static const Color goldSubtle = Color(0x22C9A84C);

  // GREEN
  static const Color greenPrimary = Color(0xFF2ECC71);
  static const Color greenDark = Color(0xFF27AE60);
  static const Color greenSubtle = Color(0x152ECC71);

  // TEXT - DARK MODE
  static const Color textPrimary = Color(0xFFF5F0E8);
  static const Color textSecondary = Color(0xFFA89880);
  static const Color textMuted = Color(0xFF6B5D4F);
  static const Color textGold = Color(0xFFC9A84C);

  // BORDERS
  static const Color border = Color(0x0DFFFFFF);
  static const Color borderActive = Color(0x44C9A84C);
  static const Color divider = Color(0xFF1E3326);

  // LIGHT MODE
  static const Color lightBg = Color(0xFFFAF7F2);
  static const Color lightBgSecondary = Color(0xFFF0EBE3);
  static const Color lightBgElevated = Color(0xFFFFFFFF);
  static const Color lightGold = Color(0xFF9B6F2F);
  static const Color lightGreen = Color(0xFF1A6B3C);
  static const Color lightTextPrimary = Color(0xFF1A0F00);
  static const Color lightTextSecondary = Color(0xFF6B5540);

  // Compatibility aliases for existing codebase.
  static const Color darkBackgroundPrimary = darkBg;
  static const Color darkBackgroundSecondary = darkBgSecondary;
  static const Color darkBackgroundElevated = darkBgElevated;
  static const Color darkTextPrimary = textPrimary;
  static const Color darkTextSecondary = textSecondary;
  static const Color darkTextMuted = textMuted;

  static const Color lightBackgroundPrimary = lightBg;
  static const Color lightBackgroundSecondary = lightBgSecondary;
  static const Color lightBackgroundElevated = lightBgElevated;
  static const Color lightGoldPrimary = lightGold;
  static const Color lightGreenPrimary = lightGreen;
  static const Color lightTextMuted = lightTextSecondary;

  static const Color primaryGreen = lightGreen;
  static const Color secondaryYellow = goldPrimary;
  static const Color accentGreen = greenPrimary;
  static const Color accentRed = Color(0xFFD32F2F);

  static const Color textLight = lightTextSecondary;
  static const Color backgroundLight = lightBg;
  static const Color backgroundGrey = lightBgSecondary;
  static const Color darkBackground = darkBg;

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  static Color get primaryYellow => goldPrimary;

  static const Color emeraldDeep = Color(0xFF0E5E45);
  static const Color tealMist = Color(0xFF9ED2C1);
  static const Color skyAccent = Color(0xFF67B7E1);
}
