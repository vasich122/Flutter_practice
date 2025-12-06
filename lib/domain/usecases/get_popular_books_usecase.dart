import '../../core/models/book_model.dart';
import '../repositories/student_help_repository.dart';

class GetPopularBooksUseCase {
  final StudentHelpRepository _repository;

  GetPopularBooksUseCase(this._repository);

  Future<List<BookModel>> call() => _repository.getPopularBooks();
}

