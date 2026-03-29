import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../services/audio_service.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../../../quran/domain/entities/surah_entity.dart';
import '../../../quran/presentation/providers/quran_providers.dart';
import '../widgets/audio_controls.dart';

class FullPlayerPage extends ConsumerStatefulWidget {
  const FullPlayerPage({super.key});

  @override
  ConsumerState<FullPlayerPage> createState() => _FullPlayerPageState();
}

class _FullPlayerPageState extends ConsumerState<FullPlayerPage> {
  Timer? _sleepTimer;
  int _sleepRemainingSeconds = 0;

  @override
  void dispose() {
    _sleepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final audioState = ref.watch(quranAudioControllerProvider);
    final playerState = ref.watch(quranAudioPlayerStateProvider).value;
    final shuffleEnabled =
        ref.watch(quranAudioShuffleModeProvider).value ?? false;
    final loopMode =
        ref.watch(quranAudioLoopModeProvider).value ?? LoopMode.off;
    final progress = ref.watch(quranAudioProgressProvider);
    final position =
        ref.watch(quranAudioPositionProvider).value ?? Duration.zero;
    final duration =
        ref.watch(quranAudioDurationProvider).value ?? Duration.zero;
    final surahsAsync = ref.watch(surahsProvider);
    final sortedSurahs = surahsAsync.valueOrNull == null
        ? const <SurahEntity>[]
        : [...surahsAsync.valueOrNull!]
      ..sort((a, b) => a.id.compareTo(b.id));

    final canControl = audioState.currentSurahId != null;
    final isActuallyPlaying = playerState?.playing ?? audioState.isPlaying;
    final reciter = QuranAudioService.reciters.firstWhere(
      (r) => r.id == audioState.currentReciterId,
      orElse: () => QuranAudioService.reciters.first,
    );
    final reciterName = reciter.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tr('audio')),
        actions: [
          IconButton(
            onPressed: canControl
                ? () {
                    ref.read(quranAudioControllerProvider.notifier).stop();
                    Navigator.of(context).maybePop();
                  }
                : null,
            icon: const Icon(Icons.stop_circle_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  gradient: const LinearGradient(
                    colors: [AppColors.goldPrimary, AppColors.goldLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(Icons.menu_book_rounded, size: 80.sp),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              audioState.currentSurahName ?? 'لا يوجد تشغيل',
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
            ),
            Text(
              reciterName,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
            SizedBox(height: 24.h),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.goldPrimary,
                inactiveTrackColor: AppColors.darkBgElevated,
                thumbColor: AppColors.goldPrimary,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                trackHeight: 3.h,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: progress,
                onChanged: canControl
                    ? (value) {
                        final totalMs = duration.inMilliseconds;
                        if (totalMs <= 0) {
                          return;
                        }
                        final next = Duration(
                          milliseconds: (totalMs * value).round(),
                        );
                        ref.read(quranAudioServiceProvider).player.seek(next);
                      }
                    : null,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '${_format(position)} / ${_format(duration)}',
              textAlign: TextAlign.center,
              style: AppTextStyles.tiny,
            ),
            SizedBox(height: 24.h),
            AudioControls(
              isPlaying: isActuallyPlaying,
              isShuffleEnabled: shuffleEnabled,
              isRepeatEnabled: loopMode != LoopMode.off,
              onPlayPause: canControl
                  ? () {
                      ref
                          .read(quranAudioControllerProvider.notifier)
                          .toggleQuick(
                            surahId: audioState.currentSurahId!,
                            surahName: audioState.currentSurahName ??
                                '${audioState.currentSurahId}',
                          );
                    }
                  : null,
              onPrevious: canControl
                  ? () => _playRelativeSurah(
                        delta: -1,
                        currentSurahId: audioState.currentSurahId!,
                        sortedSurahs: sortedSurahs,
                      )
                  : null,
              onNext: canControl
                  ? () => _playRelativeSurah(
                        delta: 1,
                        currentSurahId: audioState.currentSurahId!,
                        sortedSurahs: sortedSurahs,
                      )
                  : null,
              onShuffle: canControl
                  ? () async {
                      final player = ref.read(quranAudioServiceProvider).player;
                      await player.setShuffleModeEnabled(!shuffleEnabled);
                    }
                  : null,
              onRepeat: canControl
                  ? () async {
                      final player = ref.read(quranAudioServiceProvider).player;
                      final nextMode = switch (loopMode) {
                        LoopMode.off => LoopMode.one,
                        LoopMode.one => LoopMode.all,
                        LoopMode.all => LoopMode.off,
                      };
                      await player.setLoopMode(nextMode);
                    }
                  : null,
            ),
            SizedBox(height: 20.h),
            NoorCard(
              margin: EdgeInsets.zero,
              child: Text(
                '${l10n.tr('playbackSpeed')}: ${ref.read(quranAudioServiceProvider).player.speed.toStringAsFixed(1)}x  •  ${l10n.tr('sleepTimer')}: ${_sleepRemainingSeconds == 0 ? l10n.tr('disabled') : _formatSleepRemaining(_sleepRemainingSeconds)}',
              ),
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                OutlinedButton(
                  onPressed: () => _startSleepTimer(minutes: 10),
                  child: Text(l10n.tr('sleep10m')),
                ),
                OutlinedButton(
                  onPressed: () => _startSleepTimer(minutes: 20),
                  child: Text(l10n.tr('sleep20m')),
                ),
                OutlinedButton(
                  onPressed: () => _startSleepTimer(minutes: 30),
                  child: Text(l10n.tr('sleep30m')),
                ),
                TextButton(
                  onPressed:
                      _sleepRemainingSeconds == 0 ? null : _cancelSleepTimer,
                  child: Text(l10n.tr('cancelSleepTimer')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playRelativeSurah({
    required int delta,
    required int currentSurahId,
    required List<SurahEntity> sortedSurahs,
  }) async {
    if (sortedSurahs.isEmpty) {
      return;
    }

    final currentIndex = sortedSurahs.indexWhere((s) => s.id == currentSurahId);
    if (currentIndex < 0) {
      return;
    }

    final nextIndex = (currentIndex + delta) % sortedSurahs.length;
    final wrappedIndex = nextIndex < 0 ? sortedSurahs.length - 1 : nextIndex;
    final target = sortedSurahs[wrappedIndex];

    await ref.read(quranAudioControllerProvider.notifier).toggleQuick(
          surahId: target.id,
          surahName: target.arabicName,
        );
  }

  void _startSleepTimer({required int minutes}) {
    _sleepTimer?.cancel();

    setState(() {
      _sleepRemainingSeconds = minutes * 60;
    });

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_sleepRemainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          _sleepRemainingSeconds = 0;
        });
        ref.read(quranAudioControllerProvider.notifier).stop();
        return;
      }

      setState(() {
        _sleepRemainingSeconds -= 1;
      });
    });
  }

  void _cancelSleepTimer() {
    _sleepTimer?.cancel();
    setState(() {
      _sleepRemainingSeconds = 0;
    });
  }

  String _formatSleepRemaining(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _format(Duration value) {
    final totalSeconds = value.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
