import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/quran_providers.dart';
import '../widgets/surah_tile.dart';

class QuranPage extends ConsumerWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final surahsAsync = ref.watch(filteredSurahsProvider);
    final audioState = ref.watch(quranAudioControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tr('quran')),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) {
                ref.read(surahSearchTextProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: l10n.tr('searchSurah'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.offline_bolt_rounded, size: 18),
                const SizedBox(width: 8),
                Text(l10n.tr('offlineReady')),
              ],
            ),
          ),
          Expanded(
            child: surahsAsync.when(
              data: (surahs) {
                if (surahs.isEmpty) {
                  return Center(child: Text(l10n.tr('noResults')));
                }

                return ListView.builder(
                  itemCount: surahs.length,
                  itemBuilder: (context, index) {
                    final surah = surahs[index];
                    final isCurrent = audioState.currentSurahId == surah.id;

                    return SurahTile(
                      surah: surah,
                      isCurrent: isCurrent,
                      isPlaying: audioState.isPlaying,
                      isLoading: audioState.isLoading,
                      onPlayPressed: () {
                        ref
                            .read(quranAudioControllerProvider.notifier)
                            .toggleSurah(surah);
                      },
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Row(
                children: [
                  const Icon(Icons.graphic_eq_rounded),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${l10n.tr('nowPlaying')}: ${audioState.currentSurahName ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(quranAudioControllerProvider.notifier).stop();
                    },
                    icon: const Icon(Icons.stop_circle_rounded),
                  ),
                ],
              ),
            ),
          if (audioState.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
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
