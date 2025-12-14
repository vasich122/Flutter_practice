import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final fullUrl = '${options.baseUrl}${options.path}';
    print('REQUEST[${options.method}] => URL: $fullUrl');
    if (options.queryParameters.isNotEmpty) {
      print('   Query Parameters: ${options.queryParameters}');
    }
    if (options.data != null) {
      print('Data: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final fullUrl = '${err.requestOptions.baseUrl}${err.requestOptions.path}';
    print('ERROR[${err.response?.statusCode}] => URL: $fullUrl');
    print('Type: ${err.type}');
    print('Message: ${err.message}');
    if (err.error != null) {
      print('Error: ${err.error}');
    }
    super.onError(err, handler);
  }
}

