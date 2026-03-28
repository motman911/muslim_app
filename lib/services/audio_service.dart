import 'package:just_audio/just_audio.dart';

class QuranReciter {
  const QuranReciter({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

class QuranAudioService {
  QuranAudioService() : _player = AudioPlayer();

  static const reciters = <QuranReciter>[
    QuranReciter(id: 'ar.alafasy', name: 'مشاري العفاسي'),
    QuranReciter(id: 'ar.abdulbasitmurattal', name: 'عبد الباسط مرتل'),
    QuranReciter(id: 'ar.husary', name: 'الحصري'),
    QuranReciter(id: 'ar.minshawi', name: 'المنشاوي'),
  ];

  final AudioPlayer _player;

  AudioPlayer get player => _player;

  Future<void> playSurah({
    required int surahId,
    String reciter = 'ar.alafasy',
  }) async {
    final url =
        'https://cdn.islamic.network/quran/audio-surah/128/$reciter/$surahId.mp3';
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> pause() => _player.pause();

  Future<void> stop() => _player.stop();

  Future<void> dispose() => _player.dispose();
}
