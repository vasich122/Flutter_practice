import '../core/database_helper.dart';
import 'package:sqflite/sqflite.dart';

/// Локальный источник данных для курсов
/// Использует только SQLite для хранения курсов, модулей и заметок
class CourseLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> getCourses() async {
    final db = await _dbHelper.database;
    final courses = await db.query('courses', orderBy: 'id ASC');
    
    final result = <Map<String, dynamic>>[];
    for (final course in courses) {
      final courseId = course['id'] as int;
      final modules = await db.query(
        'course_modules',
        where: 'course_id = ?',
        whereArgs: [courseId],
        orderBy: 'id ASC',
      );
      
      result.add({
        'title': course['title'] as String,
        'description': course['description'] as String,
        'modules': modules.map((m) => m['module_name'] as String).toList(),
      });
    }
    
    return result;
  }

  Future<void> saveNote(String module, String note) async {
    final db = await _dbHelper.database;
    await db.insert(
      'course_module_notes',
      {'module_name': module, 'note': note},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getNote(String module) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'course_module_notes',
      where: 'module_name = ?',
      whereArgs: [module],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first['note'] as String?;
  }
}

