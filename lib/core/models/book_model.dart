class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? coverUrl;
  final int? publishYear;
  final List<String>? subjects;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.coverUrl,
    this.publishYear,
    this.subjects,
  });

  BookModel copyWith({
    String? id,
    String? title,
    List<String>? authors,
    String? description,
    String? coverUrl,
    int? publishYear,
    List<String>? subjects,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      publishYear: publishYear ?? this.publishYear,
      subjects: subjects ?? this.subjects,
    );
  }
}

