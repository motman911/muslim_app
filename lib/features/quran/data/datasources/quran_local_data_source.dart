import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/surah_model.dart';

class QuranLocalDataSource {
  Future<List<SurahModel>> getSurahs() async {
    final raw = await rootBundle.loadString('assets/quran/surahs.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['surahs'] as List<dynamic>;

    return list
        .map((item) => SurahModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
