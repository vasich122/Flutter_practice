import 'package:get_it/get_it.dart';

// Data Sources
import '../data/datasources/user/user_local_data_source.dart';
import '../data/datasources/grade/grade_local_data_source.dart';
import '../data/datasources/application/application_local_data_source.dart';
import '../data/datasources/academic/academic_local_data_source.dart';
import '../data/datasources/attendance/attendance_local_data_source.dart';
import '../data/datasources/course/course_local_data_source.dart';

// Repositories
import '../data/repositories/user_repository_impl.dart';
import '../data/repositories/grade_repository_impl.dart';
import '../data/repositories/application_repository_impl.dart';
import '../data/repositories/academic_repository_impl.dart';
import '../data/repositories/attendance_repository_impl.dart';
import '../data/repositories/course_repository_impl.dart';

// Domain Interfaces
import '../domain/repositories/user_repository.dart';
import '../domain/repositories/grade_repository.dart';
import '../domain/repositories/application_repository.dart';
import '../domain/repositories/academic_repository.dart';
import '../domain/repositories/attendance_repository.dart';
import '../domain/repositories/course_repository.dart';

// Use Cases
import '../domain/usecases/get_user_usecase.dart';
import '../domain/usecases/update_user_status_usecase.dart';
import '../domain/usecases/get_grades_usecase.dart';
import '../domain/usecases/save_grade_note_usecase.dart';
import '../domain/usecases/get_applications_usecase.dart';
import '../domain/usecases/create_application_usecase.dart';
import '../domain/usecases/get_academic_info_usecase.dart';
import '../domain/usecases/update_scientific_activities_usecase.dart';
import '../domain/usecases/get_attendance_records_usecase.dart';
import '../domain/usecases/get_courses_usecase.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Регистрация Data Sources
  locator.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSource(),
  );
  locator.registerLazySingleton<GradeLocalDataSource>(
    () => GradeLocalDataSource(),
  );
  locator.registerLazySingleton<ApplicationLocalDataSource>(
    () => ApplicationLocalDataSource(),
  );
  locator.registerLazySingleton<AcademicLocalDataSource>(
    () => AcademicLocalDataSource(),
  );
  locator.registerLazySingleton<AttendanceLocalDataSource>(
    () => AttendanceLocalDataSource(),
  );
  locator.registerLazySingleton<CourseLocalDataSource>(
    () => CourseLocalDataSource(),
  );

  // Регистрация Repositories
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(locator<UserLocalDataSource>()),
  );
  locator.registerLazySingleton<GradeRepository>(
    () => GradeRepositoryImpl(locator<GradeLocalDataSource>()),
  );
  locator.registerLazySingleton<ApplicationRepository>(
    () => ApplicationRepositoryImpl(locator<ApplicationLocalDataSource>()),
  );
  locator.registerLazySingleton<AcademicRepository>(
    () => AcademicRepositoryImpl(locator<AcademicLocalDataSource>()),
  );
  locator.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(locator<AttendanceLocalDataSource>()),
  );
  locator.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(locator<CourseLocalDataSource>()),
  );

  // Регистрация Use Cases
  locator.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(locator<UserRepository>()),
  );
  locator.registerLazySingleton<UpdateUserStatusUseCase>(
    () => UpdateUserStatusUseCase(locator<UserRepository>()),
  );
  locator.registerLazySingleton<GetGradesUseCase>(
    () => GetGradesUseCase(locator<GradeRepository>()),
  );
  locator.registerLazySingleton<SaveGradeNoteUseCase>(
    () => SaveGradeNoteUseCase(locator<GradeRepository>()),
  );
  locator.registerLazySingleton<GetApplicationsUseCase>(
    () => GetApplicationsUseCase(locator<ApplicationRepository>()),
  );
  locator.registerLazySingleton<CreateApplicationUseCase>(
    () => CreateApplicationUseCase(locator<ApplicationRepository>()),
  );
  locator.registerLazySingleton<GetAcademicInfoUseCase>(
    () => GetAcademicInfoUseCase(locator<AcademicRepository>()),
  );
  locator.registerLazySingleton<UpdateScientificActivitiesUseCase>(
    () => UpdateScientificActivitiesUseCase(locator<AcademicRepository>()),
  );
  locator.registerLazySingleton<GetAttendanceRecordsUseCase>(
    () => GetAttendanceRecordsUseCase(locator<AttendanceRepository>()),
  );
  locator.registerLazySingleton<GetCoursesUseCase>(
    () => GetCoursesUseCase(locator<CourseRepository>()),
  );
}
