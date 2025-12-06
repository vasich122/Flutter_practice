class TriviaQuestionDto {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  TriviaQuestionDto({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory TriviaQuestionDto.fromJson(Map<String, dynamic> json) {
    return TriviaQuestionDto(
      category: json['category'] as String? ?? '',
      type: json['type'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      question: json['question'] as String? ?? '',
      correctAnswer: json['correct_answer'] as String? ?? '',
      incorrectAnswers: (json['incorrect_answers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
