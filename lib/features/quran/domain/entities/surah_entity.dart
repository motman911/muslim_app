class SurahEntity {
  const SurahEntity({
    required this.id,
    required this.arabicName,
    required this.englishName,
    required this.revelationType,
    required this.ayahCount,
  });

  final int id;
  final String arabicName;
  final String englishName;
  final String revelationType;
  final int ayahCount;
}
