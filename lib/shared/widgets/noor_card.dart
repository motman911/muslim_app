import 'package:flutter/material.dart';

import '../../core/constants/color_scheme.dart';

class NoorCard extends StatelessWidget {
  const NoorCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.highlight = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackgroundSecondary
            : AppColors.lightBackgroundElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight
              ? (isDark ? AppColors.borderActive : AppColors.lightGoldPrimary)
              : (isDark ? AppColors.border : const Color(0x14000000)),
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.40),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                if (highlight)
                  BoxShadow(
                    color: AppColors.goldPrimary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
