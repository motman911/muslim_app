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
                    return SurahTile(surah: surahs[index]);
                  },
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
