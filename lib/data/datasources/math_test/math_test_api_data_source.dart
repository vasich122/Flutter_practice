import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import '../core/responses/trivia_response.dart';
import 'math_test_api.dart';
import 'math_test_dto.dart';
import 'trivia_question_dto.dart';

class MathTestApiDataSource {
  final MathTestApi _api;
  static const int _mathCategory = 19;
  static const int _defaultAmount = 10;
  static const String _defaultType = 'multiple';

  MathTestApiDataSource({Dio? dio})
      : _api = MathTestApi(
          dio ?? DioClient(
            baseUrl: 'https://opentdb.com',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ).dio,
        );

  Future<List<MathTestDto>> getTests({String? topic, String? difficulty}) async {
    try {
      final List<MathTestDto> tests = [];
      final List<String> difficultiesToFetch;

      if (difficulty != null && difficulty.isNotEmpty) {
        final apiDifficulty = _mapDifficultyToApi(difficulty);
        if (apiDifficulty != null) {
          difficultiesToFetch = [apiDifficulty];
        } else {
          return [];
        }
      } else {
        difficultiesToFetch = ['easy', 'medium', 'hard'];
      }

      for (int i = 0; i < difficultiesToFetch.length; i++) {
        final apiDifficulty = difficultiesToFetch[i];
        try {
          // Добавляем задержку между запросами, чтобы избежать блокировки API
          if (i > 0) {
            await Future.delayed(const Duration(milliseconds: 500));
          }
          final test = await _fetchTestFromApi(apiDifficulty, topic: topic);
          if (test != null) {
            // Если тема указана, проверяем соответствие
            if (topic != null && topic.isNotEmpty) {
              if (_matchesTopic(test, topic)) {
                tests.add(test);
              }
            } else {
              // Если тема не указана, добавляем все тесты
              tests.add(test);
            }
          }
        } catch (e) {
          // Продолжаем загрузку других тестов даже если один не загрузился
          print('Ошибка при загрузке теста $apiDifficulty: $e');
        }
      }

      return tests;
    } catch (e) {
      // В случае ошибки возвращаем пустой список
      return [];
    }
  }

  /// Получить тест по ID
  /// Для Open Trivia Database API ID генерируется динамически,
  /// поэтому возвращаем null или создаем новый тест
  Future<MathTestDto?> getTestById(String id) async {
    try {
      // Извлекаем сложность из ID (формат: math_easy_1234567890)
      final parts = id.split('_');
      if (parts.length >= 2) {
        final apiDifficulty = parts[1]; // easy, medium, hard
        return await _fetchTestFromApi(apiDifficulty, topic: null);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Получить вопросы теста из API
  Future<List<TriviaQuestionDto>> getTestQuestions(String difficulty) async {
    return _executeWithRetryForQuestions(() async {
      final response = await _api.getQuestionsRaw(
        _defaultAmount,
        _mathCategory,
        difficulty,
        _defaultType,
      );

      final data = response.data;
      if (data == null) {
        return [];
      }
      final triviaResponse = TriviaResponse.fromJson(data);

      // response_code 0 означает успех
      if (triviaResponse.responseCode == 0) {
        return triviaResponse.results;
      }
      return [];
    });
  }

  /// Получить тест из API по сложности
  Future<MathTestDto?> _fetchTestFromApi(String apiDifficulty, {String? topic}) async {
    return _executeWithRetry(() async {
      final response = await _api.getQuestionsRaw(
        _defaultAmount,
        _mathCategory,
        apiDifficulty,
        _defaultType,
      );

      final data = response.data;
      if (data == null) {
        return null;
      }
      final triviaResponse = TriviaResponse.fromJson(data);

      // response_code 0 означает успех
      if (triviaResponse.responseCode == 0) {
        final results = triviaResponse.results;
        if (results.isNotEmpty) {
          // Создаем тест на основе полученных вопросов
          final test = MathTestDto.fromTriviaApi(
            difficulty: apiDifficulty,
            questionCount: results.length,
            topic: topic,
          );
          return test;
        }
      }
      return null;
    });
  }

  /// Проверка соответствия теста выбранной теме
  bool _matchesTopic(MathTestDto test, String selectedTopic) {
    final testTopicLower = test.topic.toLowerCase();
    final selectedTopicLower = selectedTopic.toLowerCase();

    // Маппинг тем из UI на темы тестов
    if (selectedTopicLower.contains('алгебр')) {
      return testTopicLower.contains('алгебр') ||
          testTopicLower.contains('базовая математика') ||
          testTopicLower.contains('алгебра и геометрия') ||
          testTopicLower.contains('высшая математика');
    }
    if (selectedTopicLower.contains('геометр')) {
      return testTopicLower.contains('геометр') ||
          testTopicLower.contains('базовая математика') ||
          testTopicLower.contains('алгебра и геометрия');
    }
    if (selectedTopicLower.contains('анализ') ||
        selectedTopicLower.contains('математический анализ')) {
      return testTopicLower.contains('анализ') ||
          testTopicLower.contains('высшая математика');
    }
    if (selectedTopicLower.contains('линейная')) {
      return testTopicLower.contains('линейная') ||
          testTopicLower.contains('высшая математика');
    }
    if (selectedTopicLower.contains('вероятност')) {
      return testTopicLower.contains('вероятност') ||
          testTopicLower.contains('высшая математика');
    }

    // Если тема не совпадает ни с одной, возвращаем false
    return false;
  }

  /// Маппинг русской сложности в формат API
  String? _mapDifficultyToApi(String difficultyRu) {
    switch (difficultyRu.toLowerCase()) {
      case 'легкий':
        return 'easy';
      case 'средний':
        return 'medium';
      case 'сложный':
        return 'hard';
      default:
        return null;
    }
  }

  /// Выполняет запрос с автоматическими повторами при временных ошибках (для тестов)
  Future<MathTestDto?> _executeWithRetry(
    Future<MathTestDto?> Function() request, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        return await request();
      } on DioException catch (e) {
        attempt++;
        // Повторяем только при ошибках подключения или таймаутах
        final shouldRetry = e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout;

        if (shouldRetry && attempt < maxRetries) {
          // Увеличиваем задержку с каждой попыткой (exponential backoff)
          final backoffDelay = Duration(milliseconds: delay.inMilliseconds * attempt);
          print('⚠️ Попытка $attempt/$maxRetries не удалась для теста, повтор через ${backoffDelay.inSeconds}с...');
          await Future.delayed(backoffDelay);
          continue;
        }
        // Для других ошибок возвращаем null
        print('❌ Не удалось загрузить тест после $attempt попыток');
        return null;
      } catch (e) {
        attempt++;
        if (attempt < maxRetries) {
          // Увеличиваем задержку с каждой попыткой (exponential backoff)
          final backoffDelay = Duration(milliseconds: delay.inMilliseconds * attempt);
          print('⚠️ Попытка $attempt/$maxRetries не удалась для теста, повтор через ${backoffDelay.inSeconds}с...');
          await Future.delayed(backoffDelay);
          continue;
        }
        print('❌ Не удалось загрузить тест после $attempt попыток');
        return null;
      }
    }
    return null;
  }

  /// Выполняет запрос с автоматическими повторами при временных ошибках (для вопросов)
  Future<List<TriviaQuestionDto>> _executeWithRetryForQuestions(
    Future<List<TriviaQuestionDto>> Function() request, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        return await request();
      } on DioException catch (e) {
        attempt++;
        // Повторяем только при ошибках подключения или таймаутах
        final shouldRetry = e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout;

        if (shouldRetry && attempt < maxRetries) {
          // Увеличиваем задержку с каждой попыткой (exponential backoff)
          final backoffDelay = Duration(milliseconds: delay.inMilliseconds * attempt);
          print('⚠️ Попытка $attempt/$maxRetries не удалась для вопросов, повтор через ${backoffDelay.inSeconds}с...');
          await Future.delayed(backoffDelay);
          continue;
        }
        // Для других ошибок возвращаем пустой список
        print('❌ Не удалось загрузить вопросы после $attempt попыток');
        return [];
      } catch (e) {
        attempt++;
        if (attempt < maxRetries) {
          // Увеличиваем задержку с каждой попыткой (exponential backoff)
          final backoffDelay = Duration(milliseconds: delay.inMilliseconds * attempt);
          print('⚠️ Попытка $attempt/$maxRetries не удалась для вопросов, повтор через ${backoffDelay.inSeconds}с...');
          await Future.delayed(backoffDelay);
          continue;
        }
        print('❌ Не удалось загрузить вопросы после $attempt попыток');
        return [];
      }
    }
    return [];
  }
}
