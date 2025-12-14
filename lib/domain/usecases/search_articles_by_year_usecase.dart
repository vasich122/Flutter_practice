import '../../core/models/article_model.dart';
import '../repositories/student_help_repository.dart';

class SearchArticlesByYearUseCase {
  final StudentHelpRepository _repository;

  SearchArticlesByYearUseCase(this._repository);

  Future<List<ArticleModel>> call(int year, {String? searchQuery, String? category}) async {
    return await _repository.searchArticlesByYear(year, searchQuery: searchQuery, category: category);
  }
}

