class BookDto {
  final String key;
  final String title;
  final List<String>? authorNames;
  final String? description;
  final String? coverId;
  final int? firstPublishYear;
  final List<String>? subjects;

  BookDto({
    required this.key,
    required this.title,
    this.authorNames,
    this.description,
    this.coverId,
    this.firstPublishYear,
    this.subjects,
  });

  factory BookDto.fromJson(Map<String, dynamic> json) {
    final work = json['work'] ?? json;
    String? description;
    if (work['first_sentence'] != null) {
      final sentence = work['first_sentence'];
      if (sentence is List && sentence.isNotEmpty) {
        description = sentence[0] as String?;
      } else if (sentence is String) {
        description = sentence;
      }
    }
    List<String>? authorNames;
    final workAuthorName = work['author_name'];
    final jsonAuthorName = json['author_name'];
    if (workAuthorName is List) {
      authorNames = List<String>.from(workAuthorName);
    } else if (jsonAuthorName is List) {
      authorNames = List<String>.from(jsonAuthorName);
    }

    List<String>? subjects;
    final workSubject = work['subject'];
    final jsonSubject = json['subject'];
    if (workSubject is List) {
      subjects = List<String>.from(workSubject);
    } else if (jsonSubject is List) {
      subjects = List<String>.from(jsonSubject);
    }

    return BookDto(
      key: work['key'] as String? ?? json['key'] as String? ?? '',
      title: work['title'] as String? ?? json['title'] as String? ?? 'Без названия',
      authorNames: authorNames,
      description: description,
      coverId: work['cover_i'] != null
          ? work['cover_i'].toString()
          : json['cover_i'] != null
              ? json['cover_i'].toString()
              : null,
      firstPublishYear: work['first_publish_year'] as int? ?? json['first_publish_year'] as int?,
      subjects: subjects,
    );
  }
}
