import '../../core/models/book_model.dart';
import '../repositories/student_help_repository.dart';

class GetBookByIsbnUseCase {
  final StudentHelpRepository _repository;

  GetBookByIsbnUseCase(this._repository);

  Future<BookModel?> call(String isbn) async {
    return await _repository.getBookByIsbn(isbn);
  }
}

