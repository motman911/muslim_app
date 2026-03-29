import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../quran/presentation/providers/quran_providers.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../widgets/audio_controls.dart';

class FullPlayerPage extends ConsumerWidget {
  const FullPlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(quranAudioControllerProvider);
    final progress = ref.watch(quranAudioProgressProvider);
    final position =
        ref.watch(quranAudioPositionProvider).value ?? Duration.zero;
    final duration =
        ref.watch(quranAudioDurationProvider).value ?? Duration.zero;
    final canControl = audioState.currentSurahId != null;

    return Scaffold(
      appBar: AppBar(
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
            Text(audioState.currentSurahName ?? 'لا يوجد تشغيل',
                textAlign: TextAlign.center, style: AppTextStyles.h2),
            Text(audioState.currentReciterId,
                textAlign: TextAlign.center, style: AppTextStyles.caption),
            const SizedBox(height: 24),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.goldPrimary,
                inactiveTrackColor: AppColors.darkBgElevated,
                thumbColor: AppColors.goldPrimary,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
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
            Text('${_format(position)} / ${_format(duration)}',
                textAlign: TextAlign.center, style: AppTextStyles.tiny),
            const SizedBox(height: 24),
            AudioControls(
              isPlaying: audioState.isPlaying,
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
            ),
            const SizedBox(height: 20),
            NoorCard(
              margin: EdgeInsets.zero,
              child: Text(
                'سرعة التشغيل: ${ref.read(quranAudioServiceProvider).player.speed.toStringAsFixed(1)}x  •  مؤقت النوم: غير مفعل',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _format(Duration value) {
    final totalSeconds = value.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
