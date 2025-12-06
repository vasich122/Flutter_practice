class ApplicationDto {
  final String id;
  final String type;
  final String description;
  final String status;
  final DateTime date;
  final bool editable;

  ApplicationDto({
    required this.id,
    required this.type,
    required this.description,
    required this.status,
    required this.date,
    this.editable = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'description': description,
        'status': status,
        'date': date.toIso8601String(),
        'editable': editable,
      };

  factory ApplicationDto.fromJson(Map<String, dynamic> json) => ApplicationDto(
        id: json['id'] as String,
        type: json['type'] as String,
        description: json['description'] as String,
        status: json['status'] as String,
        date: DateTime.parse(json['date'] as String),
        editable: json['editable'] as bool? ?? true,
      );
}

