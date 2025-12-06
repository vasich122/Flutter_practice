class GradeDto {
  final String id;
  final String subject;
  final double grade;

  GradeDto({
    required this.id,
    required this.subject,
    required this.grade,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'grade': grade,
      };

  factory GradeDto.fromJson(Map<String, dynamic> json) => GradeDto(
        id: json['id'] as String,
        subject: json['subject'] as String,
        grade: (json['grade'] as num).toDouble(),
      );
}

