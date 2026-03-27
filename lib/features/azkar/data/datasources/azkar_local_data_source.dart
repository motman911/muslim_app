import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/zikr_model.dart';

class AzkarLocalDataSource {
  Future<List<ZikrModel>> getAzkar() async {
    final raw =
        await rootBundle.loadString('assets/azkar/morning_evening.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['azkar'] as List<dynamic>;

    return list
        .map((item) => ZikrModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
