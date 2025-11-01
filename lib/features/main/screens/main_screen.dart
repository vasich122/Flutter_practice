import 'package:flutter/material.dart';
import '../../academic/screens/academic_screen.dart';
import '../../attendance/screens/attendance_screen.dart';
import '../../auth/autorization.dart';
import '../../course/screens/course_screen.dart';
import '../../grade/state/grades_container.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главное меню'),
        actions: [
          IconButton(
            tooltip: 'Выход',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AutorizationScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const _HeaderInfo(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AcademicScreen()),
              ),
              icon: const Icon(Icons.school),
              label: const Text('Академический экран'),
            ),
            const SizedBox(height: 8), // Отступ между кнопками
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AttendanceScreen(),
                ),
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
              label: const Text('Экран выбора курса'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GradesContainer(),
                ),
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
  const _HeaderInfo();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Обучающийся: Соваренко Василий Васильевич',
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text('Учебная группа: ИКБО-06-22', style: textTheme.bodyLarge),
        const SizedBox(height: 4),
        Text('Курс: 4', style: textTheme.bodyLarge),
      ],
    );
  }
}
