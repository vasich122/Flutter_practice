import '../../core/models/course_info_model.dart';
import '../repositories/course_repository.dart';

/// Use Case для получения всех курсов
class GetCoursesUseCase {
  final CourseRepository _repository;

  GetCoursesUseCase(this._repository);

  Future<List<CourseInfoModel>> call() => _repository.getCourses();
}

