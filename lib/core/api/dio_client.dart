import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import 'api_interceptors.dart';

class DioClient {
  static DioClient? _instance;
  static Dio? _dio;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio?.interceptors.add(ApiInterceptors());
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio {
    if (_dio == null) {
      _instance = DioClient._internal();
    }
    return _dio!;
  }
}
