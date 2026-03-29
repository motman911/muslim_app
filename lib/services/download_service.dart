import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadService {
  Future<Directory> _audioDirectory() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory('${root.path}/quran_audio');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String _fileName({required String reciterId, required int surahId}) {
    return '${reciterId}_$surahId.mp3'.replaceAll('/', '_');
  }

  Future<File> getAudioFile({
    required String reciterId,
    required int surahId,
  }) async {
    final dir = await _audioDirectory();
    return File(
        '${dir.path}/${_fileName(reciterId: reciterId, surahId: surahId)}');
  }

  Future<bool> isSurahDownloaded({
    required String reciterId,
    required int surahId,
  }) async {
    final file = await getAudioFile(reciterId: reciterId, surahId: surahId);
    return file.exists();
  }

  Future<File> downloadSurahAudio({
    required int surahId,
    required String reciterId,
    String? sourceUrl,
    void Function(double progress)? onProgress,
  }) async {
    final url = Uri.parse(
      sourceUrl ??
          'https://cdn.islamic.network/quran/audio-surah/128/$reciterId/$surahId.mp3',
    );

    final request = http.Request('GET', url);
    final streamedResponse = await request.send();
    if (streamedResponse.statusCode != 200) {
      throw Exception('Failed to download audio for surah $surahId.');
    }

    final file = await getAudioFile(reciterId: reciterId, surahId: surahId);
    if (await file.exists()) {
      await file.delete();
    }

    final sink = file.openWrite();
    final expected = streamedResponse.contentLength ?? 0;
    var received = 0;

    await for (final chunk in streamedResponse.stream) {
      sink.add(chunk);
      received += chunk.length;
      if (expected > 0) {
        onProgress?.call((received / expected).clamp(0, 1));
      }
    }

    await sink.close();
    onProgress?.call(1.0);
    return file;
  }
}
