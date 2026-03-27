import '../entities/surah_entity.dart';

abstract class QuranRepository {
  Future<List<SurahEntity>> getSurahs();
}
