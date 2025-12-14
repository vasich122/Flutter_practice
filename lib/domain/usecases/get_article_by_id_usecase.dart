import '../../core/models/article_model.dart';
import '../repositories/student_help_repository.dart';

class GetArticleByIdUseCase {
  final StudentHelpRepository _repository;

  GetArticleByIdUseCase(this._repository);

  Future<ArticleModel?> call(String id) async {
    return await _repository.getArticleById(id);
  }
}

