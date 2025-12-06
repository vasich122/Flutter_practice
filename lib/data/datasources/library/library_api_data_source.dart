import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import '../core/responses/open_library_response.dart';
import 'library_api.dart';
import 'book_dto.dart';

class LibraryApiDataSource {
  final LibraryApi _api;
  static const int _maxResults = 20;

  LibraryApiDataSource({Dio? dio})
      : _api = _createLibraryApi(dio);

  static LibraryApi _createLibraryApi(Dio? dio) {
    // Используем тот же подход, что и в других API - baseUrl в DioClient совпадает с аннотацией
    final dioInstance = dio ?? DioClient(
      baseUrl: 'https://openlibrary.org',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ).dio;
    // Не передаем baseUrl явно, Retrofit использует из аннотации @RestApi
    return LibraryApi(dioInstance);
  }

  Future<List<BookDto>> searchBooks(String query) async {
    return _executeWithRetry(() async {
      final response = await _api.searchBooksRaw(query, _maxResults);
      final data = response.data;
      if (data == null) {
        throw Exception('Пустой ответ от API');
      }
      final openLibraryResponse = OpenLibraryResponse.fromJson(data);
      return openLibraryResponse.docs;
    });
  }

  Future<List<BookDto>> getPopularBooks() async {
    return _executeWithRetry(() async {
      print('📚 Запрос популярных книг: query=mathematics, limit=$_maxResults');
      final response = await _api.getPopularBooksRaw('mathematics', _maxResults);
      print('📚 Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        print('❌ Пустой ответ от API');
        throw Exception('Пустой ответ от API');
      }
      print('📚 Парсинг ответа...');
      final openLibraryResponse = OpenLibraryResponse.fromJson(data);
      print('📚 Найдено книг: ${openLibraryResponse.docs.length}');
      return openLibraryResponse.docs;
    });
  }

  /// Выполняет запрос с автоматическими повторами при временных ошибках
  Future<List<BookDto>> _executeWithRetry(
    Future<List<BookDto>> Function() request, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        return await request();
      } on DioException catch (e) {
        attempt++;
        // Повторяем только при ошибках подключения или таймаутах
        final shouldRetry = e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout;

        if (shouldRetry && attempt < maxRetries) {
          print('⚠️ Попытка $attempt/$maxRetries не удалась, повтор через ${delay.inSeconds}с...');
          await Future.delayed(delay);
          continue;
        }

        print('❌ DioException при запросе к библиотеке:');
        print('   Type: ${e.type}');
        print('   Message: ${e.message}');
        print('   Error: ${e.error}');
        print('   Response: ${e.response?.statusCode}');
        final errorMessage = e.error?.toString() ?? e.message ?? 'Неизвестная ошибка';
        throw Exception('Ошибка при запросе к библиотеке: $errorMessage');
      } catch (e, stackTrace) {
        attempt++;
        if (attempt < maxRetries && e is! DioException) {
          print('⚠️ Попытка $attempt/$maxRetries не удалась, повтор через ${delay.inSeconds}с...');
          await Future.delayed(delay);
          continue;
        }
        print('❌ Exception при запросе к библиотеке: $e');
        print('   StackTrace: $stackTrace');
        throw Exception('Ошибка при запросе к библиотеке: $e');
      }
    }
    throw Exception('Не удалось выполнить запрос к библиотеке после $maxRetries попыток');
  }
}
