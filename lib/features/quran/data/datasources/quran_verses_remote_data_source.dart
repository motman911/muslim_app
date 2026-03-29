import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/ayah_model.dart';

class QuranVersesRemoteDataSource {
  Future<File> _cacheFile(int surahId) async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory('${root.path}/quran_cache');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File('${dir.path}/surah_$surahId.json');
  }

  Future<List<AyahModel>> _decodeAyahs(String body, int surahId) async {
    final decoded = jsonDecode(body) as Map<String, dynamic>;
    final verses = decoded['verses'] as List<dynamic>?;
    if (verses == null) {
      throw Exception('Invalid ayahs response format for surah $surahId.');
    }

    return verses
        .map((item) => AyahModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<AyahModel>> getAyahsBySurah(int surahId) async {
    final uri = Uri.parse(
      'https://api.quran.com/api/v4/quran/verses/uthmani?chapter_number=$surahId',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch ayahs for surah $surahId.');
      }

      final ayahs = await _decodeAyahs(response.body, surahId);
      final file = await _cacheFile(surahId);
      await file.writeAsString(response.body, flush: true);
      return ayahs;
    } catch (_) {
      final file = await _cacheFile(surahId);
      if (await file.exists()) {
        final cached = await file.readAsString();
        return _decodeAyahs(cached, surahId);
      }
      rethrow;
    }
  }
}
