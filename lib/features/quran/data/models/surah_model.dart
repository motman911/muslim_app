import '../../domain/entities/surah_entity.dart';

class SurahModel extends SurahEntity {
  const SurahModel({
    required super.id,
    required super.arabicName,
    required super.englishName,
    required super.revelationType,
    required super.ayahCount,
  });

  factory SurahModel.fromMap(Map<String, dynamic> map) {
    return SurahModel(
      id: map['id'] as int,
      arabicName: map['arabic_name'] as String,
      englishName: map['english_name'] as String,
      revelationType: map['revelation_type'] as String,
      ayahCount: map['ayah_count'] as int,
    );
  }
}
