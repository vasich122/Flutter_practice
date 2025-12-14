import '../../core/models/grade_model.dart';

abstract class GradeRepository {
  Future<List<GradeModel>> getGrades();

  Future<GradeModel?> getGradeById(String id);

  Future<void> saveGradeNote(String gradeId, String note);

  Future<void> deleteGradeNote(String gradeId);

  Future<String?> getGradeNote(String gradeId);
}

