import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../academic/screens/academic_screen.dart';
import '../../attendance/screens/attendance_screen.dart';
import '../../auth/autorization.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../course/screens/course_screen.dart';
import '../../grade/state/grades_container.dart';
import '../cubit/main_cubit.dart'; // ← импорт MainCubit

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: const _MainScreenContent(),
    );
  }
}

class _MainScreenContent extends StatelessWidget {
  const _MainScreenContent({super.key});

  void _showEditDialog(BuildContext context) {
    final cubit = context.read<MainCubit>();
    final state = cubit.state;

    final nameController = TextEditingController(text: state.fullName);
    final groupController = TextEditingController(text: state.group);
    final courseController = TextEditingController(text: state.course.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать профиль'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'ФИО'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: groupController,
                  decoration: const InputDecoration(labelText: 'Группа'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: courseController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Курс'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final group = groupController.text.trim();
                final courseStr = courseController.text.trim();

                if (name.isEmpty || group.isEmpty || courseStr.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Все поля обязательны')),
                  );
                  return;
                }

                final course = int.tryParse(courseStr);
                if (course == null || course < 1 || course > 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Курс должен быть от 1 до 6')),
                  );
                  return;
                }

                cubit.updateFullName(name);
                cubit.updateGroup(group);
                cubit.updateCourse(course);

                Navigator.of(context).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главное меню'),
        actions: [
          IconButton(
            tooltip: 'Выход',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AutorizationScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const _HeaderInfo(),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _showEditDialog(context),
              icon: const Icon(Icons.edit),
              label: const Text('Редактировать профиль'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AcademicScreen()),
              ),
              icon: const Icon(Icons.school),
              label: const Text('Академический экран'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AttendanceScreen()),
              ),
              icon: const Icon(Icons.calendar_today),
              label: const Text('Экран посещаемости'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CourseScreen()),
              ),
              icon: const Icon(Icons.book_outlined),
              label: const Text('Экран просмотра курсов'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const GradesContainer()),
              ),
              icon: const Icon(Icons.grade),
              label: const Text('Экран оценок'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  const _HeaderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Обучающийся: ${state.fullName}',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text('Учебная группа: ${state.group}', style: textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text('Курс: ${state.course}', style: textTheme.bodyLarge),
          ],
        );
      },
    );
  }
}