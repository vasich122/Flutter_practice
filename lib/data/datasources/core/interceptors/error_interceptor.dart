import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: Exception('Таймаут соединения. Проверьте интернет-соединение.'),
            type: err.type,
          ),
        );
        return;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode != null) {
          String message;
          switch (statusCode) {
            case 400:
              message = 'Некорректный запрос';
              break;
            case 401:
              message = 'Не авторизован';
              break;
            case 403:
              message = 'Доступ запрещен';
              break;
            case 404:
              message = 'Ресурс не найден';
              break;
            case 429:
              message = 'Слишком много запросов. Попробуйте позже.';
              break;
            case 500:
            case 502:
            case 503:
              message = 'Ошибка сервера. Попробуйте позже.';
              break;
            default:
              message = 'Ошибка при выполнении запроса: $statusCode';
          }
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: Exception(message),
              type: err.type,
              response: err.response,
            ),
          );
          return;
        }
        break;

      case DioExceptionType.cancel:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: Exception('Запрос отменен'),
            type: err.type,
          ),
        );
        return;

      case DioExceptionType.connectionError:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: Exception('Ошибка подключения. Проверьте интернет-соединение.'),
            type: err.type,
          ),
        );
        return;

      default:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: Exception('Неизвестная ошибка: ${err.message}'),
            type: err.type,
          ),
        );
    }
  }
}

