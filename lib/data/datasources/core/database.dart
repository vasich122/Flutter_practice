import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';




// Таблица заявок
class Applications extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get description => text()();
  TextColumn get status => text()();
  TextColumn get date => text()();
  IntColumn get editable => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

class Attendance extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get subject => text()();
  TextColumn get lecturer => text()();
  IntColumn get attendance => integer()();
  IntColumn get missed => integer()();
}

class AttendanceClassrooms extends Table {
  TextColumn get subject => text()();
  TextColumn get classroom => text()();

  @override
  Set<Column> get primaryKey => {subject};
}

class Courses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
}

class CourseModules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get courseId => integer()();
  TextColumn get moduleName => text()();
}

class CourseModuleNotes extends Table {
  TextColumn get moduleName => text()();
  TextColumn get note => text()();

  @override
  Set<Column> get primaryKey => {moduleName};
}

class Grades extends Table {
  TextColumn get id => text()();
  TextColumn get subject => text()();
  RealColumn get grade => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class GradeNotes extends Table {
  TextColumn get gradeId => text()();
  TextColumn get note => text()();

  @override
  Set<Column> get primaryKey => {gradeId};
}


@DriftDatabase(
  tables: [
    Grades,
    Applications,
    Attendance,
    AttendanceClassrooms,
    Courses,
    CourseModules,
    CourseModuleNotes,
    GradeNotes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _insertInitialData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Удаляем старые таблицы, которые теперь хранятся в SharedPreferences
          await m.database.executor.runCustom('DROP TABLE IF EXISTS grade_notes');
          await m.database.executor.runCustom('DROP TABLE IF EXISTS attendance_classrooms');
          await m.database.executor.runCustom('DROP TABLE IF EXISTS course_module_notes');
        }
        if (from < 3) {
          // Создаем новую таблицу GradeNotes в SQLite
          await m.createTable(gradeNotes);
        }
        if (from < 4) {
          // Создаем новую таблицу AttendanceClassrooms в SQLite
          await m.createTable(attendanceClassrooms);
        }
        if (from < 5) {
          // Создаем новую таблицу CourseModuleNotes в SQLite
          await m.createTable(courseModuleNotes);
        }
      },
    );
  }

  Future<void> _insertInitialData() async {
    // Начальные оценки
    final gradesData = [
      GradesCompanion.insert(
        id: 'g1',
        subject: 'Математический анализ',
        grade: 4.7,
      ),
      GradesCompanion.insert(
        id: 'g2',
        subject: 'Алгоритмы и структуры данных',
        grade: 4.9,
      ),
      GradesCompanion.insert(id: 'g3', subject: 'Базы данных', grade: 4.6),
      GradesCompanion.insert(
        id: 'g4',
        subject: 'Проектирование ПО',
        grade: 4.8,
      ),
      GradesCompanion.insert(
        id: 'g5',
        subject: 'Машинное обучение',
        grade: 4.5,
      ),
    ];
    for (final grade in gradesData) {
      await into(grades).insert(grade);
    }

    // Начальная посещаемость
    final attendanceData = [
      AttendanceCompanion.insert(
        subject: 'Математический анализ',
        lecturer: 'Петров Н.Н.',
        attendance: 96,
        missed: 1,
      ),
      AttendanceCompanion.insert(
        subject: 'Алгоритмы и структуры данных',
        lecturer: 'Иванова Л.С.',
        attendance: 92,
        missed: 2,
      ),
      AttendanceCompanion.insert(
        subject: 'Базы данных',
        lecturer: 'Соколов Д.В.',
        attendance: 88,
        missed: 3,
      ),
      AttendanceCompanion.insert(
        subject: 'Проектирование UI/UX',
        lecturer: 'Громова Е.А.',
        attendance: 100,
        missed: 0,
      ),
      AttendanceCompanion.insert(
        subject: 'Машинное обучение',
        lecturer: 'Козлов А.И.',
        attendance: 85,
        missed: 4,
      ),
    ];
    for (final record in attendanceData) {
      await into(attendance).insert(record);
    }

    // Начальные курсы
    final modulesData = [
      [
        'Математический анализ',
        'Линейная алгебра',
        'Алгоритмы и структуры данных',
        'Основы программирования на Dart',
      ],
      [
        'Операционные системы',
        'Базы данных и SQL',
        'Паттерны проектирования',
        'Мобильная разработка (Flutter)',
      ],
      [
        'Разработка UI/UX',
        'Инженерия требований',
        'Микросервисная архитектура',
        'Научно-исследовательский семинар',
      ],
      [
        'Проектирование распределённых систем',
        'Машинное обучение',
        'Производственная практика',
        'Преддипломная практика',
      ],
    ];

    final coursesData = [
      {
        'title': '1 курс',
        'description': 'Базовая подготовка по математике и алгоритмам',
      },
      {
        'title': '2 курс',
        'description': 'Инженерные дисциплины и проектирование приложений',
      },
      {
        'title': '3 курс',
        'description': 'Продвинутая разработка и проектная деятельность',
      },
      {
        'title': '4 курс',
        'description': 'Дипломное проектирование и индустриальные практики',
      },
    ];

    for (int i = 0; i < coursesData.length; i++) {
      final courseId = await into(courses)
          .insert(
            CoursesCompanion.insert(
              title: coursesData[i]['title'] as String,
              description: coursesData[i]['description'] as String,
            ),
          );

      for (final module in modulesData[i]) {
        await into(courseModules)
            .insert(
              CourseModulesCompanion.insert(
                courseId: courseId,
                moduleName: module,
              ),
            );
      }
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'student_app.db'));
    return NativeDatabase(file, logStatements: true);
  });
}
