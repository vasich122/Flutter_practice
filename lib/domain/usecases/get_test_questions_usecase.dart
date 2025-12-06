import '../../core/models/question_model.dart';
import '../repositories/student_help_repository.dart';

/// Use Case для получения вопросов теста
class GetTestQuestionsUseCase {
  final StudentHelpRepository _repository;

  GetTestQuestionsUseCase(this._repository);

  Future<List<QuestionModel>> call(String testId, String difficulty) {
    return _repository.getTestQuestions(testId, difficulty);
  }
}

