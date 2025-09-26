// lib/core/constants/color_scheme.dart
import 'package:flutter/material.dart';

class AppColors {
  // 🔹 الألوان الأساسية
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color secondaryYellow = Color(0xFFFFC107);
  static const Color accentRed = Color(0xFFF44336);

  // 🔹 ألوان النصوص
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);

  // 🔹 ألوان الخلفيات
  static const Color backgroundLight = Color(0xFFFDFDFD);
  static const Color backgroundGrey = Color(0xFFF5F5F5);

  // 🔹 ألوان الوضع الليلي
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // 🔹 ألوان الحالات
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  static Color get primaryYellow => secondaryYellow;
}

class AppGradients {
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF43A047)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFFFC107), Color(0xFFFFB300)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
