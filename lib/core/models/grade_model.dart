class GradeModel {
  final String id;
  final String subject;
  final double grade;

  GradeModel({
    required this.id,
    required this.subject,
    required this.grade,
  });

  GradeModel copyWith({
    String? id,
    String? subject,
    double? grade,
  }) {
    return GradeModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      grade: grade ?? this.grade,
    );
  }
}

