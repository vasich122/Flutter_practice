// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleDto _$ArticleDtoFromJson(Map<String, dynamic> json) => ArticleDto(
      id: ArticleDto._idFromJson(json['id']),
      title: json['display_name'] as String,
      authors: ArticleDto._authorsFromJson(json['authorships']),
      summary: ArticleDto._abstractFromJson(json['abstract_inverted_index']),
      published: ArticleDto._dateFromJson(json['publication_date']),
      categories: ArticleDto._categoriesFromJson(json['topics']),
      pdfUrl: ArticleDto._pdfUrlFromJson(json['primary_location']),
      doi: ArticleDto._doiFromJson(json['doi']),
    );

Map<String, dynamic> _$ArticleDtoToJson(ArticleDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.title,
      'authorships': instance.authors,
      'abstract_inverted_index': instance.summary,
      'publication_date': instance.published?.toIso8601String(),
      'topics': instance.categories,
      'primary_location': instance.pdfUrl,
      'doi': instance.doi,
    };
