import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/prayer_time_entity.dart';

class PrayerTimesRemoteDataSource {
  static const _defaultLat = 21.4225;
  static const _defaultLng = 39.8262;

  Future<List<PrayerTimeEntity>> getTodayPrayerTimes() async {
    final position = await _resolvePosition();
    final now = DateTime.now();

    final uri = Uri.parse(
      'https://api.aladhan.com/v1/timings/${now.day}-${now.month}-${now.year}'
      '?latitude=${position.latitude}&longitude=${position.longitude}&method=4',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load prayer times: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>;
    final timings = data['timings'] as Map<String, dynamic>;

    return [
      _fromTiming(now, 'Fajr', timings['Fajr'] as String),
      _fromTiming(now, 'Dhuhr', timings['Dhuhr'] as String),
      _fromTiming(now, 'Asr', timings['Asr'] as String),
      _fromTiming(now, 'Maghrib', timings['Maghrib'] as String),
      _fromTiming(now, 'Isha', timings['Isha'] as String),
    ];
  }

  PrayerTimeEntity _fromTiming(DateTime date, String name, String rawTime) {
    final normalized = rawTime.split(' ').first.trim();
    final parts = normalized.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return PrayerTimeEntity(
      name: name,
      time: DateTime(date.year, date.month, date.day, hour, minute),
    );
  }

  Future<Position> _resolvePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _defaultPosition();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return _defaultPosition();
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  Position _defaultPosition() {
    return Position(
      longitude: _defaultLng,
      latitude: _defaultLat,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}
