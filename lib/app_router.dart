// lib/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/autorization.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/main/screens/main_screen.dart';
import 'features/academic/screens/academic_screen.dart';
import 'features/attendance/screens/attendance_screen.dart';
import 'features/course/screens/course_screen.dart';
import 'features/grade/state/grades_container.dart';
import 'features/profile/screens/profile_screen.dart';
import 'package:pr1/features/applications/screens/applications_screen.dart';
import 'features/student_help/screens/student_help_screen.dart';
import 'features/settings/screens/settings_screen.dart';

GoRouter createAppRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final currentLocation = state.matchedLocation;
      
      // Если на корневом пути, всегда редиректим
      if (currentLocation == '/') {
        final authState = authCubit.state;

        // Пока загружается состояние авторизации, редиректим на авторизацию
        if (authState.isLoading) {
          return '/auth';
        }

        // Редиректим в зависимости от авторизации
        return authState.isAuthorized ? '/main' : '/auth';
      }

      final authState = authCubit.state;

      // Пока загружается состояние авторизации, не делаем редирект для других маршрутов
      if (authState.isLoading) {
        return null;
      }

      // Если пользователь авторизован и пытается зайти на /auth, редиректим на главную
      if (authState.isAuthorized && currentLocation == '/auth') {
        return '/main';
      }

      // Если пользователь не авторизован и пытается зайти не на /auth, редиректим на авторизацию
      if (!authState.isAuthorized && currentLocation != '/auth') {
        return '/auth';
      }

      return null;
    },
    routes: [
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
      GoRoute(
        path: '/student-help',
        name: 'student-help',
        builder: (context, state) => const StudentHelpScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}