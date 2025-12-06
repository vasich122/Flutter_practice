import '../../../core/models/book_model.dart';
import 'book_dto.dart';
extension BookMapper on BookDto {
  BookModel toModel() {
    String? coverUrl;
    if (coverId != null) {
      coverUrl = 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
    }

    return BookModel(
      id: key,
      title: title,
      authors: authorNames ?? ['Автор неизвестен'],
      description: description,
      coverUrl: coverUrl,
      publishYear: firstPublishYear,
      subjects: subjects,
    );
  }
}

