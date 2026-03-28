import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/ayah_model.dart';

class QuranVersesRemoteDataSource {
  Future<List<AyahModel>> getAyahsBySurah(int surahId) async {
    final uri = Uri.parse(
      'https://api.quran.com/api/v4/quran/verses/uthmani?chapter_number=$surahId',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch ayahs for surah $surahId.');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final verses = decoded['verses'] as List<dynamic>?;
    if (verses == null) {
      throw Exception('Invalid ayahs response format.');
    }

    return verses
        .map((item) => AyahModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
