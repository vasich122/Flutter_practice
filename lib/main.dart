import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ← добавьте этот импорт
import 'features/auth/autorization.dart';
import 'features/auth/cubit/auth_cubit.dart'; // ← добавьте этот импорт
import 'shared/app_theme.dart';
import 'bloc_observer.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(
    BlocProvider(
      create: (context) => AuthCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Личный кабинет студента',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const AutorizationScreen(),
    );
  }
}