import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Quran font
  static TextStyle quranNormal = const TextStyle(
    fontFamily: 'KFGQPCUthmanTahaHafs',
    fontSize: 22,
    height: 2.2,
    color: AppColors.textGold,
  );

  static TextStyle quranLarge = const TextStyle(
    fontFamily: 'KFGQPCUthmanTahaHafs',
    fontSize: 26,
    height: 2.4,
    color: AppColors.textGold,
  );

  static TextStyle quranSmall = const TextStyle(
    fontFamily: 'KFGQPCUthmanTahaHafs',
    fontSize: 18,
    height: 2.0,
    color: AppColors.textGold,
  );

  // Headings
  static TextStyle h1 = GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h2 = GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle h3 = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle body = GoogleFonts.cairo(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static TextStyle bodyMedium = GoogleFonts.cairo(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static TextStyle caption = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle tiny = GoogleFonts.cairo(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.3,
  );

  // Numbers
  static TextStyle numbers = const TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 15,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.textPrimary,
  );

  static TextStyle countdown = const TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 48,
    fontWeight: FontWeight.w300,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.textPrimary,
    letterSpacing: 4,
  );
}
