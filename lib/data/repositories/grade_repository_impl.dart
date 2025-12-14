import '../../core/models/grade_model.dart';
import '../../domain/repositories/grade_repository.dart';
import '../datasources/grade/grade_local_data_source.dart';
import '../datasources/grade/grade_mapper.dart';

class GradeRepositoryImpl implements GradeRepository {
  final GradeLocalDataSource _localDataSource;

  GradeRepositoryImpl(this._localDataSource);

  @override
  Future<List<GradeModel>> getGrades() async {
    final dtos = await _localDataSource.getGrades();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<GradeModel?> getGradeById(String id) async {
    final dto = await _localDataSource.getGradeById(id);
    return dto?.toModel();
  }

  @override
  Future<void> saveGradeNote(String gradeId, String note) async {
    await _localDataSource.saveNote(gradeId, note);
  }

  @override
  Future<void> deleteGradeNote(String gradeId) async {
    await _localDataSource.deleteNote(gradeId);
  }

  @override
  Future<String?> getGradeNote(String gradeId) async {
    return await _localDataSource.getNote(gradeId);
  }
}

