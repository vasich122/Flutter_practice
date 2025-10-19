import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'features/course/screens/course_screen.dart';
import 'features/attendance/screens/attendance_screen.dart';
import 'features/grade/state/grades_container.dart';
import 'features/academic/screens/academic_screen.dart';
import 'app_router.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Личный кабинет студента',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: appRouter,
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

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String imageUrl =
        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Курс'),
            Tab(text: 'Посещаемость'),
            Tab(text: 'Оценки'),
            Tab(text: 'Статус'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Курс
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.push('/course', extra: _currentCourse);
              },
              child: const Text('Выбрать курс'),
            ),
          ),
          // Посещаемость
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.push('/attendance', extra: _attendance);
              },
              child: Text('Изменить посещаемость ($_attendance%)'),
            ),
          ),
          // Оценки
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.push('/grades');
              },
              child: const Text('Управление оценками'),
            ),
          ),
          // Academic
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.push('/academic', extra: {
                  'currentCourse': _currentCourse,
                  'attendance': _attendance,
                  'averageGrade': 4.0,
                });
              },
              child: const Text('Просмотр статуса студента'),
            ),
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