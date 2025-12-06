import '../../core/models/course_info_model.dart';

/// Абстрактный интерфейс репозитория курсов
abstract class CourseRepository {
  /// Получить все курсы
  Future<List<CourseInfoModel>> getCourses();

  /// Сохранить заметку к модулю курса
  Future<void> saveCourseNote(String module, String note);

  /// Получить заметку к модулю курса
  Future<String?> getCourseNote(String module);
}

