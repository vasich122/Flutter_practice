import '../../core/models/article_model.dart';
import '../repositories/student_help_repository.dart';

class SearchArticlesByAuthorUseCase {
  final StudentHelpRepository _repository;

  SearchArticlesByAuthorUseCase(this._repository);

  Future<List<ArticleModel>> call(String authorId, {String? searchQuery}) async {
    return await _repository.searchArticlesByAuthor(authorId, searchQuery: searchQuery);
  }
}

