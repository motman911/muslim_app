import 'package:flutter/material.dart';

import '../../../../core/constants/color_scheme.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../../domain/entities/surah_entity.dart';

class SurahTile extends StatelessWidget {
  const SurahTile({
    super.key,
    required this.surah,
    required this.onPlayPressed,
    required this.onTap,
    required this.onLongPress,
    required this.isCurrent,
    required this.isPlaying,
    required this.isLoading,
  });

  final SurahEntity surah;
  final VoidCallback onPlayPressed;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isCurrent;
  final bool isPlaying;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isMakki = surah.revelationType.toLowerCase() == 'makki';

    return NoorCard(
      highlight: isCurrent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.goldSubtle,
                border: Border.all(color: AppColors.borderActive),
              ),
              child: Text(
                surah.id.toString().padLeft(2, '0'),
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.goldPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.arabicName,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 22,
                      color: AppColors.goldPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${surah.englishName} • ${surah.ayahCount}',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isMakki ? Icons.nights_stay_rounded : Icons.location_city_rounded,
              size: 18,
            ),
            if (isCurrent && isLoading)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              IconButton(
                onPressed: onPlayPressed,
                icon: Icon(
                  isCurrent && isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
