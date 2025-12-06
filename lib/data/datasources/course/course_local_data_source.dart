/// Локальный источник данных для курсов
class CourseLocalDataSource {
  final List<Map<String, dynamic>> _courses = [
    {
      'title': '1 курс',
      'description': 'Базовая подготовка по математике и алгоритмам',
      'modules': [
        'Математический анализ',
        'Линейная алгебра',
        'Алгоритмы и структуры данных',
        'Основы программирования на Dart',
      ],
    },
    {
      'title': '2 курс',
      'description': 'Инженерные дисциплины и проектирование приложений',
      'modules': [
        'Операционные системы',
        'Базы данных и SQL',
        'Паттерны проектирования',
        'Мобильная разработка (Flutter)',
      ],
    },
    {
      'title': '3 курс',
      'description': 'Продвинутая разработка и проектная деятельность',
      'modules': [
        'Разработка UI/UX',
        'Инженерия требований',
        'Микросервисная архитектура',
        'Научно-исследовательский семинар',
      ],
    },
    {
      'title': '4 курс',
      'description': 'Дипломное проектирование и индустриальные практики',
      'modules': [
        'Проектирование распределённых систем',
        'Машинное обучение',
        'Производственная практика',
        'Преддипломная практика',
      ],
    },
  ];

  final Map<String, String> _notes = {};

  Future<List<Map<String, dynamic>>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_courses);
  }

  Future<void> saveNote(String module, String note) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _notes[module] = note;
  }

  Future<String?> getNote(String module) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _notes[module];
  }
}

