import '../../domain/entities/surah_entity.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_data_source.dart';
import '../datasources/quran_remote_data_source.dart';

class QuranRepositoryImpl implements QuranRepository {
  QuranRepositoryImpl(this._localDataSource, this._remoteDataSource);

  final QuranLocalDataSource _localDataSource;
  final QuranRemoteDataSource _remoteDataSource;

  @override
  Future<List<SurahEntity>> getSurahs() async {
    try {
      final remote = await _remoteDataSource.getSurahs();
      if (remote.isNotEmpty) {
        return remote;
      }
    } catch (_) {
      // Fall back to bundled JSON data when API fails.
    }

    return _localDataSource.getSurahs();
  }
}
