import '../../domain/entities/surah_entity.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_data_source.dart';

class QuranRepositoryImpl implements QuranRepository {
  QuranRepositoryImpl(this._localDataSource);

  final QuranLocalDataSource _localDataSource;

  @override
  Future<List<SurahEntity>> getSurahs() async {
    return _localDataSource.getSurahs();
  }
}
