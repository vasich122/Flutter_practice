import 'grade_dto.dart';
import '../core/database_helper.dart';
import 'package:sqflite/sqflite.dart';
class GradeLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<GradeDto>> getGrades() async {
    final db = await _dbHelper.database;
    final maps = await db.query('grades', orderBy: 'subject ASC');
    return maps.map((map) => GradeDto.fromJson(map)).toList();
  }

  Future<GradeDto?> getGradeById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'grades',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return GradeDto.fromJson(maps.first);
  }

  Future<void> saveNote(String gradeId, String note) async {
    final db = await _dbHelper.database;
    await db.insert(
      'grade_notes',
      {'grade_id': gradeId, 'note': note},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getNote(String gradeId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'grade_notes',
      where: 'grade_id = ?',
      whereArgs: [gradeId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first['note'] as String?;
  }
}

