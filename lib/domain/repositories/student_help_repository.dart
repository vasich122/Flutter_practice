import '../../core/models/book_model.dart';
import '../../core/models/article_model.dart';

abstract class StudentHelpRepository {
  Future<List<BookModel>> searchBooks(String query);

  Future<List<BookModel>> getPopularBooks();

  Future<BookModel?> getBookByKey(String key);

  Future<List<BookModel>> searchBooksByAuthor(String authorName);

  Future<List<BookModel>> searchBooksBySubject(String subject);

  Future<BookModel?> getBookByIsbn(String isbn);

  Future<List<BookModel>> searchBooksByYear(int year, {String? query});

  Future<List<ArticleModel>> searchArticles(String query, {String? category});

  Future<List<ArticleModel>> getRecentArticles({String? category});

  Future<ArticleModel?> getArticleById(String id);

  Future<List<ArticleModel>> searchArticlesByAuthor(
    String authorId, {
    String? searchQuery,
  });

  Future<ArticleModel?> searchArticleByDoi(String doi);

  Future<List<ArticleModel>> getMostCitedArticles({
    String? category,
    String? searchQuery,
  });

  Future<List<ArticleModel>> searchArticlesByYear(
    int year, {
    String? searchQuery,
    String? category,
  });
}
