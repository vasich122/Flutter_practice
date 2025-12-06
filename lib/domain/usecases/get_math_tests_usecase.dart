import '../../core/models/math_test_model.dart';
import '../repositories/student_help_repository.dart';

class GetMathTestsUseCase {
  final StudentHelpRepository _repository;

  GetMathTestsUseCase(this._repository);

  Future<List<MathTestModel>> call({String? topic, String? difficulty}) =>
      _repository.getMathTests(topic: topic, difficulty: difficulty);
}

