import '../../core/models/attendance_record_model.dart';

/// Абстрактный интерфейс репозитория посещаемости
abstract class AttendanceRepository {
  /// Получить все записи посещаемости
  Future<List<AttendanceRecordModel>> getAttendanceRecords();

  /// Сохранить кабинет для предмета
  Future<void> saveClassroom(String subject, String classroom);

  /// Получить кабинет для предмета
  Future<String?> getClassroom(String subject);
}

