/// Модель вопроса теста
class QuestionModel {
  final String id;
  final String question;
  final List<String> answers; // Все варианты ответов (перемешанные)
  final String correctAnswer;
  final String? selectedAnswer; // Выбранный пользователем ответ

  QuestionModel({
    required this.id,
    required this.question,
    required this.answers,
    required this.correctAnswer,
    this.selectedAnswer,
  });

  bool get isCorrect => selectedAnswer == correctAnswer;

  QuestionModel copyWith({
    String? id,
    String? question,
    List<String>? answers,
    String? correctAnswer,
    String? selectedAnswer,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answers: answers ?? this.answers,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    );
  }
}

