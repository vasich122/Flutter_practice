import 'package:flutter/material.dart';
import 'features/academic/screens/academic_screen.dart';
import 'features/course/screens/course_screen.dart';
import 'features/attendance/screens/attendance_screen.dart';
import 'features/grade/state/grades_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Личный кабинет студента',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Профиль студента'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _statuses = [
    'Студент активен',
    'Студент на паре',
    'Студент сдал работу',
    'Студент отсутствует',
  ];

  int _statusIndex = 0;
  String _currentCourse = '3 курс';
  int _attendance = 92;

  void _changeStatus() {
    setState(() {
      _statusIndex = (_statusIndex + 1) % _statuses.length;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Текущий статус: ${_statuses[_statusIndex]}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _goToCourseScreen() async {
    final selectedCourse = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseScreen(currentCourse: _currentCourse),
      ),
    );

    if (selectedCourse != null) {
      setState(() {
        _currentCourse = selectedCourse;
      });
    }
  }

  Future<void> _goToAttendanceScreen() async {
    final updatedAttendance = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceScreen(currentAttendance: _attendance),
      ),
    );

    if (updatedAttendance != null) {
      setState(() {
        _attendance = updatedAttendance;
      });
    }
  }

  void _goToAcademicScreen(double averageGrade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcademicScreen(
          currentCourse: _currentCourse,
          initialAttendance: _attendance,
          averageGrade: averageGrade,
        ),
      ),
    );
  }

  Future<void> _goToGradesContainer() async {
    final updatedAverage = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (context) => const GradesContainer(),
      ),
    );

    if (updatedAverage != null) {
      _goToAcademicScreen(updatedAverage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Соваренко Василий Васильевич\nГруппа: ИКБО-06-22\nID: 22И1798',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: _changeStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(_statuses[_statusIndex]),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToCourseScreen,
              child: const Text('Выбрать курс'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToAttendanceScreen,
              child: Text('Изменить посещаемость ($_attendance%)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToGradesContainer,
              child: const Text('Управление оценками'),
            ),
          ],
        ),
      ),
    );
  }
}