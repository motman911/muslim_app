import 'package:geolocator/geolocator.dart';

class LocationService {
  /// جلب الموقع الحالي مع تحديد دقة الموقع
  static Future<Position> getCurrentLocation(
      [LocationAccuracy accuracy = LocationAccuracy.best]) async {
    bool serviceEnabled;
    LocationPermission permission;

    // تحقق من تفعيل خدمة الموقع
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمة الموقع غير مفعلة');
    }

    // تحقق من صلاحيات الموقع
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('صلاحيات الموقع مرفوضة');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('صلاحيات الموقع مرفوضة بشكل دائم');
    }

    // جلب الموقع الحالي
    return await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: accuracy,
    );
  }

  /// تحقق من إعدادات الموقع وحصل على الموقع
  static Future<Position> checkLocationSettings(
      [LocationAccuracy accuracy = LocationAccuracy.best]) async {
    try {
      final position = await getCurrentLocation(accuracy);
      return position;
    } catch (e) {
      throw Exception('فشل في الحصول على الموقع: $e');
    }
  }
}
