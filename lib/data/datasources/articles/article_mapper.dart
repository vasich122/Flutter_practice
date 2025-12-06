import '../../../core/models/article_model.dart';
import 'article_dto.dart';

extension ArticleMapper on ArticleDto {
  ArticleModel toModel() {
    return ArticleModel(
      id: id,
      title: title,
      authors: authors,
      abstract: summary,
      publishedDate: published,
      categories: categories,
      pdfUrl: pdfUrl,
      doi: doi,
    );
  }
}

