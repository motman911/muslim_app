import 'package:just_audio/just_audio.dart';

import 'download_service.dart';

class QuranReciter {
  const QuranReciter({
    required this.id,
    required this.name,
    this.cdnIdentifier,
    this.serverBaseUrl,
  });

  final String id;
  final String name;
  final String? cdnIdentifier;
  final String? serverBaseUrl;
}

class QuranAudioService {
  QuranAudioService({DownloadService? downloadService})
      : _player = AudioPlayer(),
        _downloadService = downloadService ?? DownloadService();

  static const reciters = <QuranReciter>[
    QuranReciter(
      id: 'ar.alafasy',
      name: 'مشاري العفاسي',
      cdnIdentifier: 'ar.alafasy',
    ),
    QuranReciter(
      id: 'ar.abdulbasitmurattal',
      name: 'عبد الباسط مرتل',
      cdnIdentifier: 'ar.abdulbasitmurattal',
    ),
    QuranReciter(
      id: 'ar.husary',
      name: 'الحصري',
      cdnIdentifier: 'ar.husary',
    ),
    QuranReciter(
      id: 'ar.minshawi',
      name: 'المنشاوي',
      cdnIdentifier: 'ar.minshawi',
    ),
    QuranReciter(
      id: 'ar.luhaidan',
      name: 'محمد اللحيدان',
      serverBaseUrl: 'https://server8.mp3quran.net/lhdan/',
    ),
    QuranReciter(
      id: 'ar.yasserad-dossary',
      name: 'ياسر الدوسري',
      serverBaseUrl: 'https://server11.mp3quran.net/yasser/',
    ),
    QuranReciter(
      id: 'ar.alzain',
      name: 'الشيخ الزين محمد أحمد',
      serverBaseUrl: 'https://server9.mp3quran.net/alzain/',
    ),
  ];

  final AudioPlayer _player;
  final DownloadService _downloadService;

  AudioPlayer get player => _player;

  static String resolveSurahUrl({
    required int surahId,
    required String reciterId,
  }) {
    final reciter = reciters.firstWhere(
      (item) => item.id == reciterId,
      orElse: () => reciters.first,
    );

    if (reciter.serverBaseUrl != null) {
      final padded = surahId.toString().padLeft(3, '0');
      return '${reciter.serverBaseUrl}$padded.mp3';
    }

    final cdnId = reciter.cdnIdentifier ?? reciterId;
    return 'https://cdn.islamic.network/quran/audio-surah/128/$cdnId/$surahId.mp3';
  }

  Future<void> playSurah({
    required int surahId,
    String reciter = 'ar.alafasy',
  }) async {
    final localFile = await _downloadService.getAudioFile(
      reciterId: reciter,
      surahId: surahId,
    );

    if (await localFile.exists()) {
      await _player.setFilePath(localFile.path);
      await _player.play();
      return;
    }

    final url = resolveSurahUrl(surahId: surahId, reciterId: reciter);
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> pause() => _player.pause();

  Future<void> stop() => _player.stop();

  Future<void> dispose() => _player.dispose();
}
