import '../../core/models/article_model.dart';
import '../repositories/student_help_repository.dart';

class GetMostCitedArticlesUseCase {
  final StudentHelpRepository _repository;

  GetMostCitedArticlesUseCase(this._repository);

  Future<List<ArticleModel>> call({String? category, String? searchQuery}) async {
    return await _repository.getMostCitedArticles(category: category, searchQuery: searchQuery);
  }
}

