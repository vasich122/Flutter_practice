import '../../core/models/course_info_model.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course/course_local_data_source.dart';

/// Реализация репозитория курсов
class CourseRepositoryImpl implements CourseRepository {
  final CourseLocalDataSource _localDataSource;

  CourseRepositoryImpl(this._localDataSource);

  @override
  Future<List<CourseInfoModel>> getCourses() async {
    final courses = await _localDataSource.getCourses();
    final notes = <String, String>{};

    // Получаем заметки для всех модулей
    for (final course in courses) {
      for (final module in course['modules'] as List<String>) {
        final note = await _localDataSource.getNote(module);
        if (note != null) {
          notes[module] = note;
        }
      }
    }

    return courses.map((course) {
      final courseNotes = <String, String>{};
      for (final module in course['modules'] as List<String>) {
        if (notes.containsKey(module)) {
          courseNotes[module] = notes[module]!;
        }
      }

      return CourseInfoModel(
        title: course['title'] as String,
        description: course['description'] as String,
        modules: List<String>.from(course['modules'] as List),
        notes: courseNotes,
      );
    }).toList();
  }

  @override
  Future<void> saveCourseNote(String module, String note) async {
    await _localDataSource.saveNote(module, note);
  }

  @override
  Future<String?> getCourseNote(String module) async {
    return await _localDataSource.getNote(module);
  }
}

