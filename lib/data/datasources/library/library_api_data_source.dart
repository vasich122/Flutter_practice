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
    final dioInstance = dio ?? DioClient(
      baseUrl: 'https://openlibrary.org',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ).dio;
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
      print('Запрос популярных книг: query=mathematics, limit=$_maxResults');
      final response = await _api.getPopularBooksRaw('mathematics', _maxResults);
      print('Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        print('Пустой ответ от API');
        throw Exception('Пустой ответ от API');
      }
      print('Парсинг ответа...');
      final openLibraryResponse = OpenLibraryResponse.fromJson(data);
      print('Найдено книг: ${openLibraryResponse.docs.length}');
      return openLibraryResponse.docs;
    });
  }

  // 1. Получение детальной информации о книге по ключу
  Future<BookDto?> getBookByKey(String key) async {
    return _executeWithRetrySingle(() async {
      // Убираем префикс /works/ и расширение .json если они есть
      String cleanKey = key.replaceAll('/works/', '').replaceAll('works/', '').replaceAll('.json', '');
      
      print('📚 Запрос детальной информации о книге: key=$cleanKey');
      final response = await _api.getBookByKeyRaw(cleanKey);
      print('📚 Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        print('❌ Пустой ответ от API');
        return null;
      }
      print('📚 Парсинг ответа...');
      final bookDto = BookDto.fromJson(data);
      print('✅ Найдена книга: ${bookDto.title}');
      return bookDto;
    });
  }

  // 2. Поиск книг по автору
  Future<List<BookDto>> searchBooksByAuthor(String authorName) async {
    return _executeWithRetry(() async {
      print('Запрос книг по автору: author=$authorName, limit=$_maxResults');
      final response = await _api.searchBooksByAuthorRaw(authorName, _maxResults);
      print('Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        print('Пустой ответ от API');
        throw Exception('Пустой ответ от API');
      }
      print('Парсинг ответа...');
      final openLibraryResponse = OpenLibraryResponse.fromJson(data);
      print('Найдено книг: ${openLibraryResponse.docs.length}');
      return openLibraryResponse.docs;
    });
  }

  // 3. Поиск книг по предмету/категории
  Future<List<BookDto>> searchBooksBySubject(String subject) async {
    return _executeWithRetry(() async {
      print('Запрос книг по предмету: subject=$subject, limit=$_maxResults');
      final response = await _api.searchBooksBySubjectRaw(subject, _maxResults);
      print('Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        print('Пустой ответ от API');
        throw Exception('Пустой ответ от API');
      }
      print('Парсинг ответа...');
      final openLibraryResponse = OpenLibraryResponse.fromJson(data);
      print('Найдено книг: ${openLibraryResponse.docs.length}');
      return openLibraryResponse.docs;
    });
  }

  // 4. Получение книги по ISBN
  Future<BookDto?> getBookByIsbn(String isbn) async {
    return _executeWithRetrySingle(() async {
      // Убираем дефисы и пробелы из ISBN, также убираем .json если есть
      String cleanIsbn = isbn.replaceAll('-', '').replaceAll(' ', '').replaceAll('.json', '');
      
      print('📚 Запрос книги по ISBN: isbn=$cleanIsbn');
      final response = await _api.getBookByIsbnRaw(cleanIsbn);
      print('📚 Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        print('❌ Пустой ответ от API');
        return null;
      }
      print('📚 Парсинг ответа...');
      final bookDto = BookDto.fromJson(data);
      print('✅ Найдена книга: ${bookDto.title}');
      return bookDto;
    });
  }

  // 5. Поиск книг с фильтрацией по году публикации
  Future<List<BookDto>> searchBooksByYear(int year, {String? query}) async {
    return _executeWithRetry(() async {
      final searchQuery = query?.trim();
      print('Запрос книг по году: year=$year, query=${searchQuery ?? "(пустая строка)"}, limit=$_maxResults');
      final response = await _api.searchBooksByYearRaw(year, _maxResults, searchQuery ?? '');
      print('Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        print('Пустой ответ от API');
        throw Exception('Пустой ответ от API');
      }
      print('Парсинг ответа...');
      final openLibraryResponse = OpenLibraryResponse.fromJson(data);
      print('Найдено книг: ${openLibraryResponse.docs.length}');
      return openLibraryResponse.docs;
    });
  }

  /// Выполняет запрос с автоматическими повторами при временных ошибках (для списков)
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

  /// Выполняет запрос с автоматическими повторами при временных ошибках (для одиночных объектов)
  Future<BookDto?> _executeWithRetrySingle(
    Future<BookDto?> Function() request, {
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
