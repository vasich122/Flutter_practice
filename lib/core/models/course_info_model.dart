/// Бизнес-модель информации о курсе
/// Представляет информацию об учебном курсе
class CourseInfoModel {
  final String title;
  final String description;
  final List<String> modules;
  final Map<String, String> notes; // module -> note

  const CourseInfoModel({
    required this.title,
    required this.description,
    required this.modules,
    this.notes = const {},
  });

  CourseInfoModel copyWith({
    String? title,
    String? description,
    List<String>? modules,
    Map<String, String>? notes,
  }) {
    return CourseInfoModel(
      title: title ?? this.title,
      description: description ?? this.description,
      modules: modules ?? this.modules,
      notes: notes ?? this.notes,
    );
  }
}

