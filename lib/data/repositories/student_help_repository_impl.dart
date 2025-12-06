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
        final extractedDifficulty = parts[1]; // easy, medium, hard или русский вариант
        // Проверяем, это английский формат или русский
        if (extractedDifficulty == 'easy' || 
            extractedDifficulty == 'medium' || 
            extractedDifficulty == 'hard') {
          apiDifficulty = extractedDifficulty;
        } else {
          // Если извлеченная сложность на русском, используем переданную difficulty
          apiDifficulty = difficulty;
        }
      }
    }
    
    // Маппинг русской сложности в формат API
    switch (apiDifficulty.toLowerCase()) {
      case 'легкий':
      case 'легк':
        apiDifficulty = 'easy';
        break;
      case 'средний':
      case 'средн':
        apiDifficulty = 'medium';
        break;
      case 'сложный':
      case 'сложн':
        apiDifficulty = 'hard';
        break;
      // Если уже на английском, оставляем как есть
      case 'easy':
      case 'medium':
      case 'hard':
        // Уже правильный формат
        break;
      default:
        // Если формат неизвестен, пробуем извлечь из testId еще раз
        if (testId.contains('_')) {
          final parts = testId.split('_');
          if (parts.length >= 2) {
            final extracted = parts[1].toLowerCase();
            if (extracted == 'easy' || extracted == 'medium' || extracted == 'hard') {
              apiDifficulty = extracted;
            }
          }
        }
    }

    print('📝 Repository: загрузка вопросов: testId=$testId, difficulty=$difficulty, apiDifficulty=$apiDifficulty');
    final questions = await _mathTestDataSource.getTestQuestions(apiDifficulty);
    print('📝 Repository: загружено вопросов: ${questions.length}');
    
    if (questions.isEmpty) {
      print('❌ Repository: вопросы не найдены для сложности: $apiDifficulty');
      // Mock-данные должны всегда возвращать вопросы, но на всякий случай
      throw Exception('Вопросы не найдены для теста. Попробуйте выбрать другой тест.');
    }
    
    final models = questions.map((dto) => dto.toModel()).toList();
    print('✅ Repository: преобразовано в модели: ${models.length}');
    return models;
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

