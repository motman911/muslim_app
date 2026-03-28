class AyahModel {
  const AyahModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.juzNumber,
    required this.pageNumber,
  });

  final int surahNumber;
  final int ayahNumber;
  final String text;
  final int juzNumber;
  final int pageNumber;

  factory AyahModel.fromMap(Map<String, dynamic> map) {
    final verseKey = (map['verse_key'] as String?) ?? '1:1';
    final parts = verseKey.split(':');

    return AyahModel(
      surahNumber: int.tryParse(parts.first) ?? 1,
      ayahNumber: parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1,
      text: (map['text_uthmani'] as String?) ?? '',
      juzNumber: (map['juz_number'] as int?) ?? 1,
      pageNumber: (map['page_number'] as int?) ?? 1,
    );
  }
}
