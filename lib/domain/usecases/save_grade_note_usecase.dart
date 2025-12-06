import '../repositories/grade_repository.dart';

class SaveGradeNoteUseCase {
  final GradeRepository _repository;

  SaveGradeNoteUseCase(this._repository);

  Future<void> call(String gradeId, String note) =>
      _repository.saveGradeNote(gradeId, note);
}

