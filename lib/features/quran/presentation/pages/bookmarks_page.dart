import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/providers/firebase_providers.dart';
import '../../../../shared/widgets/noor_card.dart';

final bookmarksProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.watch(bookmarkSyncServiceProvider).fetchBookmarks();
});

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tr('bookmarks')),
      ),
      body: bookmarksAsync.when(
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return Center(child: Text(l10n.tr('noBookmarks')));
          }

          return ListView.separated(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: bookmarks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              final item = bookmarks[index];
              final id = item['id'] as String? ?? '';
              final surah = item['surahNumber']?.toString() ?? '-';
              final ayah = item['ayahNumber']?.toString() ?? '-';
              final type = item['type']?.toString() ?? 'ayah';

              return NoorCard(
                child: Row(
                  children: [
                    const Icon(Icons.bookmark_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${l10n.tr('surah')}: $surah - ${l10n.tr('ayah')}: $ayah',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(type,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () async {
                        await ref
                            .read(bookmarkSyncServiceProvider)
                            .removeBookmark(id);
                        ref.invalidate(bookmarksProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.tr('bookmarkDeleted'))),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }
}
