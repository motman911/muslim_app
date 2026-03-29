import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../services/audio_service.dart';
import '../../../../services/download_service.dart';
import '../../../../services/reading_progress_sync_service.dart';
import '../../data/datasources/quran_local_data_source.dart';
import '../../data/datasources/quran_remote_data_source.dart';
import '../../data/datasources/quran_verses_remote_data_source.dart';
import '../../data/models/ayah_model.dart';
import '../../data/repositories/quran_repository_impl.dart';
import '../../domain/entities/surah_entity.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../domain/usecases/get_surahs_usecase.dart';

final quranLocalDataSourceProvider = Provider<QuranLocalDataSource>(
  (ref) => QuranLocalDataSource(),
);

final quranRemoteDataSourceProvider = Provider<QuranRemoteDataSource>(
  (ref) => QuranRemoteDataSource(),
);

final quranVersesRemoteDataSourceProvider =
    Provider<QuranVersesRemoteDataSource>(
  (ref) => QuranVersesRemoteDataSource(),
);

final quranRepositoryProvider = Provider<QuranRepository>(
  (ref) => QuranRepositoryImpl(
    ref.watch(quranLocalDataSourceProvider),
    ref.watch(quranRemoteDataSourceProvider),
  ),
);

final getSurahsUseCaseProvider = Provider<GetSurahsUseCase>(
  (ref) => GetSurahsUseCase(ref.watch(quranRepositoryProvider)),
);

final surahSearchTextProvider = StateProvider<String>((ref) => '');

final surahsProvider = FutureProvider<List<SurahEntity>>((ref) async {
  final useCase = ref.watch(getSurahsUseCaseProvider);
  return useCase();
});

final surahAyahsProvider =
    FutureProvider.family<List<AyahModel>, int>((ref, surahId) async {
  return ref
      .watch(quranVersesRemoteDataSourceProvider)
      .getAyahsBySurah(surahId);
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
  final service = QuranAudioService(
    downloadService: ref.watch(quranDownloadServiceProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

final quranDownloadServiceProvider = Provider<DownloadService>((ref) {
  return DownloadService();
});

class QuranAudioState {
  const QuranAudioState({
    this.currentSurahId,
    this.currentSurahName,
    this.currentReciterId = 'ar.alafasy',
    this.isPlaying = false,
    this.isLoading = false,
    this.errorMessage,
  });

  final int? currentSurahId;
  final String? currentSurahName;
  final String currentReciterId;
  final bool isPlaying;
  final bool isLoading;
  final String? errorMessage;

  QuranAudioState copyWith({
    int? currentSurahId,
    String? currentSurahName,
    String? currentReciterId,
    bool? isPlaying,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return QuranAudioState(
      currentSurahId: currentSurahId ?? this.currentSurahId,
      currentSurahName: currentSurahName ?? this.currentSurahName,
      currentReciterId: currentReciterId ?? this.currentReciterId,
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

  Future<void> toggleSurah(
    SurahEntity surah, {
    String? reciterId,
  }) async {
    final selectedReciterId = reciterId ?? state.currentReciterId;
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
        currentReciterId: selectedReciterId,
        clearError: true,
      );

      await _audioService.playSurah(
        surahId: surah.id,
        reciter: selectedReciterId,
      );

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
    state = const QuranAudioState(
      currentSurahId: null,
      currentSurahName: null,
      isPlaying: false,
      isLoading: false,
      currentReciterId: 'ar.alafasy',
    );
  }

  Future<void> toggleQuick({
    required int surahId,
    required String surahName,
  }) async {
    if (state.currentSurahId == surahId && state.isPlaying) {
      await _audioService.pause();
      state = state.copyWith(isPlaying: false, clearError: true);
      return;
    }

    try {
      state = state.copyWith(
        isLoading: true,
        currentSurahId: surahId,
        currentSurahName: surahName,
        clearError: true,
      );
      await _audioService.playSurah(
        surahId: surahId,
        reciter: state.currentReciterId,
      );
      state =
          state.copyWith(isPlaying: true, isLoading: false, clearError: true);
    } catch (_) {
      state = state.copyWith(
        isPlaying: false,
        isLoading: false,
        errorMessage: 'Failed to play recitation',
      );
    }
  }
}

final quranAudioControllerProvider =
    StateNotifierProvider<QuranAudioController, QuranAudioState>((ref) {
  return QuranAudioController(ref.watch(quranAudioServiceProvider));
});

final quranAudioPositionProvider = StreamProvider<Duration>((ref) {
  final player = ref.watch(quranAudioServiceProvider).player;
  return player.positionStream;
});

final quranAudioDurationProvider = StreamProvider<Duration?>((ref) {
  final player = ref.watch(quranAudioServiceProvider).player;
  return player.durationStream;
});

final quranAudioPlayerStateProvider = StreamProvider<PlayerState>((ref) {
  final player = ref.watch(quranAudioServiceProvider).player;
  return player.playerStateStream;
});

final quranAudioShuffleModeProvider = StreamProvider<bool>((ref) {
  final player = ref.watch(quranAudioServiceProvider).player;
  return player.shuffleModeEnabledStream;
});

final quranAudioLoopModeProvider = StreamProvider<LoopMode>((ref) {
  final player = ref.watch(quranAudioServiceProvider).player;
  return player.loopModeStream;
});

final quranAudioProgressProvider = Provider<double>((ref) {
  final position = ref.watch(quranAudioPositionProvider).value ?? Duration.zero;
  final duration = ref.watch(quranAudioDurationProvider).value ?? Duration.zero;

  if (duration.inMilliseconds <= 0) {
    return 0;
  }

  final progress = position.inMilliseconds / duration.inMilliseconds;
  return progress.clamp(0, 1);
});

final readingProgressSyncServiceProvider = Provider<ReadingProgressSyncService>(
  (ref) => ReadingProgressSyncService(),
);
