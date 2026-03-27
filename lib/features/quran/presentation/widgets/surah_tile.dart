import 'package:flutter/material.dart';

import '../../domain/entities/surah_entity.dart';

class SurahTile extends StatelessWidget {
  const SurahTile({
    super.key,
    required this.surah,
    required this.onPlayPressed,
    required this.isCurrent,
    required this.isPlaying,
    required this.isLoading,
  });

  final SurahEntity surah;
  final VoidCallback onPlayPressed;
  final bool isCurrent;
  final bool isPlaying;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isMakki = surah.revelationType.toLowerCase() == 'makki';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(surah.id.toString()),
        ),
        title: Text(
          surah.arabicName,
          style: const TextStyle(fontFamily: 'Amiri', fontSize: 22),
        ),
        subtitle: Text('${surah.englishName} - ${surah.ayahCount}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isMakki ? Icons.nights_stay_rounded : Icons.location_city_rounded,
            ),
            const SizedBox(width: 8),
            if (isCurrent && isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
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
