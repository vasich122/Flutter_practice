import '../../core/models/book_model.dart';
import '../repositories/student_help_repository.dart';

class SearchBooksByAuthorUseCase {
  final StudentHelpRepository _repository;

  SearchBooksByAuthorUseCase(this._repository);

  Future<List<BookModel>> call(String authorName) async {
    return await _repository.searchBooksByAuthor(authorName);
  }
}

