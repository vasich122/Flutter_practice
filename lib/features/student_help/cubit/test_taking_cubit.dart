import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/question_model.dart';
import '../../../domain/usecases/get_test_questions_usecase.dart';
import '../../../shared/service_locator.dart';

class TestTakingState extends Equatable {
  final List<QuestionModel> questions;
  final int currentQuestionIndex;
  final bool isLoading;
  final String? error;
  final bool isCompleted;
  final int correctAnswers;
  final int totalQuestions;

  const TestTakingState({
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.isLoading = false,
    this.error,
    this.isCompleted = false,
    this.correctAnswers = 0,
    this.totalQuestions = 0,
  });

  QuestionModel? get currentQuestion {
    if (currentQuestionIndex >= 0 && currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  double get progress => totalQuestions > 0 ? (currentQuestionIndex + 1) / totalQuestions : 0.0;

  double get score => totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;

  TestTakingState copyWith({
    List<QuestionModel>? questions,
    int? currentQuestionIndex,
    bool? isLoading,
    String? error,
    bool? isCompleted,
    int? correctAnswers,
    int? totalQuestions,
  }) {
    return TestTakingState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isCompleted: isCompleted ?? this.isCompleted,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }

  @override
  List<Object?> get props => [
        questions,
        currentQuestionIndex,
        isLoading,
        error,
        isCompleted,
        correctAnswers,
        totalQuestions,
      ];
}

class TestTakingCubit extends Cubit<TestTakingState> {
  final GetTestQuestionsUseCase _getTestQuestionsUseCase;

  TestTakingCubit({
    GetTestQuestionsUseCase? getTestQuestionsUseCase,
  })  : _getTestQuestionsUseCase =
            getTestQuestionsUseCase ?? locator<GetTestQuestionsUseCase>(),
        super(const TestTakingState());

  /// Загрузить вопросы теста
  Future<void> loadQuestions(String testId, String difficulty) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final questions = await _getTestQuestionsUseCase(testId, difficulty);
      emit(state.copyWith(
        questions: questions,
        isLoading: false,
        totalQuestions: questions.length,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  /// Выбрать ответ на текущий вопрос
  void selectAnswer(String answer) {
    if (state.currentQuestion == null) return;

    final updatedQuestions = List<QuestionModel>.from(state.questions);
    final currentIndex = state.currentQuestionIndex;
    updatedQuestions[currentIndex] = updatedQuestions[currentIndex].copyWith(
      selectedAnswer: answer,
    );

    emit(state.copyWith(questions: updatedQuestions));
  }

  /// Перейти к следующему вопросу
  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1));
    } else {
      // Тест завершен, подсчитываем результаты
      _calculateResults();
    }
  }

  /// Перейти к предыдущему вопросу
  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1));
    }
  }

  /// Завершить тест и показать результаты
  void finishTest() {
    _calculateResults();
  }

  void _calculateResults() {
    int correct = 0;
    for (final question in state.questions) {
      if (question.isCorrect) {
        correct++;
      }
    }

    emit(state.copyWith(
      isCompleted: true,
      correctAnswers: correct,
    ));
  }

  /// Сбросить тест
  void reset() {
    emit(const TestTakingState());
  }
}

