import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../services/audio_service.dart';
import '../../../../shared/widgets/noor_card.dart';
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
      appBar: AppBar(title: Text(l10n.tr('audio'))),
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
              ],
            ),
          ),
          if (audioState.isLoading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: surahsAsync.when(
              data: (surahs) {
                final filteredSurahs = surahs.where((surah) {
                  if (_searchText.isEmpty) {
                    return true;
                  }

                  return surah.arabicName.toLowerCase().contains(_searchText) ||
                      surah.englishName.toLowerCase().contains(_searchText);
                }).toList();

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
                      leading: CircleAvatar(
                        child: Text('${surah.id}'),
                      ),
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
                                      : () async {
                                          setState(() {
                                            _downloadingKeys.add(downloadKey);
                                            _downloadProgress[downloadKey] = 0;
                                          });

                                          try {
                                            await downloadService
                                                .downloadSurahAudio(
                                              surahId: surah.id,
                                              reciterId: _selectedReciterId,
                                              sourceUrl: QuranAudioService
                                                  .resolveSurahUrl(
                                                surahId: surah.id,
                                                reciterId: _selectedReciterId,
                                              ),
                                              onProgress: (value) {
                                                if (!mounted) {
                                                  return;
                                                }
                                                setState(() {
                                                  _downloadProgress[
                                                      downloadKey] = value;
                                                });
                                              },
                                            );

                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    l10n.tr(
                                                        'downloadCompleted'),
                                                  ),
                                                ),
                                              );
                                            }
                                          } catch (_) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    l10n.tr('downloadFailed'),
                                                  ),
                                                ),
                                              );
                                            }
                                          } finally {
                                            if (mounted) {
                                              setState(() {
                                                _downloadingKeys
                                                    .remove(downloadKey);
                                              });
                                            }
                                          }
                                        },
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
}
