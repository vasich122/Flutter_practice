// lib/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/autorization.dart';
import 'features/main/screens/main_screen.dart';
import 'features/academic/screens/academic_screen.dart';
import 'features/attendance/screens/attendance_screen.dart';
import 'features/course/screens/course_screen.dart';
import 'features/grade/state/grades_container.dart';
import 'features/profile/screens/profile_screen.dart';
import 'package:pr1/features/applications/screens/applications_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/auth',

  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/auth',
    ),

    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AutorizationScreen(),
    ),

    GoRoute(
      path: '/main',
      name: 'main',
      builder: (context, state) => const MainScreen(),
    ),

    GoRoute(
      path: '/academic',
      name: 'academic',
      builder: (context, state) => const AcademicScreen(),
    ),

    GoRoute(
      path: '/attendance',
      name: 'attendance',
      builder: (context, state) => const AttendanceScreen(),
    ),

    GoRoute(
      path: '/courses',
      name: 'courses',
      builder: (context, state) => const CourseScreen(),
    ),

    GoRoute(
      path: '/grades',
      name: 'grades',
      builder: (context, state) => const GradesContainer(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/applications',
      builder: (context, state) => const ApplicationScreen(),
    ),
  ],
);