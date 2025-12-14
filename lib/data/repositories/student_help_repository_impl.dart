import '../../core/models/book_model.dart';
import '../../core/models/article_model.dart';
import '../../domain/repositories/student_help_repository.dart';
import '../datasources/library/library_api_data_source.dart';
import '../datasources/library/book_mapper.dart';
import '../datasources/articles/articles_api_data_source.dart';
import '../datasources/articles/article_mapper.dart';

class StudentHelpRepositoryImpl implements StudentHelpRepository {
  final LibraryApiDataSource _libraryDataSource;
  final ArticlesApiDataSource _articlesDataSource;

  StudentHelpRepositoryImpl({
    required LibraryApiDataSource libraryDataSource,
    required ArticlesApiDataSource articlesDataSource,
  }) : _libraryDataSource = libraryDataSource,
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
  Future<BookModel?> getBookByKey(String key) async {
    final dto = await _libraryDataSource.getBookByKey(key);
    return dto?.toModel();
  }

  @override
  Future<List<BookModel>> searchBooksByAuthor(String authorName) async {
    final dtos = await _libraryDataSource.searchBooksByAuthor(authorName);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<List<BookModel>> searchBooksBySubject(String subject) async {
    final dtos = await _libraryDataSource.searchBooksBySubject(subject);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<BookModel?> getBookByIsbn(String isbn) async {
    final dto = await _libraryDataSource.getBookByIsbn(isbn);
    return dto?.toModel();
  }

  @override
  Future<List<BookModel>> searchBooksByYear(int year, {String? query}) async {
    final dtos = await _libraryDataSource.searchBooksByYear(year, query: query);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<List<ArticleModel>> searchArticles(
    String query, {
    String? category,
  }) async {
    final dtos = await _articlesDataSource.searchArticles(
      query,
      category: category,
    );
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<List<ArticleModel>> getRecentArticles({String? category}) async {
    final dtos = await _articlesDataSource.getRecentArticles(
      category: category,
    );
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<ArticleModel?> getArticleById(String id) async {
    final dto = await _articlesDataSource.getArticleById(id);
    return dto?.toModel();
  }

  @override
  Future<List<ArticleModel>> searchArticlesByAuthor(
    String authorId, {
    String? searchQuery,
  }) async {
    final dtos = await _articlesDataSource.searchArticlesByAuthor(
      authorId,
      searchQuery: searchQuery,
    );
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<ArticleModel?> searchArticleByDoi(String doi) async {
    final dto = await _articlesDataSource.searchArticleByDoi(doi);
    return dto?.toModel();
  }

  @override
  Future<List<ArticleModel>> getMostCitedArticles({
    String? category,
    String? searchQuery,
  }) async {
    final dtos = await _articlesDataSource.getMostCitedArticles(
      category: category,
      searchQuery: searchQuery,
    );
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<List<ArticleModel>> searchArticlesByYear(
    int year, {
    String? searchQuery,
    String? category,
  }) async {
    final dtos = await _articlesDataSource.searchArticlesByYear(
      year,
      searchQuery: searchQuery,
      category: category,
    );
    return dtos.map((dto) => dto.toModel()).toList();
  }
}
