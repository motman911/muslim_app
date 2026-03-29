import 'dart:async';

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
        _downloadService = downloadService ?? DownloadService() {
    _positionSub = _player.positionStream.listen((position) {
      _lastPosition = position;
    });

    _playerStateSub = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _shouldAutoRecover = false;
        _recoveryAttempts = 0;
      }

      if (state.processingState == ProcessingState.idle &&
          _shouldAutoRecover &&
          !_isRecovering) {
        _attemptAutoRecovery();
      }
    });
  }

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
  static const int _maxRecoveryAttempts = 3;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  String? _activeSource;
  bool _activeSourceIsLocal = false;
  int? _activeSurahId;
  String? _activeReciterId;
  Duration _lastPosition = Duration.zero;
  bool _shouldAutoRecover = false;
  bool _isRecovering = false;
  bool _isManuallyStopped = false;
  int _recoveryAttempts = 0;

  AudioPlayer get player => _player;

  static List<String> resolveSurahCandidateUrls({
    required int surahId,
    required String reciterId,
  }) {
    final reciter = reciters.firstWhere(
      (item) => item.id == reciterId,
      orElse: () => reciters.first,
    );

    if (reciter.serverBaseUrl != null) {
      final padded = surahId.toString().padLeft(3, '0');
      return <String>['${reciter.serverBaseUrl}$padded.mp3'];
    }

    final cdnId = reciter.cdnIdentifier ?? reciterId;
    return <String>[
      'https://cdn.islamic.network/quran/audio-surah/128/$cdnId/$surahId.mp3',
      'https://cdn.islamic.network/quran/audio-surah/64/$cdnId/$surahId.mp3',
    ];
  }

  static String resolveSurahUrl({
    required int surahId,
    required String reciterId,
  }) {
    return resolveSurahCandidateUrls(
      surahId: surahId,
      reciterId: reciterId,
    ).first;
  }

  Future<void> playSurah({
    required int surahId,
    String reciter = 'ar.alafasy',
  }) async {
    _isManuallyStopped = false;
    _shouldAutoRecover = true;
    _recoveryAttempts = 0;
    _lastPosition = Duration.zero;

    final localFile = await _downloadService.getAudioFile(
      reciterId: reciter,
      surahId: surahId,
    );

    if (await localFile.exists()) {
      await _player.setFilePath(localFile.path);
      await _player.play();
      _activeSource = localFile.path;
      _activeSourceIsLocal = true;
      _activeSurahId = surahId;
      _activeReciterId = reciter;
      return;
    }

    final candidateUrls = resolveSurahCandidateUrls(
      surahId: surahId,
      reciterId: reciter,
    );

    Object? lastError;
    for (final url in candidateUrls) {
      try {
        await _player.setUrl(url);
        await _player.play();
        _activeSource = url;
        _activeSourceIsLocal = false;
        _activeSurahId = surahId;
        _activeReciterId = reciter;
        return;
      } catch (error) {
        lastError = error;
      }
    }

    throw lastError ?? Exception('Failed to play recitation');
  }

  Future<void> pause() async {
    _shouldAutoRecover = false;
    await _player.pause();
  }

  Future<void> stop() async {
    _isManuallyStopped = true;
    _shouldAutoRecover = false;
    _recoveryAttempts = 0;
    _lastPosition = Duration.zero;
    _activeSurahId = null;
    _activeReciterId = null;
    await _player.stop();
  }

  bool canResume({required int surahId, required String reciterId}) {
    final hasSource = _activeSource != null;
    final sameTarget =
        _activeSurahId == surahId && _activeReciterId == reciterId;
    return hasSource && sameTarget;
  }

  Future<void> resume() async {
    if (_activeSource == null) {
      return;
    }
    _isManuallyStopped = false;
    _shouldAutoRecover = true;
    await _player.play();
  }

  Future<void> dispose() async {
    await _positionSub?.cancel();
    await _playerStateSub?.cancel();
    await _player.dispose();
  }

  Future<void> _attemptAutoRecovery() async {
    if (_isManuallyStopped || _activeSource == null) {
      return;
    }

    if (_recoveryAttempts >= _maxRecoveryAttempts) {
      _shouldAutoRecover = false;
      return;
    }

    _isRecovering = true;
    _recoveryAttempts += 1;

    try {
      if (_activeSourceIsLocal) {
        await _player.setFilePath(
          _activeSource!,
          initialPosition: _lastPosition,
        );
      } else {
        await _player.setUrl(
          _activeSource!,
          initialPosition: _lastPosition,
        );
      }
      await _player.play();
    } catch (_) {
      // Keep retry attempts bounded to avoid looping forever.
    } finally {
      _isRecovering = false;
    }
  }
}
