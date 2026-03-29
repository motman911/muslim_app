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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _HomeSectionTitle(
                title: 'مواقيت اليوم',
                subtitle: 'تابع الصلاة القادمة ووقت الانتظار',
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16).w,
              child: const RepaintBoundary(child: PrayerHeroCard()),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _HomeSectionTitle(
                title: 'إلهام اليوم',
                subtitle: 'آية مختارة مع وصول سريع للحفظ والمشاركة',
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16).w,
              child: const RepaintBoundary(child: AyahOfDayCard()),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _HomeSectionTitle(
                title: 'اختصاراتك',
                subtitle: 'تنقل سريع لأهم أقسام التطبيق',
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16).w,
              child: const RepaintBoundary(child: QuickAccessGrid()),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _HomeSectionTitle(
                title: 'استمرارية القراءة',
                subtitle: 'ارجع مباشرة لآخر موضع وصلت له',
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
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
                  SizedBox(height: 8.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.goldSubtle,
                      borderRadius: BorderRadius.circular(99.r),
                      border: Border.all(color: AppColors.borderActive),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.offline_bolt_rounded,
                          size: 14.sp,
                          color: AppColors.goldPrimary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'جاهز بدون إنترنت',
                          style: AppTextStyles.tiny.copyWith(
                            color: AppColors.goldPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
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

class _HomeSectionTitle extends StatelessWidget {
  const _HomeSectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h3),
        SizedBox(height: 2.h),
        Text(subtitle, style: AppTextStyles.tiny),
      ],
    );
  }
}
