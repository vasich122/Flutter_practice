import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import '../core/responses/openalex_response.dart';
import 'articles_api.dart';
import 'article_dto.dart';
class ArticlesApiDataSource {
  final ArticlesApi _api;
  static const int _maxResults = 20;
  static const String _defaultSort = 'publication_date:desc';

  ArticlesApiDataSource({Dio? dio})
      : _api = ArticlesApi(
          dio ?? DioClient(
            baseUrl: 'https://api.openalex.org',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ).dio,
        );

  Future<List<ArticleDto>> searchArticles(String query, {String? category}) async {
    return _executeWithRetry(() async {
      String? searchQuery;
      if (query.trim().isNotEmpty) {
        searchQuery = query.trim();
      }

      String? filterQuery;
      if (category != null && category.isNotEmpty) {
        filterQuery = 'concepts.display_name:$category';
      }

      print('Запрос поиска статей: query=$searchQuery, category=$category');
      final response = await _api.searchArticlesRaw(
        searchQuery,
        filterQuery,
        _maxResults,
        _defaultSort,
      );
      print('Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        print('Пустой ответ от API');
        throw Exception('Пустой ответ от API');
      }
      print('Парсинг ответа...');
      final openAlexResponse = OpenAlexResponse.fromJson(data);
      print('Найдено статей: ${openAlexResponse.results.length}');
      return openAlexResponse.results;
    });
  }

  /// Получить последние статьи
  Future<List<ArticleDto>> getRecentArticles({String? category}) async {
    return _executeWithRetry(() async {
      String? filterQuery;
      if (category != null && category.isNotEmpty) {
        filterQuery = 'concepts.display_name:$category';
      }

      print('Запрос последних статей: category=$category');
      final response = await _api.getRecentArticlesRaw(
        filterQuery,
        _maxResults,
        _defaultSort,
      );
      print('Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        print('Пустой ответ от API');
        throw Exception('Пустой ответ от API');
      }
      print('Парсинг ответа...');
      final openAlexResponse = OpenAlexResponse.fromJson(data);

      final articles = openAlexResponse.results;
      articles.sort((a, b) {
        if (a.published == null && b.published == null) return 0;
        if (a.published == null) return 1;
        if (b.published == null) return -1;
        return b.published!.compareTo(a.published!);
      });

      print('Найдено статей: ${articles.length}');
      return articles;
    });
  }

  // 1. Получение детальной информации о статье по ID
  Future<ArticleDto?> getArticleById(String id) async {
    return _executeWithRetrySingle(() async {
      // Убираем префикс /works/ если он есть
      String cleanId = id.replaceAll('/works/', '').replaceAll('works/', '');
      
      print('📄 Запрос детальной информации о статье: id=$cleanId');
      final response = await _api.getArticleByIdRaw(cleanId);
      print('📄 Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        print('❌ Пустой ответ от API');
        return null;
      }
      print('📄 Парсинг ответа...');
      final articleDto = ArticleDto.fromJson(data);
      print('✅ Найдена статья: ${articleDto.title}');
      return articleDto;
    });
  }

  // 2. Поиск статей по автору
  Future<List<ArticleDto>> searchArticlesByAuthor(String authorId, {String? searchQuery}) async {
    return _executeWithRetry(() async {
      String cleanAuthorId = authorId.trim();
      if (cleanAuthorId.startsWith('https://openalex.org/')) {
        cleanAuthorId = cleanAuthorId.replaceAll('https://openalex.org/', '');
      } else if (cleanAuthorId.startsWith('http://openalex.org/')) {
        cleanAuthorId = cleanAuthorId.replaceAll('http://openalex.org/', '');
      }

      if (cleanAuthorId.startsWith('A') && cleanAuthorId.length > 1) {
      }
      String filter = 'author.id:https://openalex.org/$cleanAuthorId';
      print('Запрос статей по автору: authorId=$cleanAuthorId, filter=$filter, search=$searchQuery');
      
      final response = await _api.searchArticlesByAuthorRaw(
        filter,
        _maxResults,
        _defaultSort,
        searchQuery,
      );
      print('Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        throw Exception('Пустой ответ от API');
      }
      final openAlexResponse = OpenAlexResponse.fromJson(data);
      print('Найдено статей: ${openAlexResponse.results.length}');

      if (openAlexResponse.results.isEmpty) {
        // Формат 2: через authorships
        print('📄 Попытка формата 2: authorships.author.id:https://openalex.org/$cleanAuthorId');
        try {
          final response2 = await _api.searchArticlesByAuthorRaw(
            'authorships.author.id:https://openalex.org/$cleanAuthorId',
            _maxResults,
            _defaultSort,
            searchQuery,
          );
          final data2 = response2.data;
          if (data2 != null) {
            final openAlexResponse2 = OpenAlexResponse.fromJson(data2);
            print('📄 Найдено статей (формат 2): ${openAlexResponse2.results.length}');
            if (openAlexResponse2.results.isNotEmpty) {
              return openAlexResponse2.results;
            }
          }
        } catch (e) {
          print('⚠️ Формат 2 не сработал: $e');
        }
        
        // Формат 3: короткий ID
        print('📄 Попытка формата 3: author.id:$cleanAuthorId');
        try {
          final response3 = await _api.searchArticlesByAuthorRaw(
            'author.id:$cleanAuthorId',
            _maxResults,
            _defaultSort,
            searchQuery,
          );
          final data3 = response3.data;
          if (data3 != null) {
            final openAlexResponse3 = OpenAlexResponse.fromJson(data3);
            print('📄 Найдено статей (формат 3): ${openAlexResponse3.results.length}');
            if (openAlexResponse3.results.isNotEmpty) {
              return openAlexResponse3.results;
            }
          }
        } catch (e) {
          print('⚠️ Формат 3 не сработал: $e');
        }
      }
      
      return openAlexResponse.results;
    });
  }

  // 3. Поиск статей по DOI
  Future<ArticleDto?> searchArticleByDoi(String doi) async {
    return _executeWithRetrySingle(() async {
      String cleanDoi = doi.replaceAll('https://doi.org/', '').replaceAll('http://doi.org/', '');
      
      final filter = 'doi:$cleanDoi';
      print('Запрос статьи по DOI: doi=$cleanDoi');
      final response = await _api.searchArticlesByDoiRaw(filter, 1);
      print('Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        print('Пустой ответ от API');
        return null;
      }
      final openAlexResponse = OpenAlexResponse.fromJson(data);
      if (openAlexResponse.results.isEmpty) {
        print('Статья не найдена');
        return null;
      }
      print('Найдена статья: ${openAlexResponse.results.first.title}');
      return openAlexResponse.results.first;
    });
  }

  // 4. Получение самых цитируемых статей
  Future<List<ArticleDto>> getMostCitedArticles({String? category, String? searchQuery}) async {
    return _executeWithRetry(() async {
      String? filterQuery;
      if (category != null && category.isNotEmpty) {
        filterQuery = 'concepts.display_name:$category';
      }
      
      final sort = 'cited_by_count:desc';
      print('Запрос самых цитируемых статей: category=$category, search=$searchQuery');
      final response = await _api.getMostCitedArticlesRaw(
        filterQuery,
        _maxResults,
        sort,
        searchQuery,
      );
      print('Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        throw Exception('Пустой ответ от API');
      }
      final openAlexResponse = OpenAlexResponse.fromJson(data);
      print('Найдено статей: ${openAlexResponse.results.length}');
      return openAlexResponse.results;
    });
  }

  // 5. Поиск статей по году публикации
  Future<List<ArticleDto>> searchArticlesByYear(int year, {String? searchQuery, String? category}) async {
    return _executeWithRetry(() async {
      String filter = 'publication_year:$year';
      if (category != null && category.isNotEmpty) {
        filter = '$filter,concepts.display_name:$category';
      }
      
      print('📄 Запрос статей по году: year=$year, category=$category, search=$searchQuery');
      final response = await _api.searchArticlesByYearRaw(
        filter,
        _maxResults,
        _defaultSort,
        searchQuery,
      );
      print('📄 Получен ответ: statusCode=${response.statusCode}');
      final data = response.data;
      if (data == null) {
        throw Exception('Пустой ответ от API');
      }
      final openAlexResponse = OpenAlexResponse.fromJson(data);
      print('📄 Найдено статей: ${openAlexResponse.results.length}');
      return openAlexResponse.results;
    });
  }

  /// Выполняет запрос с автоматическими повторами при временных ошибках (для списков)
  Future<List<ArticleDto>> _executeWithRetry(
    Future<List<ArticleDto>> Function() request, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 2),
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;
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
          // Экспоненциальная задержка: 2с, 4с, 8с
          print('⚠️ Попытка $attempt/$maxRetries не удалась, повтор через ${delay.inSeconds}с...');
          await Future.delayed(delay);
          delay = Duration(seconds: delay.inSeconds * 2);
          continue;
        }

        print('❌ DioException при запросе к OpenAlex API:');
        print('   Type: ${e.type}');
        print('   Message: ${e.message}');
        print('   Error: ${e.error}');
        print('   Response: ${e.response?.statusCode}');
        final errorMessage = e.error?.toString() ?? e.message ?? 'Неизвестная ошибка';
        throw Exception('Ошибка при запросе к OpenAlex API: $errorMessage');
      } catch (e, stackTrace) {
        attempt++;
        if (attempt < maxRetries && e is! DioException) {
          print('⚠️ Попытка $attempt/$maxRetries не удалась, повтор через ${delay.inSeconds}с...');
          await Future.delayed(delay);
          delay = Duration(seconds: delay.inSeconds * 2);
          continue;
        }
        print('❌ Exception при запросе к OpenAlex API: $e');
        print('   StackTrace: $stackTrace');
        throw Exception('Ошибка при запросе к OpenAlex API: $e');
      }
    }
    throw Exception('Не удалось выполнить запрос к OpenAlex API после $maxRetries попыток');
  }

  /// Выполняет запрос с автоматическими повторами при временных ошибках (для одиночных объектов)
  Future<ArticleDto?> _executeWithRetrySingle(
    Future<ArticleDto?> Function() request, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 2),
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;
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
          // Экспоненциальная задержка: 2с, 4с, 8с
          print('⚠️ Попытка $attempt/$maxRetries не удалась, повтор через ${delay.inSeconds}с...');
          await Future.delayed(delay);
          delay = Duration(seconds: delay.inSeconds * 2);
          continue;
        }

        print('❌ DioException при запросе к OpenAlex API:');
        print('   Type: ${e.type}');
        print('   Message: ${e.message}');
        print('   Error: ${e.error}');
        print('   Response: ${e.response?.statusCode}');
        final errorMessage = e.error?.toString() ?? e.message ?? 'Неизвестная ошибка';
        throw Exception('Ошибка при запросе к OpenAlex API: $errorMessage');
      } catch (e, stackTrace) {
        attempt++;
        if (attempt < maxRetries && e is! DioException) {
          print('⚠️ Попытка $attempt/$maxRetries не удалась, повтор через ${delay.inSeconds}с...');
          await Future.delayed(delay);
          delay = Duration(seconds: delay.inSeconds * 2);
          continue;
        }
        print('❌ Exception при запросе к OpenAlex API: $e');
        print('   StackTrace: $stackTrace');
        throw Exception('Ошибка при запросе к OpenAlex API: $e');
      }
    }
    throw Exception('Не удалось выполнить запрос к OpenAlex API после $maxRetries попыток');
  }
}
