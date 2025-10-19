import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';
import 'features/course/screens/course_screen.dart';
import 'features/attendance/screens/attendance_screen.dart';
import 'features/grade/state/grades_container.dart';
import 'features/grade/screens/grade_screen.dart';
import 'features/grade/screens/grade_form_screen.dart';
import 'features/academic/screens/academic_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const MyHomePage(title: 'Профиль студента'),
    ),
    GoRoute(
      path: '/attendance',
      name: 'attendance',
      builder: (context, state) {
        final attendance = state.extra as int? ?? 0;
        return AttendanceScreen(currentAttendance: attendance);
      },
    ),
    GoRoute(
      path: '/course',
      name: 'course',
      builder: (context, state) {
        final course = state.extra as String? ?? '';
        return CourseScreen(currentCourse: course);
      },
    ),
    GoRoute(
      path: '/academic',
      name: 'academic',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return AcademicScreen(
          currentCourse: args?['currentCourse'] ?? '',
          initialAttendance: args?['attendance'] ?? 0,
          averageGrade: args?['averageGrade'] ?? 0.0,
        );
      },
    ),
    GoRoute(
      path: '/grades',
      name: 'grades',
      builder: (context, state) => const GradesContainer(),
      routes: [
        GoRoute(
          path: 'form',
          name: 'grade_form',
          builder: (context, state) {
            return GradeFormScreen(
              onSave: (subject, grade) {
                print('Добавлена оценка: $subject - $grade');
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ],
    ),
  ],
);