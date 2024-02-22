import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor();

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final Connectivity connectivity = Connectivity();
    var connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 503,
            data: {"message": 'No internet connection'},
          ),
          type: DioExceptionType.connectionError,
        ),
      );
    }

    return handler.next(options);
  }
}
