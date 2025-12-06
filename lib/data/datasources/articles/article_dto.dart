import 'package:json_annotation/json_annotation.dart';

part 'article_dto.g.dart';

@JsonSerializable()
class ArticleDto {
  @JsonKey(name: 'id', fromJson: _idFromJson)
  final String id;

  @JsonKey(name: 'display_name')
  final String title;

  @JsonKey(name: 'authorships', fromJson: _authorsFromJson)
  final List<String> authors;

  @JsonKey(name: 'abstract_inverted_index', fromJson: _abstractFromJson)
  final String? summary;

  @JsonKey(name: 'publication_date', fromJson: _dateFromJson)
  final DateTime? published;

  @JsonKey(name: 'topics', fromJson: _categoriesFromJson)
  final List<String>? categories;

  @JsonKey(name: 'primary_location', fromJson: _pdfUrlFromJson)
  final String? pdfUrl;

  @JsonKey(name: 'doi', fromJson: _doiFromJson)
  final String? doi;

  ArticleDto({
    required this.id,
    required this.title,
    required this.authors,
    this.summary,
    this.published,
    this.categories,
    this.pdfUrl,
    this.doi,
  });

  factory ArticleDto.fromJson(Map<String, dynamic> json) {
    final dto = _$ArticleDtoFromJson(json);
    
    // Дополнительная обработка PDF URL из best_oa_location
    if (dto.pdfUrl == null && json['best_oa_location'] != null) {
      final bestOaLocation = json['best_oa_location'] as Map<String, dynamic>?;
      if (bestOaLocation != null) {
        final pdfUrl = bestOaLocation['pdf_url'] as String?;
        if (pdfUrl != null) {
          return dto.copyWith(pdfUrl: pdfUrl);
        }
      }
    }
    
    return dto;
  }
  
  ArticleDto copyWith({
    String? id,
    String? title,
    List<String>? authors,
    String? summary,
    DateTime? published,
    List<String>? categories,
    String? pdfUrl,
    String? doi,
  }) {
    return ArticleDto(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      summary: summary ?? this.summary,
      published: published ?? this.published,
      categories: categories ?? this.categories,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      doi: doi ?? this.doi,
    );
  }

  Map<String, dynamic> toJson() => _$ArticleDtoToJson(this);

  // Извлечение ID из URL
  static String _idFromJson(dynamic value) {
    if (value == null) return '';
    final openAlexId = value.toString();
    if (openAlexId.contains('/W')) {
      return openAlexId.split('/W').last;
    } else if (openAlexId.contains('openalex.org/')) {
      return openAlexId.split('openalex.org/').last;
    }
    return openAlexId;
  }

  // Извлечение авторов из authorships
  static List<String> _authorsFromJson(dynamic value) {
    if (value == null || value is! List) return [];
    final authorships = value;
    return authorships.map((authorship) {
      if (authorship is Map<String, dynamic>) {
        final author = authorship['author'] as Map<String, dynamic>?;
        if (author != null) {
          return author['display_name'] as String? ?? '';
        }
        return authorship['raw_author_name'] as String? ?? '';
      }
      return '';
    }).where((name) => name.isNotEmpty).toList();
  }

  // Восстановление абстракта из inverted index
  static String? _abstractFromJson(dynamic value) {
    if (value == null || value is! Map) return null;
    final invertedIndex = value as Map<String, dynamic>;
    if (invertedIndex.isEmpty) return null;

    final List<MapEntry<int, String>> words = [];
    invertedIndex.forEach((word, positions) {
      if (positions is List) {
        for (final pos in positions) {
          if (pos is int) {
            words.add(MapEntry(pos, word));
          }
        }
      }
    });

    words.sort((a, b) => a.key.compareTo(b.key));
    return words.map((e) => e.value).join(' ');
  }

  // Парсинг даты
  static DateTime? _dateFromJson(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return null;
    }
  }

  // Извлечение категорий из topics
  static List<String>? _categoriesFromJson(dynamic value) {
    if (value == null || value is! List) return null;
    final topics = value;
    final categories = topics
        .map((topic) {
          if (topic is Map<String, dynamic>) {
            return topic['display_name'] as String?;
          }
          return null;
        })
        .where((name) => name != null && name.isNotEmpty)
        .cast<String>()
        .toList();
    return categories.isEmpty ? null : categories;
  }

  // Извлечение PDF URL
  static String? _pdfUrlFromJson(dynamic value) {
    if (value == null || value is! Map) return null;
    final location = value as Map<String, dynamic>;
    final pdfUrl = location['pdf_url'] as String?;
    if (pdfUrl != null) return pdfUrl;

    // Проверяем best_oa_location (будет обработано отдельно в fromJson)
    return null;
  }

  // Извлечение DOI
  static String? _doiFromJson(dynamic value) {
    if (value == null) return null;
    final doiValue = value.toString();
    if (doiValue.startsWith('https://doi.org/')) {
      return doiValue.replaceAll('https://doi.org/', '');
    }
    return doiValue;
  }
}
