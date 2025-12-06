/// Бизнес-модель заявления
/// Представляет заявление студента
class ApplicationModel {
  final String id;
  final String type;
  final String description;
  final String status;
  final DateTime date;
  final bool editable;

  ApplicationModel({
    required this.id,
    required this.type,
    required this.description,
    required this.status,
    required this.date,
    this.editable = true,
  });

  ApplicationModel copyWith({
    String? type,
    String? description,
    String? status,
    bool? editable,
  }) {
    return ApplicationModel(
      id: id,
      type: type ?? this.type,
      description: description ?? this.description,
      status: status ?? this.status,
      date: date,
      editable: editable ?? this.editable,
    );
  }
}

