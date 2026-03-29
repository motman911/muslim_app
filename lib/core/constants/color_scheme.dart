// lib/core/constants/color_scheme.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

export '../theme/app_colors.dart';

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
