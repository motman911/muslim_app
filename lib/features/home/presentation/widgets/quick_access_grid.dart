import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  static const _items = <_QuickItem>[
    _QuickItem(
      icon: Icons.menu_book_rounded,
      label: 'القرآن',
      sub: 'الصفحة 45',
      route: '/quran',
    ),
    _QuickItem(
      icon: Icons.headphones_rounded,
      label: 'التلاوة',
      sub: 'السديسي',
      route: '/audio',
    ),
    _QuickItem(
      icon: Icons.self_improvement,
      label: 'الاذكار',
      sub: 'اذكار الصباح',
      route: '/azkar',
    ),
    _QuickItem(
      icon: Icons.explore_outlined,
      label: 'القبلة',
      sub: '247.3°',
      route: '/qibla',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: _items.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        return _QuickTile(item: _items[index]);
      },
    );
  }
}

class _QuickTile extends StatefulWidget {
  const _QuickTile({required this.item});

  final _QuickItem item;

  @override
  State<_QuickTile> createState() => _QuickTileState();
}

class _QuickTileState extends State<_QuickTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });
      },
      onTap: () {
        HapticFeedback.lightImpact();
        context.go(widget.item.route);
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 110),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.darkBgSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.item.icon, size: 28, color: AppColors.goldPrimary),
              const Spacer(),
              Text(widget.item.label, style: AppTextStyles.bodyMedium),
              Text(widget.item.sub, style: AppTextStyles.tiny),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickItem {
  const _QuickItem({
    required this.icon,
    required this.label,
    required this.sub,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String sub;
  final String route;
}
