// lib/core/constants/color_scheme.dart
import 'package:flutter/material.dart';

class AppColors {
  // Dark mode tokens
  static const Color darkBackgroundPrimary = Color(0xFF07110E);
  static const Color darkBackgroundSecondary = Color(0xFF0F1F1A);
  static const Color darkBackgroundElevated = Color(0xFF173128);
  static const Color darkSurface = Color(0xFF1B3A2E);

  static const Color goldPrimary = Color(0xFFD5B35A);
  static const Color goldLight = Color(0xFFF0D48B);
  static const Color goldSubtle = Color(0x26D5B35A);

  static const Color greenPrimary = Color(0xFF2FBF7A);
  static const Color greenDark = Color(0xFF1F9E62);
  static const Color greenSubtle = Color(0x1E2FBF7A);

  static const Color emeraldDeep = Color(0xFF0E5E45);
  static const Color tealMist = Color(0xFF9ED2C1);
  static const Color skyAccent = Color(0xFF67B7E1);

  static const Color darkTextPrimary = Color(0xFFF4F8F3);
  static const Color darkTextSecondary = Color(0xFFB3C6BD);
  static const Color darkTextMuted = Color(0xFF7F9A8E);

  static const Color border = Color(0x0DFFFFFF);
  static const Color borderActive = Color(0x52D5B35A);
  static const Color divider = Color(0xFF214437);

  // Light mode tokens
  static const Color lightBackgroundPrimary = Color(0xFFF8FBF8);
  static const Color lightBackgroundSecondary = Color(0xFFEFF5F1);
  static const Color lightBackgroundElevated = Color(0xFFFFFFFF);

  static const Color lightGoldPrimary = Color(0xFF916225);
  static const Color lightGreenPrimary = Color(0xFF176441);

  static const Color lightTextPrimary = Color(0xFF11231C);
  static const Color lightTextSecondary = Color(0xFF4F665D);
  static const Color lightTextMuted = Color(0xFF7C958A);

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
    colors: [
      AppColors.darkBackgroundPrimary,
      AppColors.darkBackgroundElevated,
      AppColors.emeraldDeep,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient goldOverlayGradient = LinearGradient(
    colors: [AppColors.goldSubtle, Colors.transparent],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient heroCardGradient = LinearGradient(
    colors: [Color(0xFF1A3C2F), Color(0xFF102720)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF2F6C5D), Color(0xFF17463A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient warmAccentGradient = LinearGradient(
    colors: [Color(0xFFD5B35A), Color(0xFFB7862F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient coolAccentGradient = LinearGradient(
    colors: [Color(0xFF86C7E9), Color(0xFF4D92C2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
