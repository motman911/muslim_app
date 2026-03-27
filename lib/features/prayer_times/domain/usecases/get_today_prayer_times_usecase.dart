import '../entities/prayer_time_entity.dart';
import '../repositories/prayer_times_repository.dart';

class GetTodayPrayerTimesUseCase {
  GetTodayPrayerTimesUseCase(this._repository);

  final PrayerTimesRepository _repository;

  Future<List<PrayerTimeEntity>> call() {
    return _repository.getTodayPrayerTimes();
  }
}
