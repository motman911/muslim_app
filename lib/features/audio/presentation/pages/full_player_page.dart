import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [AppColors.goldPrimary, AppColors.goldLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.menu_book_rounded, size: 80),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              audioState.currentSurahName ?? 'لا يوجد تشغيل',
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
            ),
            Text(
              audioState.currentReciterId,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 24),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.goldPrimary,
                inactiveTrackColor: AppColors.darkBgElevated,
                thumbColor: AppColors.goldPrimary,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 3,
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
            const SizedBox(height: 6),
            Text(
              '${_format(position)} / ${_format(duration)}',
              textAlign: TextAlign.center,
              style: AppTextStyles.tiny,
            ),
            const SizedBox(height: 24),
            AudioControls(
              isPlaying: isActuallyPlaying,
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
            ),
            const SizedBox(height: 20),
            NoorCard(
              margin: EdgeInsets.zero,
              child: Text(
                '${l10n.tr('playbackSpeed')}: ${ref.read(quranAudioServiceProvider).player.speed.toStringAsFixed(1)}x  •  ${l10n.tr('sleepTimer')}: ${_sleepRemainingSeconds == 0 ? l10n.tr('disabled') : _formatSleepRemaining(_sleepRemainingSeconds)}',
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
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
