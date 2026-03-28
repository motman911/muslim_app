import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/quran_providers.dart';

class AudioPage extends ConsumerWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final surahsAsync = ref.watch(surahsProvider);
    final audioState = ref.watch(quranAudioControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tr('audio'))),
      body: Column(
        children: [
          Expanded(
            child: surahsAsync.when(
              data: (surahs) {
                return ListView.separated(
                  itemCount: surahs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final surah = surahs[index];
                    final isCurrent = audioState.currentSurahId == surah.id;
                    final isPlayingCurrent = isCurrent && audioState.isPlaying;

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${surah.id}'),
                      ),
                      title: Text(
                        surah.arabicName,
                        style:
                            const TextStyle(fontFamily: 'Amiri', fontSize: 20),
                      ),
                      subtitle:
                          Text('${surah.englishName} • ${surah.ayahCount}'),
                      trailing: IconButton(
                        icon: Icon(
                          isPlayingCurrent
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        onPressed: () {
                          ref
                              .read(quranAudioControllerProvider.notifier)
                              .toggleSurah(surah);
                        },
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
          if (audioState.currentSurahId != null)
            ListTile(
              leading: const Icon(Icons.graphic_eq_rounded),
              title: Text(
                '${l10n.tr('nowPlaying')}: ${audioState.currentSurahName ?? ''}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                onPressed: () {
                  ref.read(quranAudioControllerProvider.notifier).stop();
                },
                icon: const Icon(Icons.stop_circle_rounded),
              ),
            ),
          if (audioState.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                l10n.tr('audioError'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}
