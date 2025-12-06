/// Бизнес-модель записи посещаемости
/// Представляет данные о посещаемости по предмету
class AttendanceRecordModel {
  final String subject;
  final String lecturer;
  final int attendance;
  final int missed;
  final String? classroom;

  AttendanceRecordModel({
    required this.subject,
    required this.lecturer,
    required this.attendance,
    required this.missed,
    this.classroom,
  });

  AttendanceRecordModel copyWith({
    String? subject,
    String? lecturer,
    int? attendance,
    int? missed,
    String? classroom,
  }) {
    return AttendanceRecordModel(
      subject: subject ?? this.subject,
      lecturer: lecturer ?? this.lecturer,
      attendance: attendance ?? this.attendance,
      missed: missed ?? this.missed,
      classroom: classroom ?? this.classroom,
    );
  }
}

