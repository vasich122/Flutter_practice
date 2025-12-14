import '../../core/models/article_model.dart';
import '../repositories/student_help_repository.dart';

class SearchArticleByDoiUseCase {
  final StudentHelpRepository _repository;

  SearchArticleByDoiUseCase(this._repository);

  Future<ArticleModel?> call(String doi) async {
    return await _repository.searchArticleByDoi(doi);
  }
}

