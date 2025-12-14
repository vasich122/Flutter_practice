import '../../core/models/attendance_record_model.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceRecordModel>> getAttendanceRecords();

  Future<void> saveClassroom(String subject, String classroom);

  Future<String?> getClassroom(String subject);
}

