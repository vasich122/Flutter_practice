import 'grade_dto.dart';
class GradeLocalDataSource {
  final List<GradeDto> _grades = [
    GradeDto(id: 'g1', subject: 'Математический анализ', grade: 4.7),
    GradeDto(id: 'g2', subject: 'Алгоритмы и структуры данных', grade: 4.9),
    GradeDto(id: 'g3', subject: 'Базы данных', grade: 4.6),
    GradeDto(id: 'g4', subject: 'Проектирование ПО', grade: 4.8),
    GradeDto(id: 'g5', subject: 'Машинное обучение', grade: 4.5),
  ];

  final Map<String, String> _notes = {};

  Future<List<GradeDto>> getGrades() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_grades);
  }

  Future<GradeDto?> getGradeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _grades.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveNote(String gradeId, String note) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _notes[gradeId] = note;
  }

  Future<String?> getNote(String gradeId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _notes[gradeId];
  }
}

