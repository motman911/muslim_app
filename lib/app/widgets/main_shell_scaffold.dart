import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/color_scheme.dart';
import '../../core/localization/app_localizations.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

class MainShellScaffold extends StatelessWidget {
  const MainShellScaffold({super.key, required this.child});

  final Widget child;

  static const _tabs = <_NavTab>[
    _NavTab(path: '/home', icon: Icons.home_rounded, labelKey: 'home'),
    _NavTab(path: '/quran', icon: Icons.menu_book_rounded, labelKey: 'quran'),
    _NavTab(path: '/audio', icon: Icons.graphic_eq_rounded, labelKey: 'audio'),
    _NavTab(
      path: '/prayer-times',
      icon: Icons.access_time_filled_rounded,
      labelKey: 'prayerTimes',
    ),
    _NavTab(path: '/azkar', icon: Icons.favorite_rounded, labelKey: 'azkar'),
    _NavTab(path: '/qibla', icon: Icons.explore_rounded, labelKey: 'qibla'),
    _NavTab(
      path: '/settings',
      icon: Icons.settings_rounded,
      labelKey: 'settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex =
        _tabs.indexWhere((tab) => location.startsWith(tab.path));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppGradients.primaryGradient
              : const LinearGradient(
                  colors: [Color(0xFFF8FBF8), Color(0xFFEEF4F0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SafeArea(child: child),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.zero,
        child: BottomNavBar(
          items: _tabs
              .map(
                (tab) => BottomNavItem(
                  path: tab.path,
                  icon: tab.icon,
                  label: l10n.tr(tab.labelKey),
                ),
              )
              .toList(),
          currentIndex: currentIndex < 0 ? 0 : currentIndex,
          onTap: (index) {
            context.go(_tabs[index].path);
          },
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.path,
    required this.icon,
    required this.labelKey,
  });

  final String path;
  final IconData icon;
  final String labelKey;
}
