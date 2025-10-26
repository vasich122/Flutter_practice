// lib/main.dart
import 'package:flutter/material.dart';
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
        useMaterial3: true,
      ),
      home: const MainScreen(initialIndex: 2),
    );
  }
}

class MainScreen extends StatelessWidget {
  final int initialIndex;

  const MainScreen({super.key, required this.initialIndex});

  static const List<String> _titles = [
    'Посещаемость',
    'Оценки',
    'Академия',
  ];

  static Widget _screenAt(int index) {
    switch (index) {
      case 0:
        return const AttendanceScreen(currentAttendance: 92);
      case 1:
        return const GradesContainer();
      case 2:
        return const AcademicScreen(
          currentCourse: '3 курс',
          initialAttendance: 92,
          averageGrade: 4.0,
        );
      default:
        return const SizedBox();
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScreen(initialIndex: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[initialIndex])),
      body: _screenAt(initialIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: initialIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Посещаемость'),
          BottomNavigationBarItem(icon: Icon(Icons.grade), label: 'Оценки'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Академия'),
        ],
      ),
    );
  }
}