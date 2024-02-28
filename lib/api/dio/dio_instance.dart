import 'package:dio/dio.dart';
import 'package:task_flow_flutter/api/dio/interceptors/connectivity_interceptor.dart';

// const _backendApi = 'http://10.0.2.2:4040/api/v1'; /* For mobile */
// const _backendApi = 'http://localhost:4040/api/v1';
const _backendApi = 'http://127.0.0.1:4040/api/v1';

class DioInstance {
  static Dio getDio() {
    final Dio dio = Dio();
    dio.options.baseUrl = _backendApi;
    dio.options.connectTimeout = const Duration(minutes: 5);
    dio.options.receiveTimeout = const Duration(minutes: 5);
    dio.options.followRedirects = false;

    dio.interceptors.add(ConnectivityInterceptor());

    return dio;
  }
}
