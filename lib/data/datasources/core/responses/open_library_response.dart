import '../../library/book_dto.dart';

class OpenLibraryResponse {
  final int numFound;
  final int start;
  final List<BookDto> docs;

  OpenLibraryResponse({
    required this.numFound,
    required this.start,
    required this.docs,
  });

  factory OpenLibraryResponse.fromJson(Map<String, dynamic> json) {
    final docs = (json['docs'] as List<dynamic>?)
            ?.map((doc) => BookDto.fromJson(doc as Map<String, dynamic>))
            .toList() ??
        [];

    return OpenLibraryResponse(
      numFound: json['numFound'] as int? ?? 0,
      start: json['start'] as int? ?? 0,
      docs: docs,
    );
  }
}

