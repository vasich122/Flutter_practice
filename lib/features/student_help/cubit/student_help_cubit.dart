import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/book_model.dart';
import '../../../core/models/article_model.dart';
import '../../../domain/usecases/search_books_usecase.dart';
import '../../../domain/usecases/get_popular_books_usecase.dart';
import '../../../domain/usecases/get_book_by_key_usecase.dart';
import '../../../domain/usecases/search_books_by_author_usecase.dart';
import '../../../domain/usecases/search_books_by_subject_usecase.dart';
import '../../../domain/usecases/get_book_by_isbn_usecase.dart';
import '../../../domain/usecases/search_books_by_year_usecase.dart';
import '../../../domain/usecases/search_articles_usecase.dart';
import '../../../domain/usecases/get_recent_articles_usecase.dart';
import '../../../domain/usecases/get_article_by_id_usecase.dart';
import '../../../domain/usecases/search_articles_by_author_usecase.dart';
import '../../../domain/usecases/search_article_by_doi_usecase.dart';
import '../../../domain/usecases/get_most_cited_articles_usecase.dart';
import '../../../domain/usecases/search_articles_by_year_usecase.dart';
import '../../../shared/service_locator.dart';

class StudentHelpState extends Equatable {
  final List<BookModel> books;
  final List<ArticleModel> articles;
  final bool isLoadingBooks;
  final bool isLoadingArticles;
  final String? errorBooks;
  final String? errorArticles;
  final String? searchQueryBooks;
  final String? searchQueryArticles;

  const StudentHelpState({
    this.books = const [],
    this.articles = const [],
    this.isLoadingBooks = false,
    this.isLoadingArticles = false,
    this.errorBooks,
    this.errorArticles,
    this.searchQueryBooks,
    this.searchQueryArticles,
  });

  StudentHelpState copyWith({
    List<BookModel>? books,
    List<ArticleModel>? articles,
    bool? isLoadingBooks,
    bool? isLoadingArticles,
    String? errorBooks,
    String? errorArticles,
    String? searchQueryBooks,
    String? searchQueryArticles,
  }) {
    return StudentHelpState(
      books: books ?? this.books,
      articles: articles ?? this.articles,
      isLoadingBooks: isLoadingBooks ?? this.isLoadingBooks,
      isLoadingArticles: isLoadingArticles ?? this.isLoadingArticles,
      errorBooks: errorBooks ?? this.errorBooks,
      errorArticles: errorArticles ?? this.errorArticles,
      searchQueryBooks: searchQueryBooks ?? this.searchQueryBooks,
      searchQueryArticles: searchQueryArticles ?? this.searchQueryArticles,
    );
  }

  @override
  List<Object?> get props => [
        books,
        articles,
        isLoadingBooks,
        isLoadingArticles,
        errorBooks,
        errorArticles,
        searchQueryBooks,
        searchQueryArticles,
      ];
}

class StudentHelpCubit extends Cubit<StudentHelpState> {
  final SearchBooksUseCase _searchBooksUseCase;
  final GetPopularBooksUseCase _getPopularBooksUseCase;
  final GetBookByKeyUseCase _getBookByKeyUseCase;
  final SearchBooksByAuthorUseCase _searchBooksByAuthorUseCase;
  final SearchBooksBySubjectUseCase _searchBooksBySubjectUseCase;
  final GetBookByIsbnUseCase _getBookByIsbnUseCase;
  final SearchBooksByYearUseCase _searchBooksByYearUseCase;
  final SearchArticlesUseCase _searchArticlesUseCase;
  final GetRecentArticlesUseCase _getRecentArticlesUseCase;
  final GetArticleByIdUseCase _getArticleByIdUseCase;
  final SearchArticlesByAuthorUseCase _searchArticlesByAuthorUseCase;
  final SearchArticleByDoiUseCase _searchArticleByDoiUseCase;
  final GetMostCitedArticlesUseCase _getMostCitedArticlesUseCase;
  final SearchArticlesByYearUseCase _searchArticlesByYearUseCase;

  StudentHelpCubit({
    SearchBooksUseCase? searchBooksUseCase,
    GetPopularBooksUseCase? getPopularBooksUseCase,
    GetBookByKeyUseCase? getBookByKeyUseCase,
    SearchBooksByAuthorUseCase? searchBooksByAuthorUseCase,
    SearchBooksBySubjectUseCase? searchBooksBySubjectUseCase,
    GetBookByIsbnUseCase? getBookByIsbnUseCase,
    SearchBooksByYearUseCase? searchBooksByYearUseCase,
    SearchArticlesUseCase? searchArticlesUseCase,
    GetRecentArticlesUseCase? getRecentArticlesUseCase,
    GetArticleByIdUseCase? getArticleByIdUseCase,
    SearchArticlesByAuthorUseCase? searchArticlesByAuthorUseCase,
    SearchArticleByDoiUseCase? searchArticleByDoiUseCase,
    GetMostCitedArticlesUseCase? getMostCitedArticlesUseCase,
    SearchArticlesByYearUseCase? searchArticlesByYearUseCase,
  })  : _searchBooksUseCase = searchBooksUseCase ?? locator<SearchBooksUseCase>(),
        _getPopularBooksUseCase = getPopularBooksUseCase ?? locator<GetPopularBooksUseCase>(),
        _getBookByKeyUseCase = getBookByKeyUseCase ?? locator<GetBookByKeyUseCase>(),
        _searchBooksByAuthorUseCase = searchBooksByAuthorUseCase ?? locator<SearchBooksByAuthorUseCase>(),
        _searchBooksBySubjectUseCase = searchBooksBySubjectUseCase ?? locator<SearchBooksBySubjectUseCase>(),
        _getBookByIsbnUseCase = getBookByIsbnUseCase ?? locator<GetBookByIsbnUseCase>(),
        _searchBooksByYearUseCase = searchBooksByYearUseCase ?? locator<SearchBooksByYearUseCase>(),
        _searchArticlesUseCase = searchArticlesUseCase ?? locator<SearchArticlesUseCase>(),
        _getRecentArticlesUseCase = getRecentArticlesUseCase ?? locator<GetRecentArticlesUseCase>(),
        _getArticleByIdUseCase = getArticleByIdUseCase ?? locator<GetArticleByIdUseCase>(),
        _searchArticlesByAuthorUseCase = searchArticlesByAuthorUseCase ?? locator<SearchArticlesByAuthorUseCase>(),
        _searchArticleByDoiUseCase = searchArticleByDoiUseCase ?? locator<SearchArticleByDoiUseCase>(),
        _getMostCitedArticlesUseCase = getMostCitedArticlesUseCase ?? locator<GetMostCitedArticlesUseCase>(),
        _searchArticlesByYearUseCase = searchArticlesByYearUseCase ?? locator<SearchArticlesByYearUseCase>(),
        super(const StudentHelpState()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadPopularBooks(),
      loadRecentArticles(),
    ]);
  }

  Future<void> loadPopularBooks() async {
    emit(state.copyWith(isLoadingBooks: true, errorBooks: null));
    try {
      final books = await _getPopularBooksUseCase();
      emit(state.copyWith(books: books, isLoadingBooks: false));
    } catch (e) {
      emit(state.copyWith(
        errorBooks: e.toString(),
        isLoadingBooks: false,
      ));
    }
  }

  Future<void> searchBooks(String query) async {
    if (query.trim().isEmpty) {
      await loadPopularBooks();
      return;
    }

    emit(state.copyWith(isLoadingBooks: true, errorBooks: null, searchQueryBooks: query));
    try {
      final books = await _searchBooksUseCase(query);
      emit(state.copyWith(books: books, isLoadingBooks: false));
    } catch (e) {
      emit(state.copyWith(
        errorBooks: e.toString(),
        isLoadingBooks: false,
      ));
    }
  }

  Future<void> searchBooksByAuthor(String authorName) async {
    if (authorName.trim().isEmpty) {
      await loadPopularBooks();
      return;
    }

    emit(state.copyWith(isLoadingBooks: true, errorBooks: null, searchQueryBooks: 'Автор: $authorName'));
    try {
      final books = await _searchBooksByAuthorUseCase(authorName);
      emit(state.copyWith(books: books, isLoadingBooks: false));
    } catch (e) {
      emit(state.copyWith(
        errorBooks: e.toString(),
        isLoadingBooks: false,
      ));
    }
  }

  Future<void> searchBooksBySubject(String subject) async {
    if (subject.trim().isEmpty) {
      await loadPopularBooks();
      return;
    }

    emit(state.copyWith(isLoadingBooks: true, errorBooks: null, searchQueryBooks: 'Предмет: $subject'));
    try {
      final books = await _searchBooksBySubjectUseCase(subject);
      emit(state.copyWith(books: books, isLoadingBooks: false));
    } catch (e) {
      emit(state.copyWith(
        errorBooks: e.toString(),
        isLoadingBooks: false,
      ));
    }
  }

  Future<void> searchBooksByYear(int year, {String? query}) async {
    emit(state.copyWith(isLoadingBooks: true, errorBooks: null, searchQueryBooks: 'Год: $year'));
    try {
      print('🔍 Cubit: поиск книг по году $year, query: ${query ?? "не указан"}');
      final books = await _searchBooksByYearUseCase(year, query: query);
      print('✅ Cubit: найдено книг: ${books.length}');
      emit(state.copyWith(books: books, isLoadingBooks: false));
    } catch (e, stackTrace) {
      print('❌ Cubit: ошибка при поиске по году: $e');
      print('Stack trace: $stackTrace');
      emit(state.copyWith(
        errorBooks: e.toString(),
        isLoadingBooks: false,
      ));
    }
  }

  Future<BookModel?> getBookByKey(String key) async {
    try {
      return await _getBookByKeyUseCase(key);
    } catch (e) {
      emit(state.copyWith(errorBooks: e.toString()));
      return null;
    }
  }

  Future<BookModel?> getBookByIsbn(String isbn) async {
    emit(state.copyWith(isLoadingBooks: true, errorBooks: null));
    try {
      final book = await _getBookByIsbnUseCase(isbn);
      emit(state.copyWith(isLoadingBooks: false));
      if (book != null) {
        emit(state.copyWith(books: [book]));
      }
      return book;
    } catch (e) {
      emit(state.copyWith(
        errorBooks: e.toString(),
        isLoadingBooks: false,
      ));
      return null;
    }
  }

  Future<void> loadRecentArticles() async {
    emit(state.copyWith(isLoadingArticles: true, errorArticles: null));
    try {
      final articles = await _getRecentArticlesUseCase();
      emit(state.copyWith(articles: articles, isLoadingArticles: false));
    } catch (e) {
      emit(state.copyWith(
        errorArticles: e.toString(),
        isLoadingArticles: false,
      ));
    }
  }

  Future<void> searchArticles(String query) async {
    if (query.trim().isEmpty) {
      await loadRecentArticles();
      return;
    }

    emit(state.copyWith(isLoadingArticles: true, errorArticles: null, searchQueryArticles: query));
    try {
      final articles = await _searchArticlesUseCase(query);
      emit(state.copyWith(articles: articles, isLoadingArticles: false));
    } catch (e) {
      emit(state.copyWith(
        errorArticles: e.toString(),
        isLoadingArticles: false,
      ));
    }
  }

  Future<ArticleModel?> getArticleById(String id) async {
    try {
      return await _getArticleByIdUseCase(id);
    } catch (e) {
      emit(state.copyWith(errorArticles: e.toString()));
      return null;
    }
  }

  Future<void> searchArticlesByAuthor(String authorId, {String? searchQuery}) async {
    emit(state.copyWith(isLoadingArticles: true, errorArticles: null));
    try {
      final articles = await _searchArticlesByAuthorUseCase(authorId, searchQuery: searchQuery);
      emit(state.copyWith(articles: articles, isLoadingArticles: false));
    } catch (e) {
      emit(state.copyWith(
        errorArticles: e.toString(),
        isLoadingArticles: false,
      ));
    }
  }

  Future<ArticleModel?> searchArticleByDoi(String doi) async {
    emit(state.copyWith(isLoadingArticles: true, errorArticles: null));
    try {
      final article = await _searchArticleByDoiUseCase(doi);
      emit(state.copyWith(isLoadingArticles: false));
      if (article != null) {
        emit(state.copyWith(articles: [article]));
      }
      return article;
    } catch (e) {
      emit(state.copyWith(
        errorArticles: e.toString(),
        isLoadingArticles: false,
      ));
      return null;
    }
  }

  Future<void> loadMostCitedArticles({String? category, String? searchQuery}) async {
    emit(state.copyWith(isLoadingArticles: true, errorArticles: null));
    try {
      final articles = await _getMostCitedArticlesUseCase(category: category, searchQuery: searchQuery);
      emit(state.copyWith(articles: articles, isLoadingArticles: false));
    } catch (e) {
      emit(state.copyWith(
        errorArticles: e.toString(),
        isLoadingArticles: false,
      ));
    }
  }

  Future<void> searchArticlesByYear(int year, {String? searchQuery, String? category}) async {
    emit(state.copyWith(isLoadingArticles: true, errorArticles: null));
    try {
      final articles = await _searchArticlesByYearUseCase(year, searchQuery: searchQuery, category: category);
      emit(state.copyWith(articles: articles, isLoadingArticles: false));
    } catch (e) {
      emit(state.copyWith(
        errorArticles: e.toString(),
        isLoadingArticles: false,
      ));
    }
  }
}

