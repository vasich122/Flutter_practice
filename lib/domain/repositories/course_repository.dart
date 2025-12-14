import '../../core/models/course_info_model.dart';

abstract class CourseRepository {
  Future<List<CourseInfoModel>> getCourses();

  Future<void> saveCourseNote(String module, String note);

  Future<String?> getCourseNote(String module);

  Future<void> deleteCourseNote(String module);
}

