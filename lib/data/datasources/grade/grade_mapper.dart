import '../../../core/models/grade_model.dart';
import 'grade_dto.dart';

extension GradeMapper on GradeDto {
  GradeModel toModel() {
    return GradeModel(
      id: id,
      subject: subject,
      grade: grade,
    );
  }
}

