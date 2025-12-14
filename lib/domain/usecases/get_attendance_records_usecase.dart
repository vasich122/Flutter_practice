import '../../core/models/attendance_record_model.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceRecordsUseCase {
  final AttendanceRepository _repository;

  GetAttendanceRecordsUseCase(this._repository);

  Future<List<AttendanceRecordModel>> call() =>
      _repository.getAttendanceRecords();
}

