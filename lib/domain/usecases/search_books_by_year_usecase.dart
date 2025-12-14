import '../../core/models/book_model.dart';
import '../repositories/student_help_repository.dart';

class SearchBooksByYearUseCase {
  final StudentHelpRepository _repository;

  SearchBooksByYearUseCase(this._repository);

  Future<List<BookModel>> call(int year, {String? query}) async {
    return await _repository.searchBooksByYear(year, query: query);
  }
}

