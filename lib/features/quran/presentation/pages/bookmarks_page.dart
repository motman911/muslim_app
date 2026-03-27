import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/providers/firebase_providers.dart';

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
            itemCount: bookmarks.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = bookmarks[index];
              final id = item['id'] as String? ?? '';
              final surah = item['surahNumber']?.toString() ?? '-';
              final ayah = item['ayahNumber']?.toString() ?? '-';
              final type = item['type']?.toString() ?? 'ayah';

              return ListTile(
                leading: const Icon(Icons.bookmark_rounded),
                title: Text(
                    '${l10n.tr('surah')}: $surah - ${l10n.tr('ayah')}: $ayah'),
                subtitle: Text(type),
                trailing: IconButton(
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
