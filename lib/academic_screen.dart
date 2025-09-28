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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статус и информация студента'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextInstitute,
              child: const Text(
                'Сменить институт',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goBack,
              child: const Text(
                'Вернуться на главный экран',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}