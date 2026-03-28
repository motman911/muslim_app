import 'package:flutter/material.dart';

import '../../core/constants/color_scheme.dart';

enum NoorButtonStyle { primary, secondary, ghost }

class NoorButton extends StatelessWidget {
  const NoorButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.style = NoorButtonStyle.primary,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final NoorButtonStyle style;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );

    final styleData = switch (style) {
      NoorButtonStyle.primary => ElevatedButton.styleFrom(
          minimumSize: const Size(44, 48),
          backgroundColor:
              isDark ? AppColors.goldPrimary : AppColors.lightGreenPrimary,
          foregroundColor:
              isDark ? AppColors.darkBackgroundPrimary : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      NoorButtonStyle.secondary => ElevatedButton.styleFrom(
          minimumSize: const Size(44, 48),
          backgroundColor: isDark
              ? AppColors.darkBackgroundElevated
              : AppColors.lightBackgroundSecondary,
          foregroundColor:
              isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          side: BorderSide(
            color: isDark ? AppColors.borderActive : AppColors.lightGoldPrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      NoorButtonStyle.ghost => ElevatedButton.styleFrom(
          minimumSize: const Size(44, 44),
          backgroundColor: Colors.transparent,
          foregroundColor:
              isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
    };

    final button = ElevatedButton(
      style: styleData,
      onPressed: onPressed,
      child: buttonChild,
    );

    if (!expanded) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
