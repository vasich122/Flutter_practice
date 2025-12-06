import '../../core/models/grade_model.dart';
import '../repositories/grade_repository.dart';

class GetGradesUseCase {
  final GradeRepository _repository;

  GetGradesUseCase(this._repository);

  Future<List<GradeModel>> call() => _repository.getGrades();
}

