import '../../domain/entities/prayer_time_entity.dart';

class PrayerTimesLocalDataSource {
  Future<List<PrayerTimeEntity>> getTodayPrayerTimes() async {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);

    return [
      PrayerTimeEntity(
          name: 'Fajr', time: date.add(const Duration(hours: 5, minutes: 0))),
      PrayerTimeEntity(
          name: 'Dhuhr',
          time: date.add(const Duration(hours: 12, minutes: 15))),
      PrayerTimeEntity(
          name: 'Asr', time: date.add(const Duration(hours: 15, minutes: 45))),
      PrayerTimeEntity(
          name: 'Maghrib',
          time: date.add(const Duration(hours: 18, minutes: 20))),
      PrayerTimeEntity(
          name: 'Isha', time: date.add(const Duration(hours: 19, minutes: 40))),
    ];
  }
}
