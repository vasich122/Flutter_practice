import 'package:flutter/material.dart';

class AcademicScreen extends StatefulWidget {
  final String currentCourse;
  final int initialAttendance;
  final double averageGrade;

  const AcademicScreen({
    super.key,
    required this.currentCourse,
    required this.initialAttendance,
    required this.averageGrade,
  });

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> {
  final List<String> _institutes = [
    'Институт искусственного интеллекта',
    'Институт информационных технологий',
    'Институт кибербезопасности и цифровых технологий',
    'Институт перспективных технологий и индустриального программирования',
    'Институт радиоэлектроники и информатики',
    'Институт технологий управления',
    'Институт тонких химических технологий им. М.В. Ломоносова',
  ];

  int _instituteIndex = 0;

  void _nextInstitute() {
    setState(() {
      _instituteIndex = (_instituteIndex + 1) % _institutes.length;
    });
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статус и информация студента'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Курс: ${widget.currentCourse}\nСредний балл: ${widget.averageGrade}\nПосещаемость: ${widget.initialAttendance}%\n${_institutes[_instituteIndex]}',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextInstitute,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
              ),
              child: Text(
                'Сменить институт',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSecondary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goBack,
              child: Text(
                'Вернуться на главный экран',
                style: textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}