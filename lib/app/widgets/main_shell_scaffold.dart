import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShellScaffold extends StatelessWidget {
  const MainShellScaffold({super.key, required this.child});

  final Widget child;

  static const _tabs = <_NavTab>[
    _NavTab(path: '/quran', icon: Icons.menu_book_rounded, label: 'Quran'),
    _NavTab(
      path: '/prayer-times',
      icon: Icons.access_time_filled_rounded,
      label: 'Prayer',
    ),
    _NavTab(path: '/azkar', icon: Icons.favorite_rounded, label: 'Azkar'),
    _NavTab(path: '/qibla', icon: Icons.explore_rounded, label: 'Qibla'),
    _NavTab(path: '/settings', icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex =
        _tabs.indexWhere((tab) => location.startsWith(tab.path));

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex < 0 ? 0 : currentIndex,
        onDestinationSelected: (index) {
          context.go(_tabs[index].path);
        },
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.icon),
                label: tab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.path,
    required this.icon,
    required this.label,
  });

  final String path;
  final IconData icon;
  final String label;
}
