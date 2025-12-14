import '../../core/models/attendance_record_model.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance/attendance_local_data_source.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceLocalDataSource _localDataSource;

  AttendanceRepositoryImpl(this._localDataSource);

  @override
  Future<List<AttendanceRecordModel>> getAttendanceRecords() async {
    final records = await _localDataSource.getRecords();
    // Получаем все кабинеты одним запросом для оптимизации
    final classrooms = await _localDataSource.getAllClassrooms();

    return records.map((record) {
      return AttendanceRecordModel(
        subject: record['subject'] as String,
        lecturer: record['lecturer'] as String,
        attendance: record['attendance'] as int,
        missed: record['missed'] as int,
        classroom: classrooms[record['subject'] as String],
      );
    }).toList();
  }

  @override
  Future<void> saveClassroom(String subject, String classroom) async {
    await _localDataSource.saveClassroom(subject, classroom);
  }

  @override
  Future<String?> getClassroom(String subject) async {
    return await _localDataSource.getClassroom(subject);
  }
}

