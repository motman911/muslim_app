import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/providers/firebase_providers.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../../data/models/ayah_model.dart';
import '../providers/quran_providers.dart';

class SurahReadingPage extends ConsumerStatefulWidget {
  const SurahReadingPage({
    super.key,
    required this.surahId,
  });

  final int surahId;

  @override
  ConsumerState<SurahReadingPage> createState() => _SurahReadingPageState();
}

class _SurahReadingPageState extends ConsumerState<SurahReadingPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateReadingProgress);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateReadingProgress)
      ..dispose();
    super.dispose();
  }

  void _updateReadingProgress() {
    if (!_scrollController.hasClients) {
      return;
    }

    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent <= 0) {
      if (_scrollProgress != 0.0) {
        setState(() {
          _scrollProgress = 0.0;
        });
      }
      return;
    }

    final next = (_scrollController.offset / maxExtent).clamp(0.0, 1.0);
    if ((next - _scrollProgress).abs() >= 0.01) {
      setState(() {
        _scrollProgress = next;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ayahsAsync = ref.watch(surahAyahsProvider(widget.surahId));
    final surahsAsync = ref.watch(surahsProvider);
    final firebaseReady = ref.watch(firebaseReadyProvider);
    final deviceId = ref.watch(deviceIdProvider);
    final ayahs = ayahsAsync.valueOrNull;

    final surahName = surahsAsync.maybeWhen(
      data: (surahs) {
        final found = surahs.where((item) => item.id == widget.surahId);
        if (found.isEmpty) {
          return '${l10n.tr('surah')} ${widget.surahId}';
        }
        return found.first.arabicName;
      },
      orElse: () => '${l10n.tr('surah')} ${widget.surahId}',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
        actions: [
          IconButton(
            onPressed: ayahs == null || ayahs.isEmpty
                ? null
                : () => _openAyahJumpSheet(context, ayahs),
            icon: const Icon(Icons.low_priority_rounded),
            tooltip: l10n.tr('jumpToAyah'),
          ),
        ],
      ),
      body: ayahsAsync.when(
        data: (ayahs) {
          if (ayahs.isEmpty) {
            return Center(child: Text(l10n.tr('noResults')));
          }

          return Column(
            children: [
              NoorCard(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.tr('quickTools'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.menu_book_rounded, size: 16),
                          label: Text('${l10n.tr('ayah')}: ${ayahs.length}'),
                        ),
                        Chip(
                          avatar: const Icon(Icons.percent_rounded, size: 16),
                          label: Text(
                            '${l10n.tr('readingProgress')}: ${(_scrollProgress * 100).round()}%',
                          ),
                        ),
                        ActionChip(
                          avatar:
                              const Icon(Icons.low_priority_rounded, size: 16),
                          label: Text(l10n.tr('jumpToAyah')),
                          onPressed: () => _openAyahJumpSheet(context, ayahs),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: _scrollProgress,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(surahAyahsProvider(widget.surahId));
                    await ref.read(surahAyahsProvider(widget.surahId).future);
                  },
                  child: ListView.builder(
                    controller: _scrollController,
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

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${l10n.tr('markAsLastRead')}: ${l10n.tr('ayah')} ${ayah.ayahNumber}',
                                  ),
                                ),
                              );
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
                                  surahNumber: ayah.surahNumber,
                                  ayahNumber: ayah.ayahNumber,
                                );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(l10n.tr('bookmarkSaved'))),
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
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Chip(
                                    label: Text(
                                      '${l10n.tr('ayah')} ${ayah.ayahNumber}',
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      '${l10n.tr('juz')} ${ayah.juzNumber}',
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      '${l10n.tr('page')} ${ayah.pageNumber}',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
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

  Future<void> _openAyahJumpSheet(
    BuildContext context,
    List<AyahModel> ayahs,
  ) async {
    final l10n = context.l10n;
    double selectedAyah = 1;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.tr('jumpToAyah'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.tr('ayah')} ${selectedAyah.round()} / ${ayahs.length}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Slider(
                    min: 1,
                    max: ayahs.length.toDouble(),
                    divisions: math.max(ayahs.length - 1, 1),
                    value: selectedAyah,
                    label: selectedAyah.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        selectedAyah = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _jumpToAyah(selectedAyah.round(), ayahs.length);
                      },
                      icon: const Icon(Icons.arrow_downward_rounded),
                      label: Text(l10n.tr('goToSelectedAyah')),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _jumpToAyah(int ayahNumber, int totalAyahs) async {
    if (!_scrollController.hasClients || totalAyahs <= 1) {
      return;
    }

    final maxExtent = _scrollController.position.maxScrollExtent;
    final perAyah = maxExtent / (totalAyahs - 1);
    final target = (perAyah * (ayahNumber - 1)).clamp(0.0, maxExtent);

    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
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
