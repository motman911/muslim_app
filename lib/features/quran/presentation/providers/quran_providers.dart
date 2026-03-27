import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/audio_service.dart';
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

final quranAudioServiceProvider = Provider<QuranAudioService>((ref) {
  final service = QuranAudioService();
  ref.onDispose(service.dispose);
  return service;
});

class QuranAudioState {
  const QuranAudioState({
    this.currentSurahId,
    this.currentSurahName,
    this.isPlaying = false,
    this.isLoading = false,
    this.errorMessage,
  });

  final int? currentSurahId;
  final String? currentSurahName;
  final bool isPlaying;
  final bool isLoading;
  final String? errorMessage;

  QuranAudioState copyWith({
    int? currentSurahId,
    String? currentSurahName,
    bool? isPlaying,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return QuranAudioState(
      currentSurahId: currentSurahId ?? this.currentSurahId,
      currentSurahName: currentSurahName ?? this.currentSurahName,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class QuranAudioController extends StateNotifier<QuranAudioState> {
  QuranAudioController(this._audioService)
      : super(const QuranAudioState(isPlaying: false));

  final QuranAudioService _audioService;

  Future<void> toggleSurah(SurahEntity surah) async {
    final isCurrent = state.currentSurahId == surah.id;

    if (isCurrent && state.isPlaying) {
      await _audioService.pause();
      state = state.copyWith(isPlaying: false, clearError: true);
      return;
    }

    try {
      state = state.copyWith(
        isLoading: true,
        currentSurahId: surah.id,
        currentSurahName: surah.arabicName,
        clearError: true,
      );

      await _audioService.playSurah(surahId: surah.id);

      state = state.copyWith(
        isLoading: false,
        isPlaying: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isPlaying: false,
        errorMessage: 'Failed to play recitation',
      );
    }
  }

  Future<void> stop() async {
    await _audioService.stop();
    state = state.copyWith(isPlaying: false, clearError: true);
  }
}

final quranAudioControllerProvider =
    StateNotifierProvider<QuranAudioController, QuranAudioState>((ref) {
  return QuranAudioController(ref.watch(quranAudioServiceProvider));
});
