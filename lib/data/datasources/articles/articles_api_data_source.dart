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
    try {
      String? searchQuery;
      if (query.trim().isNotEmpty) {
        searchQuery = query.trim();
      }

      String? filterQuery;
      if (category != null && category.isNotEmpty) {
        filterQuery = 'concepts.display_name:$category';
      }

      final response = await _api.searchArticlesRaw(
        searchQuery,
        filterQuery,
        _maxResults,
        _defaultSort,
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Пустой ответ от API');
      }
      final openAlexResponse = OpenAlexResponse.fromJson(data);
      return openAlexResponse.results;
    } on DioException catch (e) {
      throw Exception('Ошибка при поиске статей: ${e.error ?? e.message}');
    } catch (e) {
      throw Exception('Ошибка при поиске статей: $e');
    }
  }

  /// Получить последние статьи
  Future<List<ArticleDto>> getRecentArticles({String? category}) async {
    try {
      String? filterQuery;
      if (category != null && category.isNotEmpty) {
        filterQuery = 'concepts.display_name:$category';
      }

      final response = await _api.getRecentArticlesRaw(
        filterQuery,
        _maxResults,
        _defaultSort,
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Пустой ответ от API');
      }
      final openAlexResponse = OpenAlexResponse.fromJson(data);

      // Сортируем по дате публикации (новые первыми)
      final articles = openAlexResponse.results;
      articles.sort((a, b) {
        if (a.published == null && b.published == null) return 0;
        if (a.published == null) return 1;
        if (b.published == null) return -1;
        return b.published!.compareTo(a.published!);
      });

      return articles;
    } on DioException catch (e) {
      throw Exception('Ошибка при получении последних статей: ${e.error ?? e.message}');
    } catch (e) {
      throw Exception('Ошибка при получении последних статей: $e');
    }
  }
}
