import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/course/screens/course_screen.dart';
import 'features/attendance/screens/attendance_screen.dart';
import 'features/academic/screens/academic_screen.dart';
import 'features/grade/state/grades_container.dart';
import 'main.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Главный экран
    GoRoute(
      path: '/',
      name: 'main',
      builder: (context, state) => const MyHomePage(title: 'Профиль студента'),
    ),

    // Academic Screen
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

    // Attendance Screen
    GoRoute(
      path: '/attendance',
      name: 'attendance',
      builder: (context, state) {
        final attendance = state.extra as int? ?? 0;
        return AttendanceScreen(currentAttendance: attendance);
      },
    ),

    // Course Screen
    GoRoute(
      path: '/course',
      name: 'course',
      builder: (context, state) {
        final course = state.extra as String? ?? '';
        return CourseScreen(currentCourse: course);
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
          builder: (context, state) => const GradesContainer(),
        ),
      ],
    ),
  ],
);