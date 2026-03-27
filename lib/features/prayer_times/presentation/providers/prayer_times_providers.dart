import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/prayer_times_local_data_source.dart';
import '../../data/datasources/prayer_times_remote_data_source.dart';
import '../../data/repositories/prayer_times_repository_impl.dart';
import '../../domain/entities/prayer_time_entity.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../../domain/usecases/get_today_prayer_times_usecase.dart';

final prayerTimesDataSourceProvider = Provider<PrayerTimesLocalDataSource>(
  (ref) => PrayerTimesLocalDataSource(),
);

final prayerTimesRemoteDataSourceProvider =
    Provider<PrayerTimesRemoteDataSource>(
  (ref) => PrayerTimesRemoteDataSource(),
);

final prayerTimesRepositoryProvider = Provider<PrayerTimesRepository>(
  (ref) => PrayerTimesRepositoryImpl(
    ref.watch(prayerTimesDataSourceProvider),
    ref.watch(prayerTimesRemoteDataSourceProvider),
  ),
);

final getTodayPrayerTimesUseCaseProvider = Provider<GetTodayPrayerTimesUseCase>(
  (ref) => GetTodayPrayerTimesUseCase(ref.watch(prayerTimesRepositoryProvider)),
);

final todayPrayerTimesProvider = FutureProvider<List<PrayerTimeEntity>>((ref) {
  return ref.watch(getTodayPrayerTimesUseCaseProvider)();
});

final nextPrayerProvider = Provider<AsyncValue<PrayerTimeEntity?>>((ref) {
  final listAsync = ref.watch(todayPrayerTimesProvider);
  final now = DateTime.now();

  return listAsync.whenData((list) {
    for (final prayer in list) {
      if (prayer.time.isAfter(now)) {
        return prayer;
      }
    }
    return null;
  });
});
