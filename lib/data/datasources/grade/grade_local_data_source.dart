import 'grade_dto.dart';
import '../core/database_helper.dart';
import 'package:drift/drift.dart';

class GradeLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<GradeDto>> getGrades() async {
    final db = _dbHelper.database;
    final query = db.select(db.grades)..orderBy([(g) => OrderingTerm(expression: g.subject)]);
    final gradesList = await query.get();
    
    return gradesList.map((grade) => GradeDto(
      id: grade.id,
      subject: grade.subject,
      grade: grade.grade,
    )).toList();
  }

  Future<GradeDto?> getGradeById(String id) async {
    final db = _dbHelper.database;
    final query = db.select(db.grades)..where((g) => g.id.equals(id));
    final grade = await query.getSingleOrNull();
    
    if (grade == null) return null;
    return GradeDto(
      id: grade.id,
      subject: grade.subject,
      grade: grade.grade,
    );
  }

  Future<void> saveNote(String gradeId, String note) async {
    final db = _dbHelper.database;
    await db.into(db.gradeNotes).insert(
      GradeNotesCompanion.insert(
        gradeId: gradeId,
        note: note,
      ),
      mode: InsertMode.replace,
    );
  }

  Future<void> deleteNote(String gradeId) async {
    final db = _dbHelper.database;
    await (db.delete(db.gradeNotes)..where((n) => n.gradeId.equals(gradeId))).go();
  }

  Future<String?> getNote(String gradeId) async {
    final db = _dbHelper.database;
    final query = db.select(db.gradeNotes)..where((n) => n.gradeId.equals(gradeId));
    final note = await query.getSingleOrNull();
    return note?.note;
  }
}

