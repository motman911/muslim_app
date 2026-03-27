import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_app/features/prayer_times/domain/entities/prayer_time_entity.dart';
import 'package:muslim_app/features/prayer_times/domain/repositories/prayer_times_repository.dart';
import 'package:muslim_app/features/prayer_times/domain/usecases/get_today_prayer_times_usecase.dart';

class FakePrayerTimesRepository implements PrayerTimesRepository {
  @override
  Future<List<PrayerTimeEntity>> getTodayPrayerTimes() async {
    final now = DateTime.now();
    return [
      PrayerTimeEntity(name: 'Fajr', time: now),
      PrayerTimeEntity(name: 'Dhuhr', time: now),
    ];
  }
}

void main() {
  test('GetTodayPrayerTimesUseCase returns list from repository', () async {
    final useCase = GetTodayPrayerTimesUseCase(FakePrayerTimesRepository());

    final result = await useCase();

    expect(result, hasLength(2));
    expect(result.first.name, 'Fajr');
  });
}
