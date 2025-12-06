/// Локальный источник данных для посещаемости
class AttendanceLocalDataSource {
  final List<Map<String, dynamic>> _records = [
    {
      'subject': 'Математический анализ',
      'lecturer': 'Петров Н.Н.',
      'attendance': 96,
      'missed': 1,
    },
    {
      'subject': 'Алгоритмы и структуры данных',
      'lecturer': 'Иванова Л.С.',
      'attendance': 92,
      'missed': 2,
    },
    {
      'subject': 'Базы данных',
      'lecturer': 'Соколов Д.В.',
      'attendance': 88,
      'missed': 3,
    },
    {
      'subject': 'Проектирование UI/UX',
      'lecturer': 'Громова Е.А.',
      'attendance': 100,
      'missed': 0,
    },
    {
      'subject': 'Машинное обучение',
      'lecturer': 'Козлов А.И.',
      'attendance': 85,
      'missed': 4,
    },
  ];

  final Map<String, String> _classrooms = {};

  Future<List<Map<String, dynamic>>> getRecords() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_records);
  }

  Future<void> saveClassroom(String subject, String classroom) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _classrooms[subject] = classroom;
  }

  Future<String?> getClassroom(String subject) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _classrooms[subject];
  }
}

