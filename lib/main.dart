import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_router.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/profile/cubit/profile_cubit.dart';
import 'package:pr1/shared/app_theme.dart';
import 'package:pr1/shared/service_locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Личный кабинет студента',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}