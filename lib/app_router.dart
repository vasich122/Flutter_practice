// lib/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/attendance/screens/attendance_screen.dart';
import 'features/grade/state/grades_container.dart';
import 'features/academic/screens/academic_screen.dart';
import 'features/grade/screens/grade_form_screen.dart'; // ← импортируем форму
import 'features/course/screens/course_screen.dart'; // ← импортируем курс, если нужно

// Общий экран с нижней панелью и переключением вкладок
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<String> _paths = ['/academic', '/grades', '/attendance'];

  void _onItemTapped(BuildContext context, int index) {
    setState(() {
      _currentIndex = index;
    });
    // 🔸 Горизонтальная навигация через go (аналог pushReplacement)
    context.go(_paths[index]);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_currentIndex) {
      case 0:
        child = const AcademicScreen();
        break;
      case 1:
        child = const GradesContainer(); // ← внутри будет кнопка, вызывающая /grades/form
        break;
      case 2:
        child = const AttendanceScreen();
        break;
      default:
        child = const SizedBox();
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Академия'),
          BottomNavigationBarItem(icon: Icon(Icons.grade), label: 'Оценки'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Посещаемость'),
        ],
      ),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/academic',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/academic',
    ),
    GoRoute(
      path: '/academic',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const MainScreen(),
      ),
      routes: [
        // 🔸 Вложенный маршрут: /academic/course
        GoRoute(
          path: 'course',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const CourseScreen(), // ← убедитесь, что этот файл существует
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/grades',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const MainScreen(),
      ),
      routes: [
        // 🔸 Вложенный маршрут: /grades/form
        GoRoute(
          path: 'form',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const GradeFormScreen(), // ← убедитесь, что этот файл существует
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/attendance',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const MainScreen(),
      ),
    ),
  ],
);