import '../../core/models/article_model.dart';
import '../repositories/student_help_repository.dart';

class SearchArticlesUseCase {
  final StudentHelpRepository _repository;

  SearchArticlesUseCase(this._repository);

  Future<List<ArticleModel>> call(String query, {String? category}) =>
      _repository.searchArticles(query, category: category);
}

