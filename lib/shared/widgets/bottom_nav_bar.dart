import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class BottomNavItem {
  const BottomNavItem({
    required this.path,
    required this.icon,
    required this.label,
  });

  final String path;
  final IconData icon;
  final String label;
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<BottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBgSecondary.withValues(alpha: 0.92)
              : Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark
                ? AppColors.border
                : AppColors.lightTextSecondary.withValues(alpha: 0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.32 : 0.10),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: currentIndex < 0 ? 0 : currentIndex,
          onDestinationSelected: onTap,
          destinations: items
              .map(
                (tab) => NavigationDestination(
                  icon: Icon(tab.icon),
                  selectedIcon: Icon(
                    tab.icon,
                    color: isDark ? AppColors.goldPrimary : AppColors.lightGold,
                  ),
                  label: tab.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
