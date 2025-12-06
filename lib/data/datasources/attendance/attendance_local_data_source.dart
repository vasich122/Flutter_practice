import '../core/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class AttendanceLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> getRecords() async {
    final db = await _dbHelper.database;
    final maps = await db.query('attendance', orderBy: 'subject ASC');
    return maps.map((map) => {
      'subject': map['subject'] as String,
      'lecturer': map['lecturer'] as String,
      'attendance': map['attendance'] as int,
      'missed': map['missed'] as int,
    }).toList();
  }

  Future<void> saveClassroom(String subject, String classroom) async {
    final db = await _dbHelper.database;
    await db.insert(
      'attendance_classrooms',
      {'subject': subject, 'classroom': classroom},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getClassroom(String subject) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'attendance_classrooms',
      where: 'subject = ?',
      whereArgs: [subject],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first['classroom'] as String?;
  }
}

