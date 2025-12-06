import '../../core/models/article_model.dart';
import '../repositories/student_help_repository.dart';

class GetRecentArticlesUseCase {
  final StudentHelpRepository _repository;

  GetRecentArticlesUseCase(this._repository);

  Future<List<ArticleModel>> call({String? category}) =>
      _repository.getRecentArticles(category: category);
}

