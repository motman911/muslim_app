import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: highlight ? AppColors.goldSubtle : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              ayah.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'KFGQPCUthmanTahaHafs',
                fontSize: fontSize.sp,
                height: lineHeight,
                color: AppColors.textGold,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
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
