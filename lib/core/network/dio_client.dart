import 'package:dio/dio.dart';

class DioClient {
  DioClient({Dio? dio}) : _dio = dio ?? Dio(_defaultOptions()) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['accept'] = 'application/json';
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;

  Dio get instance => _dio;

  static BaseOptions _defaultOptions() {
    return BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    );
  }
}
