import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../services/audio_service.dart';
import '../../../../services/download_service.dart';
import '../../../../shared/widgets/noor_card.dart';
import '../../domain/entities/surah_entity.dart';
import '../providers/quran_providers.dart';

class QuranRecitationsPage extends ConsumerStatefulWidget {
  const QuranRecitationsPage({super.key});

  @override
  ConsumerState<QuranRecitationsPage> createState() =>
      _QuranRecitationsPageState();
}

class _QuranRecitationsPageState extends ConsumerState<QuranRecitationsPage> {
  late String _selectedReciterId;
  String _searchText = '';

  final Set<String> _downloadingKeys = <String>{};
  final Map<String, double> _downloadProgress = <String, double>{};

  bool _isBatchDownloading = false;
  bool _isBatchPaused = false;
  bool _stopBatchRequested = false;
  int _batchTotal = 0;
  int _batchCompleted = 0;
  String _batchCurrentSurahLabel = '';
  double _batchCurrentProgress = 0;
  int _offlineCountRefreshTick = 0;

  @override
  void initState() {
    super.initState();
    _selectedReciterId = QuranAudioService.reciters.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final surahsAsync = ref.watch(surahsProvider);
    final audioState = ref.watch(quranAudioControllerProvider);
    final downloadService = ref.watch(quranDownloadServiceProvider);
    final activeReciter = QuranAudioService.reciters.firstWhere(
      (reciter) => reciter.id == audioState.currentReciterId,
      orElse: () => QuranAudioService.reciters.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tr('audio')),
        actions: [
          IconButton(
            tooltip: l10n.tr('downloadsManagerTitle'),
            onPressed: () {
              context.push('/downloads?reciterId=$_selectedReciterId');
            },
            icon: const Icon(Icons.folder_zip_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          NoorCard(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedReciterId,
                  decoration: InputDecoration(
                    labelText: l10n.tr('reciter'),
                    border: const OutlineInputBorder(),
                  ),
                  items: QuranAudioService.reciters
                      .map(
                        (reciter) => DropdownMenuItem<String>(
                          value: reciter.id,
                          child: Text(reciter.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedReciterId = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchText = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    hintText: l10n.tr('searchSurah'),
                  ),
                ),
                const SizedBox(height: 10),
                surahsAsync.when(
                  data: (surahs) {
                    final filteredSurahs = _filterSurahs(surahs);
                    return Column(
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton.icon(
                              onPressed: _isBatchDownloading
                                  ? null
                                  : () {
                                      _downloadBatch(
                                        context,
                                        filteredSurahs,
                                        downloadService,
                                      );
                                    },
                              icon: const Icon(
                                  Icons.download_for_offline_rounded),
                              label: Text(l10n.tr('downloadFilteredSurahs')),
                            ),
                            FilledButton.icon(
                              onPressed: _isBatchDownloading
                                  ? null
                                  : () {
                                      _downloadFullMushaf(
                                        context,
                                        surahs,
                                        downloadService,
                                      );
                                    },
                              icon: const Icon(Icons.library_books_rounded),
                              label: Text(l10n.tr('downloadFullMushaf')),
                            ),
                            OutlinedButton.icon(
                              onPressed: _isBatchDownloading
                                  ? null
                                  : () {
                                      _clearReciterDownloads(
                                        context,
                                        downloadService,
                                      );
                                    },
                              icon: const Icon(Icons.delete_sweep_rounded),
                              label: Text(l10n.tr('clearReciterDownloads')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder<int>(
                          key: ValueKey('offline_$_offlineCountRefreshTick'),
                          future: downloadService
                              .downloadedCountForReciter(_selectedReciterId),
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${l10n.tr('offlineFilesCount')}: $count',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                  error: (_, __) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          if (_isBatchDownloading)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    minHeight: 8,
                    value: _batchTotal == 0 ? 0 : _batchCompleted / _batchTotal,
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${l10n.tr('batchDownloadProgress')}: $_batchCompleted/$_batchTotal',
                    ),
                  ),
                  if (_batchCurrentSurahLabel.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${l10n.tr('currentDownloadingSurah')}: $_batchCurrentSurahLabel',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${l10n.tr('currentSurahProgress')}: ${(_batchCurrentProgress * 100).toStringAsFixed(0)}%',
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isBatchPaused = !_isBatchPaused;
                            });
                          },
                          icon: Icon(
                            _isBatchPaused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                          ),
                          label: Text(
                            _isBatchPaused
                                ? l10n.tr('resumeBatchDownload')
                                : l10n.tr('pauseBatchDownload'),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _stopBatchRequested
                              ? null
                              : () {
                                  setState(() {
                                    _stopBatchRequested = true;
                                    _isBatchPaused = false;
                                  });
                                },
                          icon: const Icon(Icons.stop_circle_outlined),
                          label: Text(l10n.tr('cancelBatchDownload')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (audioState.isLoading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: surahsAsync.when(
              data: (surahs) {
                final filteredSurahs = _filterSurahs(surahs);
                if (filteredSurahs.isEmpty) {
                  return Center(child: Text(l10n.tr('noResults')));
                }

                return ListView.separated(
                  itemCount: filteredSurahs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final surah = filteredSurahs[index];
                    final isCurrent = audioState.currentSurahId == surah.id;
                    final isPlayingCurrent = isCurrent && audioState.isPlaying;
                    final downloadKey = '${_selectedReciterId}_${surah.id}';
                    final isDownloading =
                        _downloadingKeys.contains(downloadKey);
                    final progress = _downloadProgress[downloadKey] ?? 0;

                    return ListTile(
                      leading: CircleAvatar(child: Text('${surah.id}')),
                      title: Text(
                        surah.arabicName,
                        style:
                            const TextStyle(fontFamily: 'Amiri', fontSize: 20),
                      ),
                      subtitle:
                          Text('${surah.englishName} • ${surah.ayahCount}'),
                      selected: isCurrent,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isDownloading)
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                value: progress > 0 ? progress : null,
                              ),
                            )
                          else
                            FutureBuilder<bool>(
                              future: downloadService.isSurahDownloaded(
                                reciterId: _selectedReciterId,
                                surahId: surah.id,
                              ),
                              builder: (context, snapshot) {
                                final downloaded = snapshot.data ?? false;
                                return IconButton(
                                  icon: Icon(
                                    downloaded
                                        ? Icons.download_done_rounded
                                        : Icons.download_rounded,
                                  ),
                                  tooltip: downloaded
                                      ? l10n.tr('downloadedOffline')
                                      : l10n.tr('downloadForOffline'),
                                  onPressed: downloaded
                                      ? null
                                      : () => _downloadSingleSurah(
                                            context,
                                            downloadService,
                                            surah,
                                          ),
                                );
                              },
                            ),
                          IconButton(
                            icon: Icon(
                              isPlayingCurrent
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                            ),
                            onPressed: audioState.isLoading
                                ? null
                                : () {
                                    ref
                                        .read(quranAudioControllerProvider
                                            .notifier)
                                        .toggleSurah(
                                          surah,
                                          reciterId: _selectedReciterId,
                                        );
                                  },
                          ),
                        ],
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
            NoorCard(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              highlight: true,
              child: ListTile(
                leading: const Icon(Icons.graphic_eq_rounded),
                title: Text(
                  '${l10n.tr('nowPlaying')}: ${audioState.currentSurahName ?? ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('${l10n.tr('reciter')}: ${activeReciter.name}'),
                trailing: IconButton(
                  onPressed: () {
                    ref.read(quranAudioControllerProvider.notifier).stop();
                  },
                  icon: const Icon(Icons.stop_circle_rounded),
                ),
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

  List<SurahEntity> _filterSurahs(List<SurahEntity> surahs) {
    return surahs.where((surah) {
      if (_searchText.isEmpty) {
        return true;
      }
      return surah.arabicName.toLowerCase().contains(_searchText) ||
          surah.englishName.toLowerCase().contains(_searchText);
    }).toList();
  }

  Future<void> _downloadSingleSurah(
    BuildContext context,
    DownloadService downloadService,
    SurahEntity surah,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final key = '${_selectedReciterId}_${surah.id}';

    setState(() {
      _downloadingKeys.add(key);
      _downloadProgress[key] = 0;
    });

    try {
      await downloadService.downloadSurahAudio(
        surahId: surah.id,
        reciterId: _selectedReciterId,
        sourceUrl: QuranAudioService.resolveSurahUrl(
          surahId: surah.id,
          reciterId: _selectedReciterId,
        ),
        onProgress: (value) {
          if (!mounted) {
            return;
          }
          setState(() {
            _downloadProgress[key] = value;
          });
        },
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _offlineCountRefreshTick += 1;
      });
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.tr('downloadCompleted'))),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.tr('downloadFailed'))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _downloadingKeys.remove(key);
        });
      }
    }
  }

  Future<void> _downloadBatch(
    BuildContext context,
    List<SurahEntity> surahs,
    DownloadService downloadService,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    if (surahs.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.tr('noResults'))),
      );
      return;
    }

    setState(() {
      _isBatchDownloading = true;
      _isBatchPaused = false;
      _stopBatchRequested = false;
      _batchTotal = surahs.length;
      _batchCompleted = 0;
      _batchCurrentSurahLabel = '';
      _batchCurrentProgress = 0;
    });

    var failed = 0;
    var wasCanceled = false;

    for (final surah in surahs) {
      while (_isBatchPaused && mounted) {
        await Future<void>.delayed(const Duration(milliseconds: 220));
      }

      if (_stopBatchRequested || !mounted) {
        wasCanceled = _stopBatchRequested;
        break;
      }

      final key = '${_selectedReciterId}_${surah.id}';
      setState(() {
        _downloadingKeys.add(key);
        _downloadProgress[key] = 0;
        _batchCurrentSurahLabel = surah.arabicName;
        _batchCurrentProgress = 0;
      });

      try {
        await downloadService.downloadSurahAudio(
          surahId: surah.id,
          reciterId: _selectedReciterId,
          sourceUrl: QuranAudioService.resolveSurahUrl(
            surahId: surah.id,
            reciterId: _selectedReciterId,
          ),
          onProgress: (value) {
            if (!mounted) {
              return;
            }
            setState(() {
              _downloadProgress[key] = value;
              _batchCurrentProgress = value;
            });
          },
        );
      } catch (_) {
        failed += 1;
      } finally {
        if (mounted) {
          setState(() {
            _downloadingKeys.remove(key);
            _batchCompleted += 1;
          });
        }
      }

      if (!mounted) {
        break;
      }
    }

    if (!mounted) {
      return;
    }

    final successCount = surahs.length - failed;
    setState(() {
      _isBatchDownloading = false;
      _isBatchPaused = false;
      _stopBatchRequested = false;
      _batchCurrentSurahLabel = '';
      _batchCurrentProgress = 0;
      _offlineCountRefreshTick += 1;
    });

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          wasCanceled
              ? '${l10n.tr('batchDownloadCanceled')}: $successCount/${surahs.length}'
              : '${l10n.tr('batchDownloadCompleted')}: $successCount/${surahs.length}',
        ),
      ),
    );
  }

  Future<void> _downloadFullMushaf(
    BuildContext context,
    List<SurahEntity> surahs,
    DownloadService downloadService,
  ) async {
    final allSurahs = [...surahs]..sort((a, b) => a.id.compareTo(b.id));
    await _downloadBatch(context, allSurahs, downloadService);
  }

  Future<void> _clearReciterDownloads(
    BuildContext context,
    DownloadService downloadService,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final deleted =
        await downloadService.clearReciterDownloads(_selectedReciterId);

    if (!mounted) {
      return;
    }

    setState(() {
      _offlineCountRefreshTick += 1;
    });

    messenger.showSnackBar(
      SnackBar(content: Text('${l10n.tr('deletedOfflineFiles')}: $deleted')),
    );
  }
}
