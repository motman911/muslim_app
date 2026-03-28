import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/providers/firebase_providers.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../../data/models/ayah_model.dart';
import '../providers/quran_providers.dart';

class SurahReaderPage extends ConsumerWidget {
  const SurahReaderPage({
    super.key,
    required this.surahId,
  });

  final int surahId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ayahsAsync = ref.watch(surahAyahsProvider(surahId));
    final surahsAsync = ref.watch(surahsProvider);
    final firebaseReady = ref.watch(firebaseReadyProvider);
    final deviceId = ref.watch(deviceIdProvider);

    final surahName = surahsAsync.maybeWhen(
      data: (surahs) {
        final found = surahs.where((item) => item.id == surahId);
        if (found.isEmpty) {
          return '${l10n.tr('surah')} $surahId';
        }
        return found.first.arabicName;
      },
      orElse: () => '${l10n.tr('surah')} $surahId',
    );

    return Scaffold(
      appBar: AppBar(title: Text(surahName)),
      body: ayahsAsync.when(
        data: (ayahs) {
          if (ayahs.isEmpty) {
            return Center(child: Text(l10n.tr('noResults')));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(surahAyahsProvider(surahId));
              await ref.read(surahAyahsProvider(surahId).future);
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final ayah = ayahs[index];
                return NoorCard(
                  margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      await _syncLastRead(
                        ref,
                        firebaseReady: firebaseReady,
                        deviceId: deviceId,
                        ayah: ayah,
                      );
                    },
                    onLongPress: () async {
                      if (!firebaseReady) {
                        return;
                      }

                      await ref.read(bookmarkSyncServiceProvider).addBookmark(
                            type: 'ayah',
                            surahNumber: ayah.surahNumber,
                            ayahNumber: ayah.ayahNumber,
                          );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.tr('bookmarkSaved'))),
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ayah.text,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 26,
                            height: 1.9,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Chip(
                                label: Text(
                                    '${l10n.tr('ayah')} ${ayah.ayahNumber}')),
                            const SizedBox(width: 8),
                            Chip(label: Text('Juz ${ayah.juzNumber}')),
                            const SizedBox(width: 8),
                            Chip(label: Text('Page ${ayah.pageNumber}')),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _syncLastRead(
    WidgetRef ref, {
    required bool firebaseReady,
    required String? deviceId,
    required AyahModel ayah,
  }) async {
    if (!firebaseReady || deviceId == null) {
      return;
    }

    await ref.read(readingProgressSyncServiceProvider).syncLastRead(
          surahNumber: ayah.surahNumber,
          ayahNumber: ayah.ayahNumber,
          pageNumber: ayah.pageNumber,
          juzNumber: ayah.juzNumber,
          deviceId: deviceId,
        );
  }
}
