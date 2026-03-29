import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/noor_button.dart';
import '../../../../shared/widgets/noor_card.dart';

class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return NoorCard(
      margin: EdgeInsets.zero,
      highlight: true,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('اكمل القراءة', style: AppTextStyles.h3),
                SizedBox(height: 6.h),
                Text(
                  'سورة الكهف - الصفحة 304',
                  style: AppTextStyles.caption,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text('54%', style: AppTextStyles.tiny),
                    SizedBox(width: 6.w),
                    Text('مكتمل', style: AppTextStyles.tiny),
                  ],
                ),
                SizedBox(height: 6.h),
                Container(
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.54,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.goldPrimary,
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 102.w,
            child: NoorButton(
              label: 'متابعة',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => context.push('/quran/surah/18'),
            ),
          ),
        ],
      ),
    );
  }
}
