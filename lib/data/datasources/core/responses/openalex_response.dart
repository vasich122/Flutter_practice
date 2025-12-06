import '../../articles/article_dto.dart';

/// Метаданные ответа OpenAlex
class OpenAlexMeta {
  final int count;
  final int page;
  final int perPage;

  OpenAlexMeta({
    required this.count,
    required this.page,
    required this.perPage,
  });

  factory OpenAlexMeta.fromJson(Map<String, dynamic> json) {
    return OpenAlexMeta(
      count: json['count'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 20,
    );
  }
}

/// Ответ от OpenAlex API
class OpenAlexResponse {
  final OpenAlexMeta meta;
  final List<ArticleDto> results;

  OpenAlexResponse({
    required this.meta,
    required this.results,
  });

  factory OpenAlexResponse.fromJson(Map<String, dynamic> json) {
    // Преобразуем results в ArticleDto
    final results = (json['results'] as List<dynamic>?)
            ?.map((item) => ArticleDto.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    return OpenAlexResponse(
      meta: OpenAlexMeta.fromJson(json['meta'] as Map<String, dynamic>),
      results: results,
    );
  }
}

