import 'package:dio/dio.dart';
import 'dart:developer';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      "--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}",
    );
    log("Headers: ${options.headers}");
    log("QueryParameters: ${options.queryParameters}");
    if (options.data != null) log("Body: ${options.data}");

    // Add Authorization header if token exists (logic to be connected with AuthRepository later)
    // String? token = await storage.read(key: 'token');
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("<-- ${response.statusCode} ${response.requestOptions.path}");
    log("Response: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("<-- Error ${err.response?.statusCode} ${err.requestOptions.path}");
    log("Message: ${err.message}");
    log("Error Data: ${err.response?.data}");
    super.onError(err, handler);
  }
}
