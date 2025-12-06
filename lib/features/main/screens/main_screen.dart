import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../profile/cubit/profile_cubit.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const _MainScreenContent(),
    );
  }
}

class _MainScreenContent extends StatelessWidget {
  const _MainScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Список кнопок с маршрутом и иконкой
    final buttons = [
      {'label': 'Профиль пользователя', 'icon': Icons.person, 'route': '/profile'},
      {'label': 'Заявления', 'icon': Icons.description, 'route': '/applications'},
      {'label': 'Академический экран', 'icon': Icons.school, 'route': '/academic'},
      {'label': 'Экран посещаемости', 'icon': Icons.calendar_month, 'route': '/attendance'},
      {'label': 'Экран курсов', 'icon': Icons.book_outlined, 'route': '/courses'},
      {'label': 'Экран оценок', 'icon': Icons.grade, 'route': '/grades'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главное меню'),
        actions: [
          IconButton(
            tooltip: 'Выход',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              context.pushReplacement('/auth');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Приветствие
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return Text(
                  'Здравствуйте, ${state.fullName}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Кнопки в сетке 2x3
            Expanded(
              child: Center(
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // две колонки
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3, // прямоугольные кнопки
                  ),
                  itemBuilder: (context, index) {
                    final button = buttons[index];
                    return ElevatedButton.icon(
                      onPressed: () => context.push(button['route'] as String),
                      icon: Icon(button['icon'] as IconData),
                      label: Text(button['label'] as String),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}