import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/noor_card.dart';

class AyahOfDayCard extends StatelessWidget {
  const AyahOfDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return NoorCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.darkBgSecondary, AppColors.darkBg],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.goldPrimary, width: 1),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('اية اليوم', style: AppTextStyles.h3),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('استمع'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
              textAlign: TextAlign.center,
              style: AppTextStyles.quranNormal,
            ),
            const SizedBox(height: 10),
            Text('البقرة - 152', style: AppTextStyles.caption),
            const SizedBox(height: 6),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border_rounded),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
