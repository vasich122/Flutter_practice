class MathTestDto {
  final String id;
  final String title;
  final String description;
  final String topic;
  final int questionCount;
  final String difficulty;
  final String? category;

  MathTestDto({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    required this.questionCount,
    required this.difficulty,
    this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'topic': topic,
        'questionCount': questionCount,
        'difficulty': difficulty,
        'category': category,
      };

  factory MathTestDto.fromJson(Map<String, dynamic> json) => MathTestDto(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        topic: json['topic'] as String,
        questionCount: json['questionCount'] as int,
        difficulty: json['difficulty'] as String,
        category: json['category'] as String?,
      );

  /// Создать DTO из данных Open Trivia Database API
  factory MathTestDto.fromTriviaApi({
    required String difficulty,
    required int questionCount,
    String? topic,
  }) {
    // Маппинг сложности
    String difficultyRu;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        difficultyRu = 'легкий';
        break;
      case 'medium':
        difficultyRu = 'средний';
        break;
      case 'hard':
        difficultyRu = 'сложный';
        break;
      default:
        difficultyRu = 'средний';
    }

    // Генерация названия и описания на основе сложности
    String title;
    String description;
    String topic;

    switch (difficultyRu) {
      case 'легкий':
        title = 'Математика: базовый уровень';
        description = 'Тест по основам математики: арифметика, простые уравнения, геометрия';
        topic = 'Базовая математика';
        break;
      case 'средний':
        title = 'Математика: средний уровень';
        description = 'Тест по алгебре, геометрии и основам математического анализа';
        topic = 'Алгебра и геометрия';
        break;
      case 'сложный':
        title = 'Математика: продвинутый уровень';
        description = 'Тест по высшей математике: математический анализ, линейная алгебра, теория вероятностей';
        topic = 'Высшая математика';
        break;
      default:
        title = 'Математика';
        description = 'Тест по математике';
        topic = 'Математика';
    }

    return MathTestDto(
      id: 'math_${difficulty}_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      topic: topic,
      questionCount: questionCount,
      difficulty: difficultyRu,
      category: 'математика',
    );
  }
}
