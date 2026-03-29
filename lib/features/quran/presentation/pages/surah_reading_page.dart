import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/providers/firebase_providers.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../../data/models/ayah_model.dart';
import '../providers/quran_providers.dart';
import '../widgets/ayah_action_sheet.dart';
import '../widgets/ayah_widget.dart';
import '../widgets/quran_settings_sheet.dart';

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
  int? _highlightedAyah;

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
            onPressed: () => showQuranSettingsSheet(context, ref),
            icon: const Icon(Icons.tune_rounded),
            tooltip: l10n.tr('readingSettings'),
          ),
          IconButton(
            onPressed: ayahs == null || ayahs.isEmpty
                ? null
                : () => _openPageJumpSheet(context, ayahs),
            icon: const Icon(Icons.low_priority_rounded),
            tooltip: l10n.tr('jumpToPage'),
          ),
        ],
      ),
      body: ayahsAsync.when(
        data: (ayahs) {
          if (ayahs.isEmpty) {
            return Center(child: Text(l10n.tr('noResults')));
          }

          final sortedAyahs = [...ayahs]..sort((a, b) {
              final pageComparison = a.pageNumber.compareTo(b.pageNumber);
              if (pageComparison != 0) {
                return pageComparison;
              }
              return a.ayahNumber.compareTo(b.ayahNumber);
            });

          final pageGroups = <int, List<AyahModel>>{};
          for (final ayah in sortedAyahs) {
            pageGroups
                .putIfAbsent(ayah.pageNumber, () => <AyahModel>[])
                .add(ayah);
          }

          final orderedPages = pageGroups.keys.toList()..sort();

          return Column(
            children: [
              NoorCard(
                margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.tr('quickTools'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        Chip(
                          avatar: Icon(Icons.menu_book_rounded, size: 16.sp),
                          label:
                              Text('${l10n.tr('ayah')}: ${sortedAyahs.length}'),
                        ),
                        Chip(
                          avatar: Icon(
                            Icons.auto_stories_rounded,
                            size: 16.sp,
                          ),
                          label: Text(
                              '${l10n.tr('page')}: ${orderedPages.length}'),
                        ),
                        Chip(
                          avatar: Icon(Icons.percent_rounded, size: 16.sp),
                          label: Text(
                            '${l10n.tr('readingProgress')}: ${(_scrollProgress * 100).round()}%',
                          ),
                        ),
                        ActionChip(
                          avatar: Icon(
                            Icons.low_priority_rounded,
                            size: 16.sp,
                          ),
                          label: Text(l10n.tr('jumpToPage')),
                          onPressed: () =>
                              _openPageJumpSheet(context, sortedAyahs),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        minHeight: 8.h,
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
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: orderedPages.length,
                    itemBuilder: (context, index) {
                      final pageNumber = orderedPages[index];
                      final ayahsInPage = pageGroups[pageNumber]!;

                      return NoorCard(
                        margin: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 6.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.auto_stories_rounded, size: 18.sp),
                                SizedBox(width: 6.w),
                                Text(
                                  '${l10n.tr('page')} $pageNumber',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            ...ayahsInPage.map(
                              (ayah) => Padding(
                                padding: EdgeInsets.only(bottom: 14.h),
                                child: AyahWidget(
                                  ayah: ayah,
                                  highlight:
                                      _highlightedAyah == ayah.ayahNumber,
                                  onTap: () async {
                                    setState(() {
                                      _highlightedAyah = ayah.ayahNumber;
                                    });
                                    await _syncLastRead(
                                      ref,
                                      firebaseReady: firebaseReady,
                                      deviceId: deviceId,
                                      ayah: ayah,
                                    );

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${l10n.tr('markAsLastRead')}: ${l10n.tr('ayah')} ${ayah.ayahNumber}',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  onLongPress: () async {
                                    await showAyahActionSheet(
                                      context,
                                      ayah: ayah,
                                      onBookmark: () async {
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
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
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
            padding: EdgeInsets.all(20.r),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _openPageJumpSheet(
    BuildContext context,
    List<AyahModel> ayahs,
  ) async {
    final l10n = context.l10n;
    final pages = ayahs.map((item) => item.pageNumber).toSet().toList()..sort();
    double selectedPageIndex = 0;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.tr('jumpToPage'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '${l10n.tr('page')} ${pages[selectedPageIndex.round()]} (${selectedPageIndex.round() + 1}/${pages.length})',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Slider(
                    min: 0,
                    max: (pages.length - 1).toDouble(),
                    divisions: math.max(pages.length - 1, 1),
                    value: selectedPageIndex,
                    label: pages[selectedPageIndex.round()].toString(),
                    onChanged: (value) {
                      setState(() {
                        selectedPageIndex = value;
                      });
                    },
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _jumpToPage(selectedPageIndex.round(), pages.length);
                      },
                      icon: const Icon(Icons.arrow_downward_rounded),
                      label: Text(l10n.tr('goToSelectedPage')),
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

  Future<void> _jumpToPage(int pageIndex, int totalPages) async {
    if (!_scrollController.hasClients || totalPages <= 1) {
      return;
    }

    final maxExtent = _scrollController.position.maxScrollExtent;
    final perPage = maxExtent / (totalPages - 1);
    final target = (perPage * pageIndex).clamp(0.0, maxExtent);

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
