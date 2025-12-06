import '../../core/models/book_model.dart';
import '../repositories/student_help_repository.dart';

class SearchBooksUseCase {
  final StudentHelpRepository _repository;

  SearchBooksUseCase(this._repository);

  Future<List<BookModel>> call(String query) => _repository.searchBooks(query);
}

