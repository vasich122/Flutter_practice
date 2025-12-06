import '../../core/models/book_model.dart';
import '../../core/models/math_test_model.dart';
import '../../core/models/article_model.dart';
import '../../core/models/question_model.dart';
import '../../domain/repositories/student_help_repository.dart';
import '../datasources/library/library_api_data_source.dart';
import '../datasources/library/book_mapper.dart';
import '../datasources/math_test/math_test_api_data_source.dart';
import '../datasources/math_test/math_test_mapper.dart';
import '../datasources/math_test/question_mapper.dart';
import '../datasources/articles/articles_api_data_source.dart';
import '../datasources/articles/article_mapper.dart';

/// Реализация репозитория помощи студенту
/// Координирует работу с тремя источниками данных: библиотека, тесты, статьи
class StudentHelpRepositoryImpl implements StudentHelpRepository {
  final LibraryApiDataSource _libraryDataSource;
  final MathTestApiDataSource _mathTestDataSource;
  final ArticlesApiDataSource _articlesDataSource;

  StudentHelpRepositoryImpl({
    required LibraryApiDataSource libraryDataSource,
    required MathTestApiDataSource mathTestDataSource,
    required ArticlesApiDataSource articlesDataSource,
  })  : _libraryDataSource = libraryDataSource,
        _mathTestDataSource = mathTestDataSource,
        _articlesDataSource = articlesDataSource;

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    final dtos = await _libraryDataSource.searchBooks(query);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<List<BookModel>> getPopularBooks() async {
    final dtos = await _libraryDataSource.getPopularBooks();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<List<MathTestModel>> getMathTests({String? topic, String? difficulty}) async {
    final dtos = await _mathTestDataSource.getTests(topic: topic, difficulty: difficulty);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<MathTestModel?> getMathTestById(String id) async {
    final dto = await _mathTestDataSource.getTestById(id);
    return dto?.toModel();
  }

  @override
  Future<List<QuestionModel>> getTestQuestions(String testId, String difficulty) async {
    // Извлекаем сложность из testId или используем переданную
    String apiDifficulty = difficulty;
    if (testId.contains('_')) {
      final parts = testId.split('_');
      if (parts.length >= 2) {
        apiDifficulty = parts[1]; // easy, medium, hard
      }
    }
    
    // Маппинг русской сложности в формат API
    switch (apiDifficulty.toLowerCase()) {
      case 'легкий':
        apiDifficulty = 'easy';
        break;
      case 'средний':
        apiDifficulty = 'medium';
        break;
      case 'сложный':
        apiDifficulty = 'hard';
        break;
    }

    final questions = await _mathTestDataSource.getTestQuestions(apiDifficulty);
    return questions.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<List<ArticleModel>> searchArticles(String query, {String? category}) async {
    final dtos = await _articlesDataSource.searchArticles(query, category: category);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<List<ArticleModel>> getRecentArticles({String? category}) async {
    final dtos = await _articlesDataSource.getRecentArticles(category: category);
    return dtos.map((dto) => dto.toModel()).toList();
  }
}

