import '../../domain/entities/prayer_time_entity.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../datasources/prayer_times_local_data_source.dart';
import '../datasources/prayer_times_remote_data_source.dart';

class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  PrayerTimesRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
  );

  final PrayerTimesLocalDataSource _localDataSource;
  final PrayerTimesRemoteDataSource _remoteDataSource;

  @override
  Future<List<PrayerTimeEntity>> getTodayPrayerTimes() async {
    try {
      return await _remoteDataSource.getTodayPrayerTimes();
    } catch (_) {
      return _localDataSource.getTodayPrayerTimes();
    }
  }
}
