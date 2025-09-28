// course_screen.dart
import 'package:flutter/material.dart';

class CourseScreen extends StatefulWidget {
  final String currentCourse;

  const CourseScreen({super.key, required this.currentCourse});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final List<String> _courses = [
    '1 курс',
    '2 курс',
    '3 курс',
    '4 курс',
    '5 курс',
  ];

  late int _courseIndex;

  @override
  void initState() {
    super.initState();
    _courseIndex = _courses.indexOf(widget.currentCourse);
    if (_courseIndex == -1) _courseIndex = 2; // дефолт 3 курс
  }

  void _nextCourse() {
    setState(() {
      _courseIndex = (_courseIndex + 1) % _courses.length;
    });
  }

  void _goBack() {
    Navigator.pop(context, _courses[_courseIndex]); // возвращаем выбранный курс
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор курса'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Текущий курс: ${_courses[_courseIndex]}',
              style: const TextStyle(fontSize: 20, color: Colors.purple),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextCourse,
              child: const Text(
                'Следующий курс',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goBack,
              child: const Text(
                'Вернуться на предыдущий экран',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}