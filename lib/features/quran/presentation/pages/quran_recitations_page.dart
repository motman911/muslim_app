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
                });
              },
            ),
          ),
          if (audioState.isLoading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: surahsAsync.when(
              data: (surahs) {
                return ListView.separated(
                  itemCount: surahs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final surah = surahs[index];
                    final isCurrent = audioState.currentSurahId == surah.id;
                    final isPlayingCurrent = isCurrent && audioState.isPlaying;

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
                      trailing: IconButton(
                        icon: Icon(
                          isPlayingCurrent
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        onPressed: audioState.isLoading
                            ? null
                            : () {
                                ref
                                    .read(quranAudioControllerProvider.notifier)
                                    .toggleSurah(
                                      surah,
                                      reciterId: _selectedReciterId,
                                    );
                              },
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
