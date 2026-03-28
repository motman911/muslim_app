// lib/core/constants/color_scheme.dart
import 'package:flutter/material.dart';

class AppColors {
  // Dark mode tokens
  static const Color darkBackgroundPrimary = Color(0xFF0A0F0D);
  static const Color darkBackgroundSecondary = Color(0xFF111A14);
  static const Color darkBackgroundElevated = Color(0xFF1A2E20);
  static const Color darkSurface = Color(0xFF1E3326);

  static const Color goldPrimary = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFE8C87A);
  static const Color goldSubtle = Color(0x22C9A84C);

  static const Color greenPrimary = Color(0xFF2ECC71);
  static const Color greenDark = Color(0xFF27AE60);
  static const Color greenSubtle = Color(0x152ECC71);

  static const Color darkTextPrimary = Color(0xFFF5F0E8);
  static const Color darkTextSecondary = Color(0xFFA89880);
  static const Color darkTextMuted = Color(0xFF6B5D4F);

  static const Color border = Color(0x0DFFFFFF);
  static const Color borderActive = Color(0x44C9A84C);
  static const Color divider = Color(0xFF1E3326);

  // Light mode tokens
  static const Color lightBackgroundPrimary = Color(0xFFFAF7F2);
  static const Color lightBackgroundSecondary = Color(0xFFF0EBE3);
  static const Color lightBackgroundElevated = Color(0xFFFFFFFF);

  static const Color lightGoldPrimary = Color(0xFF9B6F2F);
  static const Color lightGreenPrimary = Color(0xFF1A6B3C);

  static const Color lightTextPrimary = Color(0xFF1A0F00);
  static const Color lightTextSecondary = Color(0xFF6B5540);
  static const Color lightTextMuted = Color(0xFFA89070);

  // Compatibility aliases for existing modules
  static const Color primaryGreen = lightGreenPrimary;
  static const Color secondaryYellow = goldPrimary;
  static const Color accentGreen = greenPrimary;
  static const Color accentRed = Color(0xFFD32F2F);

  static const Color textPrimary = lightTextPrimary;
  static const Color textSecondary = lightTextSecondary;
  static const Color textLight = lightTextMuted;

  static const Color backgroundLight = lightBackgroundPrimary;
  static const Color backgroundGrey = lightBackgroundSecondary;

  static const Color darkBackground = darkBackgroundPrimary;

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  static Color get primaryYellow => goldPrimary;
}

class AppGradients {
  static const Gradient primaryGradient = LinearGradient(
    colors: [AppColors.darkBackgroundPrimary, AppColors.darkBackgroundElevated],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient goldOverlayGradient = LinearGradient(
    colors: [AppColors.goldSubtle, Colors.transparent],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient heroCardGradient = LinearGradient(
    colors: [Color(0xFF1A2E20), Color(0xFF111A14)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient secondaryGradient = heroCardGradient;
}
