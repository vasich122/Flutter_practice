import 'package:flutter/material.dart';
import 'features/course/screens/course_screen.dart';
import 'features/attendance/screens/attendance_screen.dart';
import 'features/grade/state/grades_container.dart';
import 'features/academic/screens/academic_screen.dart';

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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<String> _statuses = [
    'Студент активен',
    'Студент на паре',
    'Студент сдал работу',
    'Студент отсутствует',
  ];

  int _statusIndex = 0;
  String _currentCourse = '3 курс';
  int _attendance = 92;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

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

  // Универсальный метод для push с кнопкой pop
  void _navigateWithPop(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('Навигация'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: screen,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Успеваемость'),
            Tab(text: 'Академ. инфо'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _navigateWithPop(
                  AttendanceScreen(currentAttendance: _attendance),
                ),
                child: const Text('Посещаемость'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _navigateWithPop(
                  const GradesContainer(),
                ),
                child: const Text('Оценки'),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _navigateWithPop(
                  AcademicScreen(
                    currentCourse: _currentCourse,
                    initialAttendance: _attendance,
                    averageGrade: 4.0,
                  ),
                ),
                child: const Text('Академическая информация'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _navigateWithPop(
                  CourseScreen(currentCourse: _currentCourse),
                ),
                child: const Text('Выбор курса'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeStatus,
        child: Text(_statuses[_statusIndex][0]),
      ),
    );
  }
}