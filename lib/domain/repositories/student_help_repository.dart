import '../../core/models/book_model.dart';
import '../../core/models/math_test_model.dart';
import '../../core/models/article_model.dart';
import '../../core/models/question_model.dart';

abstract class StudentHelpRepository {
  Future<List<BookModel>> searchBooks(String query);

  Future<List<BookModel>> getPopularBooks();

  Future<List<MathTestModel>> getMathTests({String? topic, String? difficulty});

  Future<MathTestModel?> getMathTestById(String id);

  Future<List<QuestionModel>> getTestQuestions(String testId, String difficulty);

  Future<List<ArticleModel>> searchArticles(String query, {String? category});

  Future<List<ArticleModel>> getRecentArticles({String? category});
}

