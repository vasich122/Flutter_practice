class MathTestModel {
  final String id;
  final String title;
  final String description;
  final String topic;
  final int questionCount;
  final String difficulty;
  final String? category;

  MathTestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    required this.questionCount,
    required this.difficulty,
    this.category,
  });

  MathTestModel copyWith({
    String? id,
    String? title,
    String? description,
    String? topic,
    int? questionCount,
    String? difficulty,
    String? category,
  }) {
    return MathTestModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      topic: topic ?? this.topic,
      questionCount: questionCount ?? this.questionCount,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
    );
  }
}

