import 'package:get_it/get_it.dart';

// Database
import '../data/datasources/core/database.dart';

// Data Sources
import '../data/datasources/user/user_local_data_source.dart';
import '../data/datasources/grade/grade_local_data_source.dart';
import '../data/datasources/application/application_local_data_source.dart';
import '../data/datasources/academic/academic_local_data_source.dart';
import '../data/datasources/attendance/attendance_local_data_source.dart';
import '../data/datasources/course/course_local_data_source.dart';
import '../data/datasources/library/library_api_data_source.dart';
import '../data/datasources/articles/articles_api_data_source.dart';

// Repositories
import '../data/repositories/user_repository_impl.dart';
import '../data/repositories/grade_repository_impl.dart';
import '../data/repositories/application_repository_impl.dart';
import '../data/repositories/academic_repository_impl.dart';
import '../data/repositories/attendance_repository_impl.dart';
import '../data/repositories/course_repository_impl.dart';
import '../data/repositories/student_help_repository_impl.dart';

// Domain Interfaces
import '../domain/repositories/user_repository.dart';
import '../domain/repositories/grade_repository.dart';
import '../domain/repositories/application_repository.dart';
import '../domain/repositories/academic_repository.dart';
import '../domain/repositories/attendance_repository.dart';
import '../domain/repositories/course_repository.dart';
import '../domain/repositories/student_help_repository.dart';

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
import '../domain/usecases/search_books_usecase.dart';
import '../domain/usecases/get_popular_books_usecase.dart';
import '../domain/usecases/get_book_by_key_usecase.dart';
import '../domain/usecases/search_books_by_author_usecase.dart';
import '../domain/usecases/search_books_by_subject_usecase.dart';
import '../domain/usecases/get_book_by_isbn_usecase.dart';
import '../domain/usecases/search_books_by_year_usecase.dart';
import '../domain/usecases/search_articles_usecase.dart';
import '../domain/usecases/get_recent_articles_usecase.dart';
import '../domain/usecases/get_article_by_id_usecase.dart';
import '../domain/usecases/search_articles_by_author_usecase.dart';
import '../domain/usecases/search_article_by_doi_usecase.dart';
import '../domain/usecases/get_most_cited_articles_usecase.dart';
import '../domain/usecases/search_articles_by_year_usecase.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Регистрация базы данных Drift
  locator.registerLazySingleton<AppDatabase>(() => AppDatabase());

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
  locator.registerLazySingleton<LibraryApiDataSource>(
    () => LibraryApiDataSource(),
  );
  locator.registerLazySingleton<ArticlesApiDataSource>(
    () => ArticlesApiDataSource(),
  );

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
  locator.registerLazySingleton<StudentHelpRepository>(
    () => StudentHelpRepositoryImpl(
      libraryDataSource: locator<LibraryApiDataSource>(),
      articlesDataSource: locator<ArticlesApiDataSource>(),
    ),
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
  locator.registerLazySingleton<SearchBooksUseCase>(
    () => SearchBooksUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<GetPopularBooksUseCase>(
    () => GetPopularBooksUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<GetBookByKeyUseCase>(
    () => GetBookByKeyUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<SearchBooksByAuthorUseCase>(
    () => SearchBooksByAuthorUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<SearchBooksBySubjectUseCase>(
    () => SearchBooksBySubjectUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<GetBookByIsbnUseCase>(
    () => GetBookByIsbnUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<SearchBooksByYearUseCase>(
    () => SearchBooksByYearUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<SearchArticlesUseCase>(
    () => SearchArticlesUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<GetRecentArticlesUseCase>(
    () => GetRecentArticlesUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<GetArticleByIdUseCase>(
    () => GetArticleByIdUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<SearchArticlesByAuthorUseCase>(
    () => SearchArticlesByAuthorUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<SearchArticleByDoiUseCase>(
    () => SearchArticleByDoiUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<GetMostCitedArticlesUseCase>(
    () => GetMostCitedArticlesUseCase(locator<StudentHelpRepository>()),
  );
  locator.registerLazySingleton<SearchArticlesByYearUseCase>(
    () => SearchArticlesByYearUseCase(locator<StudentHelpRepository>()),
  );
}
