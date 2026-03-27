import '../entities/prayer_time_entity.dart';

abstract class PrayerTimesRepository {
  Future<List<PrayerTimeEntity>> getTodayPrayerTimes();
}
