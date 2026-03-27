import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/quran_local_data_source.dart';
import '../../data/repositories/quran_repository_impl.dart';
import '../../domain/entities/surah_entity.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../domain/usecases/get_surahs_usecase.dart';

final quranLocalDataSourceProvider = Provider<QuranLocalDataSource>(
  (ref) => QuranLocalDataSource(),
);

final quranRepositoryProvider = Provider<QuranRepository>(
  (ref) => QuranRepositoryImpl(ref.watch(quranLocalDataSourceProvider)),
);

final getSurahsUseCaseProvider = Provider<GetSurahsUseCase>(
  (ref) => GetSurahsUseCase(ref.watch(quranRepositoryProvider)),
);

final surahSearchTextProvider = StateProvider<String>((ref) => '');

final surahsProvider = FutureProvider<List<SurahEntity>>((ref) async {
  final useCase = ref.watch(getSurahsUseCaseProvider);
  return useCase();
});

final filteredSurahsProvider = Provider<AsyncValue<List<SurahEntity>>>((ref) {
  final query = ref.watch(surahSearchTextProvider).trim().toLowerCase();
  final surahsAsync = ref.watch(surahsProvider);

  return surahsAsync.whenData((surahs) {
    if (query.isEmpty) {
      return surahs;
    }

    return surahs.where((surah) {
      return surah.id.toString().contains(query) ||
          surah.arabicName.toLowerCase().contains(query) ||
          surah.englishName.toLowerCase().contains(query);
    }).toList();
  });
});
