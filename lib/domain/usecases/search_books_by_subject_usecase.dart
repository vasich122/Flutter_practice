import '../../core/models/book_model.dart';
import '../repositories/student_help_repository.dart';

class SearchBooksBySubjectUseCase {
  final StudentHelpRepository _repository;

  SearchBooksBySubjectUseCase(this._repository);

  Future<List<BookModel>> call(String subject) async {
    return await _repository.searchBooksBySubject(subject);
  }
}

