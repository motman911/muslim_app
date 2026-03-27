import 'package:flutter/material.dart';

import '../../domain/entities/surah_entity.dart';

class SurahTile extends StatelessWidget {
  const SurahTile({super.key, required this.surah});

  final SurahEntity surah;

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
        trailing: Icon(
          isMakki ? Icons.nights_stay_rounded : Icons.location_city_rounded,
        ),
      ),
    );
  }
}
