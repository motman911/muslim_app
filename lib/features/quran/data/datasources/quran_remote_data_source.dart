import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/surah_model.dart';

class QuranRemoteDataSource {
  static const _chaptersEndpoint =
      'https://api.quran.com/api/v4/chapters?language=en';

  Future<List<SurahModel>> getSurahs() async {
    final response = await http.get(Uri.parse(_chaptersEndpoint));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch surahs from API.');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final chapters = decoded['chapters'] as List<dynamic>?;

    if (chapters == null) {
      throw Exception('Invalid Quran API response format.');
    }

    return chapters.map((item) {
      final map = item as Map<String, dynamic>;
      final revelationPlace = (map['revelation_place'] as String?) ?? '';

      return SurahModel(
        id: map['id'] as int,
        arabicName: (map['name_arabic'] as String?) ?? '',
        englishName: ((map['translated_name'] as Map<String, dynamic>?)?['name']
                as String?) ??
            ((map['name_simple'] as String?) ?? ''),
        revelationType:
            revelationPlace.toLowerCase() == 'madinah' ? 'madani' : 'makki',
        ayahCount: (map['verses_count'] as int?) ?? 0,
      );
    }).toList();
  }
}
