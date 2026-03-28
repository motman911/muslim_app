import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/color_scheme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/providers/firebase_providers.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../providers/quran_providers.dart';
import '../widgets/surah_tile.dart';

class QuranPage extends ConsumerWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final surahsAsync = ref.watch(filteredSurahsProvider);
    final audioState = ref.watch(quranAudioControllerProvider);
    final firebaseReady = ref.watch(firebaseReadyProvider);
    final deviceId = ref.watch(deviceIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tr('quran')),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(surahsProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.tr('quranRefreshed'))),
              );
            },
            icon: const Icon(Icons.sync_rounded),
            tooltip: l10n.tr('refreshQuran'),
          ),
          IconButton(
            onPressed: () => context.push('/bookmarks'),
            icon: const Icon(Icons.bookmarks_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          NoorCard(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    ref.read(surahSearchTextProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    hintText: l10n.tr('searchSurah'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.greenPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.tr('offlineReady')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: surahsAsync.when(
              data: (surahs) {
                if (surahs.isEmpty) {
                  return Center(child: Text(l10n.tr('noResults')));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(surahsProvider);
                    await ref.read(surahsProvider.future);
                  },
                  child: ListView.builder(
                    itemCount: surahs.length,
                    itemBuilder: (context, index) {
                      final surah = surahs[index];
                      final isCurrent = audioState.currentSurahId == surah.id;

                      return SurahTile(
                        surah: surah,
                        onTap: () async {
                          if (!firebaseReady || deviceId == null) {
                            return;
                          }

                          await ref
                              .read(readingProgressSyncServiceProvider)
                              .syncLastRead(
                                surahNumber: surah.id,
                                ayahNumber: 1,
                                pageNumber: 1,
                                juzNumber: 1,
                                deviceId: deviceId,
                              );
                        },
                        onLongPress: () async {
                          if (!firebaseReady) {
                            return;
                          }

                          await ref
                              .read(bookmarkSyncServiceProvider)
                              .addBookmark(
                                type: 'ayah',
                                surahNumber: surah.id,
                                ayahNumber: 1,
                              );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.tr('bookmarkSaved'))),
                            );
                          }
                        },
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
                  ),
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
          if (audioState.currentSurahId != null)
            NoorCard(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              highlight: true,
              child: Row(
                children: [
                  const Icon(Icons.graphic_eq_rounded,
                      color: AppColors.goldPrimary),
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
