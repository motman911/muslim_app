import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/noor_card.dart';
import 'widgets/ayah_of_day_card.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/prayer_hero_card.dart';
import 'widgets/quick_access_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _HomeHeader()),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16).w,
              child: const RepaintBoundary(child: PrayerHeroCard()),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16).w,
              child: const RepaintBoundary(child: AyahOfDayCard()),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16).w,
              child: const RepaintBoundary(child: QuickAccessGrid()),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16).w,
              child: const RepaintBoundary(child: ContinueReadingCard()),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.bottom + 92.h,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('اهلا بك في نور', style: AppTextStyles.h2),
                  SizedBox(height: 4.h),
                  Text(
                    'رحلة يومية مع القرآن والاذكار',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            NoorCard(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(10.r),
              child: Icon(
                Icons.notifications_outlined,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
