import '../../core/models/book_model.dart';
import '../repositories/student_help_repository.dart';

class GetBookByKeyUseCase {
  final StudentHelpRepository _repository;

  GetBookByKeyUseCase(this._repository);

  Future<BookModel?> call(String key) async {
    return await _repository.getBookByKey(key);
  }
}

