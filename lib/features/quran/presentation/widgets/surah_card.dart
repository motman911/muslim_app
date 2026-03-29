import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../../domain/entities/surah_entity.dart';

class SurahCard extends StatelessWidget {
  const SurahCard({
    super.key,
    required this.surah,
    required this.onTap,
    required this.onPlayPressed,
    required this.onLongPress,
    required this.isCurrent,
    required this.isPlaying,
    required this.isLoading,
  });

  final SurahEntity surah;
  final VoidCallback onTap;
  final VoidCallback onPlayPressed;
  final VoidCallback onLongPress;
  final bool isCurrent;
  final bool isPlaying;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isMakki = surah.revelationType.toLowerCase() == 'makki';

    return NoorCard(
      highlight: isCurrent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.goldSubtle,
              child: Text(
                surah.id.toString(),
                style: const TextStyle(color: AppColors.goldPrimary),
              ),
            ),
            const SizedBox(width: 10),
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
                  Text('${surah.englishName} • ${surah.ayahCount}'),
                ],
              ),
            ),
            Icon(
              isMakki ? Icons.nights_stay_rounded : Icons.location_city_rounded,
              size: 18,
            ),
            if (isCurrent && isLoading)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: 22,
                  height: 22,
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
