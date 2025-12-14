import '../core/database_helper.dart';
import 'package:drift/drift.dart';

class AttendanceLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> getRecords() async {
    final db = _dbHelper.database;
    final query = db.select(db.attendance)..orderBy([(a) => OrderingTerm(expression: a.subject)]);
    final attendanceList = await query.get();
    
    return attendanceList.map((record) => {
      'subject': record.subject,
      'lecturer': record.lecturer,
      'attendance': record.attendance,
      'missed': record.missed,
    }).toList();
  }

  Future<void> saveClassroom(String subject, String classroom) async {
    final db = _dbHelper.database;
    await db.into(db.attendanceClassrooms).insert(
      AttendanceClassroomsCompanion.insert(
        subject: subject,
        classroom: classroom,
      ),
      mode: InsertMode.replace,
    );
  }

  Future<String?> getClassroom(String subject) async {
    final db = _dbHelper.database;
    final query = db.select(db.attendanceClassrooms)
      ..where((c) => c.subject.equals(subject));
    final classroom = await query.getSingleOrNull();
    return classroom?.classroom;
  }

  Future<Map<String, String>> getAllClassrooms() async {
    final db = _dbHelper.database;
    final query = db.select(db.attendanceClassrooms);
    final classrooms = await query.get();
    
    return {for (var c in classrooms) c.subject: c.classroom};
  }
}

