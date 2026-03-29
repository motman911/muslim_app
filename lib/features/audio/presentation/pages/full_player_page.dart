import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../widgets/audio_controls.dart';

class FullPlayerPage extends StatelessWidget {
  const FullPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [AppColors.goldPrimary, AppColors.goldLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.menu_book_rounded, size: 80),
              ),
            ),
            const SizedBox(height: 20),
            Text('سورة الفاتحة',
                textAlign: TextAlign.center, style: AppTextStyles.h2),
            Text('مشاري راشد العفاسي',
                textAlign: TextAlign.center, style: AppTextStyles.caption),
            const SizedBox(height: 24),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.goldPrimary,
                inactiveTrackColor: AppColors.darkBgElevated,
                thumbColor: AppColors.goldPrimary,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 3,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(value: 0.35, onChanged: (_) {}),
            ),
            const SizedBox(height: 6),
            Text('01:24 / 04:32',
                textAlign: TextAlign.center, style: AppTextStyles.tiny),
            const SizedBox(height: 24),
            const AudioControls(),
            const SizedBox(height: 20),
            const NoorCard(
              margin: EdgeInsets.zero,
              child: Text('سرعة التشغيل: 1.0x  •  مؤقت النوم: غير مفعل'),
            ),
          ],
        ),
      ),
    );
  }
}
