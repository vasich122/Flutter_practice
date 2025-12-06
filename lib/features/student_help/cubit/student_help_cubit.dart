import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/book_model.dart';
import '../../../core/models/math_test_model.dart';
import '../../../core/models/article_model.dart';
import '../../../domain/usecases/search_books_usecase.dart';
import '../../../domain/usecases/get_popular_books_usecase.dart';
import '../../../domain/usecases/get_math_tests_usecase.dart';
import '../../../domain/usecases/search_articles_usecase.dart';
import '../../../domain/usecases/get_recent_articles_usecase.dart';
import '../../../shared/service_locator.dart';

class StudentHelpState extends Equatable {
  final List<BookModel> books;
  final List<MathTestModel> mathTests;
  final List<ArticleModel> articles;
  final bool isLoadingBooks;
  final bool isLoadingTests;
  final bool isLoadingArticles;
  final String? errorBooks;
  final String? errorTests;
  final String? errorArticles;
  final String? searchQueryBooks;
  final String? searchQueryArticles;

  const StudentHelpState({
    this.books = const [],
    this.mathTests = const [],
    this.articles = const [],
    this.isLoadingBooks = false,
    this.isLoadingTests = false,
    this.isLoadingArticles = false,
    this.errorBooks,
    this.errorTests,
    this.errorArticles,
    this.searchQueryBooks,
    this.searchQueryArticles,
  });

  StudentHelpState copyWith({
    List<BookModel>? books,
    List<MathTestModel>? mathTests,
    List<ArticleModel>? articles,
    bool? isLoadingBooks,
    bool? isLoadingTests,
    bool? isLoadingArticles,
    String? errorBooks,
    String? errorTests,
    String? errorArticles,
    String? searchQueryBooks,
    String? searchQueryArticles,
  }) {
    return StudentHelpState(
      books: books ?? this.books,
      mathTests: mathTests ?? this.mathTests,
      articles: articles ?? this.articles,
      isLoadingBooks: isLoadingBooks ?? this.isLoadingBooks,
      isLoadingTests: isLoadingTests ?? this.isLoadingTests,
      isLoadingArticles: isLoadingArticles ?? this.isLoadingArticles,
      errorBooks: errorBooks ?? this.errorBooks,
      errorTests: errorTests ?? this.errorTests,
      errorArticles: errorArticles ?? this.errorArticles,
      searchQueryBooks: searchQueryBooks ?? this.searchQueryBooks,
      searchQueryArticles: searchQueryArticles ?? this.searchQueryArticles,
    );
  }

  @override
  List<Object?> get props => [
        books,
        mathTests,
        articles,
        isLoadingBooks,
        isLoadingTests,
        isLoadingArticles,
        errorBooks,
        errorTests,
        errorArticles,
        searchQueryBooks,
        searchQueryArticles,
      ];
}

class StudentHelpCubit extends Cubit<StudentHelpState> {
  final SearchBooksUseCase _searchBooksUseCase;
  final GetPopularBooksUseCase _getPopularBooksUseCase;
  final GetMathTestsUseCase _getMathTestsUseCase;
  final SearchArticlesUseCase _searchArticlesUseCase;
  final GetRecentArticlesUseCase _getRecentArticlesUseCase;

  StudentHelpCubit({
    SearchBooksUseCase? searchBooksUseCase,
    GetPopularBooksUseCase? getPopularBooksUseCase,
    GetMathTestsUseCase? getMathTestsUseCase,
    SearchArticlesUseCase? searchArticlesUseCase,
    GetRecentArticlesUseCase? getRecentArticlesUseCase,
  })  : _searchBooksUseCase = searchBooksUseCase ?? locator<SearchBooksUseCase>(),
        _getPopularBooksUseCase = getPopularBooksUseCase ?? locator<GetPopularBooksUseCase>(),
        _getMathTestsUseCase = getMathTestsUseCase ?? locator<GetMathTestsUseCase>(),
        _searchArticlesUseCase = searchArticlesUseCase ?? locator<SearchArticlesUseCase>(),
        _getRecentArticlesUseCase = getRecentArticlesUseCase ?? locator<GetRecentArticlesUseCase>(),
        super(const StudentHelpState()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadPopularBooks(),
      loadMathTests(),
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

  Future<void> loadMathTests({String? topic, String? difficulty}) async {
    emit(state.copyWith(isLoadingTests: true, errorTests: null));
    try {
      final tests = await _getMathTestsUseCase(topic: topic, difficulty: difficulty);
      emit(state.copyWith(mathTests: tests, isLoadingTests: false));
    } catch (e) {
      emit(state.copyWith(
        errorTests: e.toString(),
        isLoadingTests: false,
      ));
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
}

