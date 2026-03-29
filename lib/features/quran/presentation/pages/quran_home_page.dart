import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/color_scheme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/providers/firebase_providers.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../providers/quran_providers.dart';
import '../widgets/surah_card.dart';

class QuranHomePage extends ConsumerWidget {
  const QuranHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final surahsAsync = ref.watch(filteredSurahsProvider);
    final audioState = ref.watch(quranAudioControllerProvider);
    final firebaseReady = ref.watch(firebaseReadyProvider);
    final deviceId = ref.watch(deviceIdProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
            tooltip: l10n.tr('bookmarks'),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          NoorCard(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppGradients.heroCardGradient
                    : const LinearGradient(
                        colors: [Color(0xFFEAF5F0), Color(0xFFDDEDE5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.tr('quranHeroTitle'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.tr('quranHeroSubtitle'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: () => context.push('/audio'),
                        icon: const Icon(Icons.play_circle_rounded),
                        label: Text(l10n.tr('openRecitations')),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/bookmarks'),
                        icon: const Icon(Icons.bookmarks_rounded),
                        label: Text(l10n.tr('bookmarks')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          NoorCard(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 10),
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
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: surahs.length,
                    itemBuilder: (context, index) {
                      final surah = surahs[index];
                      final isCurrent = audioState.currentSurahId == surah.id;

                      return SurahCard(
                        surah: surah,
                        onTap: () async {
                          if (firebaseReady && deviceId != null) {
                            await ref
                                .read(readingProgressSyncServiceProvider)
                                .syncLastRead(
                                  surahNumber: surah.id,
                                  ayahNumber: 1,
                                  pageNumber: 1,
                                  juzNumber: 1,
                                  deviceId: deviceId,
                                );
                          }

                          if (context.mounted) {
                            context.push('/quran/surah/${surah.id}');
                          }
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
