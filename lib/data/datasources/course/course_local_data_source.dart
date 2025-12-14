import '../core/database_helper.dart';
import 'package:drift/drift.dart';

class CourseLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> getCourses() async {
    final db = _dbHelper.database;
    final query = db.select(db.courses)..orderBy([(c) => OrderingTerm(expression: c.id)]);
    final coursesList = await query.get();
    
    final result = <Map<String, dynamic>>[];
    for (final course in coursesList) {
      final modulesQuery = db.select(db.courseModules)
        ..where((m) => m.courseId.equals(course.id))
        ..orderBy([(m) => OrderingTerm(expression: m.id)]);
      final modules = await modulesQuery.get();
      
      result.add({
        'title': course.title,
        'description': course.description,
        'modules': modules.map((m) => m.moduleName).toList(),
      });
    }
    
    return result;
  }

  Future<void> saveNote(String moduleName, String note) async {
    final db = _dbHelper.database;
    await db.into(db.courseModuleNotes).insert(
      CourseModuleNotesCompanion.insert(
        moduleName: moduleName,
        note: note,
      ),
      mode: InsertMode.replace,
    );
  }

  Future<void> deleteNote(String moduleName) async {
    final db = _dbHelper.database;
    await (db.delete(db.courseModuleNotes)
      ..where((n) => n.moduleName.equals(moduleName))).go();
  }

  Future<String?> getNote(String moduleName) async {
    final db = _dbHelper.database;
    final query = db.select(db.courseModuleNotes)
      ..where((n) => n.moduleName.equals(moduleName));
    final note = await query.getSingleOrNull();
    return note?.note;
  }

  Future<Map<String, String>> getAllNotes() async {
    final db = _dbHelper.database;
    final query = db.select(db.courseModuleNotes);
    final notes = await query.get();
    
    return {for (var n in notes) n.moduleName: n.note};
  }
}

