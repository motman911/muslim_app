import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/ayah_model.dart';

class AyahWidget extends StatelessWidget {
  const AyahWidget({
    super.key,
    required this.ayah,
    required this.onTap,
    required this.onLongPress,
    this.highlight = false,
    this.fontSize = 22,
    this.lineHeight = 2.2,
  });

  final AyahModel ayah;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool highlight;
  final double fontSize;
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: highlight ? AppColors.goldSubtle : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              ayah.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'KFGQPCUthmanTahaHafs',
                fontSize: fontSize,
                height: lineHeight,
                color: AppColors.textGold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('آية ${ayah.ayahNumber}')),
                Chip(label: Text('جزء ${ayah.juzNumber}')),
                Chip(label: Text('صفحة ${ayah.pageNumber}')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
