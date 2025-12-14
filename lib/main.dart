import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/profile/cubit/profile_cubit.dart';
import 'features/settings/cubit/theme_cubit.dart';
import 'package:pr1/shared/app_theme.dart';
import 'package:pr1/shared/service_locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthCubit _authCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit();
    _router = createAppRouter(_authCubit);

    // Слушаем изменения состояния авторизации и обновляем роутер
    _authCubit.stream.listen((state) {
      if (!state.isLoading && mounted) {
        final currentLocation =
            _router.routerDelegate.currentConfiguration.uri.path;

        if (state.isAuthorized && currentLocation == '/auth') {
          _router.go('/main');
        } else if (!state.isAuthorized &&
            currentLocation != '/auth' &&
            currentLocation != '/') {
          _router.go('/auth');
        }
      }
    });
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            routerConfig: _router,
            title: 'Личный кабинет студента',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeState.themeMode == AppThemeMode.dark
                ? ThemeMode.dark
                : themeState.themeMode == AppThemeMode.light
                    ? ThemeMode.light
                    : ThemeMode.system,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
