class ArticleModel {
  final String id;
  final String title;
  final List<String> authors;
  final String? abstract;
  final DateTime? publishedDate;
  final List<String>? categories;
  final String? pdfUrl;
  final String? doi;

  ArticleModel({
    required this.id,
    required this.title,
    required this.authors,
    this.abstract,
    this.publishedDate,
    this.categories,
    this.pdfUrl,
    this.doi,
  });

  ArticleModel copyWith({
    String? id,
    String? title,
    List<String>? authors,
    String? abstract,
    DateTime? publishedDate,
    List<String>? categories,
    String? pdfUrl,
    String? doi,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      abstract: abstract ?? this.abstract,
      publishedDate: publishedDate ?? this.publishedDate,
      categories: categories ?? this.categories,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      doi: doi ?? this.doi,
    );
  }
}

