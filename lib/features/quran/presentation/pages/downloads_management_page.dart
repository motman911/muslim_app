import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../services/audio_service.dart';
import '../../../../services/download_service.dart';
import '../../../../shared/widgets/noor_card.dart';

class DownloadsManagementPage extends StatefulWidget {
  const DownloadsManagementPage({
    super.key,
    this.initialReciterId,
  });

  final String? initialReciterId;

  @override
  State<DownloadsManagementPage> createState() =>
      _DownloadsManagementPageState();
}

class _DownloadsManagementPageState extends State<DownloadsManagementPage> {
  late String _selectedReciterId;
  final DownloadService _downloadService = DownloadService();
  String _searchText = '';
  int _refreshTick = 0;

  @override
  void initState() {
    super.initState();
    _selectedReciterId =
        widget.initialReciterId ?? QuranAudioService.reciters.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tr('downloadsManagerTitle'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          NoorCard(
            margin: EdgeInsets.zero,
            child: DropdownButtonFormField<String>(
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
                  _refreshTick += 1;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          NoorCard(
            margin: EdgeInsets.zero,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value.trim();
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: l10n.tr('searchDownloadedFiles'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<DownloadedAudioFile>>(
            key: ValueKey('downloads_$_selectedReciterId$_refreshTick'),
            future: _downloadService.listReciterDownloads(_selectedReciterId),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              final files = snapshot.data ?? <DownloadedAudioFile>[];
              final filteredFiles = _filterFiles(files);
              if (filteredFiles.isEmpty) {
                return NoorCard(
                  margin: EdgeInsets.zero,
                  child: Text(
                    files.isEmpty
                        ? l10n.tr('noOfflineFiles')
                        : l10n.tr('noMatchingDownloads'),
                  ),
                );
              }

              final totalSize = filteredFiles.fold<int>(
                  0, (sum, item) => sum + item.sizeBytes);

              return Column(
                children: [
                  NoorCard(
                    margin: EdgeInsets.zero,
                    highlight: true,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${l10n.tr('offlineFilesCount')}: ${filteredFiles.length}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          '${l10n.tr('storageUsed')}: ${_formatBytes(totalSize)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...filteredFiles.map(
                    (item) => NoorCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(child: Text('${item.surahId}')),
                        title: Text('${l10n.tr('surah')} ${item.surahId}'),
                        subtitle: Text(
                          '${_formatBytes(item.sizeBytes)} • ${_formatDate(item.modifiedAt)}',
                        ),
                        trailing: IconButton(
                          tooltip: l10n.tr('deleteFile'),
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () async {
                            final deleted =
                                await _downloadService.deleteSingleDownload(
                              reciterId: _selectedReciterId,
                              surahId: item.surahId,
                            );

                            if (!context.mounted) {
                              return;
                            }

                            if (deleted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${l10n.tr('deletedOfflineFiles')}: 1',
                                  ),
                                ),
                              );
                              setState(() {
                                _refreshTick += 1;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    final kb = bytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    }
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)}';
  }

  List<DownloadedAudioFile> _filterFiles(List<DownloadedAudioFile> files) {
    if (_searchText.isEmpty) {
      return files;
    }

    final needle = _searchText.toLowerCase();
    return files.where((item) {
      return item.surahId.toString().contains(needle) ||
          '${context.l10n.tr('surah')} ${item.surahId}'
              .toLowerCase()
              .contains(needle);
    }).toList();
  }
}
