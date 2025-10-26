// lib/features/academic/screens/academic_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart'; // ← для context.push

class AcademicScreen extends StatefulWidget {
  // 🔸 Убраны все внешние параметры — экран использует значения по умолчанию
  const AcademicScreen({super.key});

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> {
  late String _currentCourse;
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

  @override
  void initState() {
    super.initState();
    // 🔸 Используем значения по умолчанию
    _currentCourse = '3 курс';
  }

  void _nextInstitute() {
    setState(() {
      _instituteIndex = (_instituteIndex + 1) % _institutes.length;
    });
  }

  void _navigateToCourseScreen() {
    context.push('/academic/course');
  }

  @override
  Widget build(BuildContext context) {
    // 🔸 Исправлен URL: убран пробел в конце
    const String imageUrl =
        'https://upload.wikimedia.org/wikipedia/ru/thumb/6/61/%D0%A0%D0%A2%D0%A3_%D0%9C%D0%98%D0%A0%D0%AD%D0%90_%D0%BB%D0%BE%D0%B3%D0%BE%D1%82%D0%B8%D0%BF.png/330px-%D0%A0%D0%A2%D0%A3_%D0%9C%D0%98%D0%A0%D0%AD%D0%90_%D0%BB%D0%BE%D0%B3%D0%BE%D1%82%D0%B8%D0%BF.png';

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 200,
              width: 200,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
                radius: 60,
              ),
              progressIndicatorBuilder: (context, url, progress) =>
              const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                color: Colors.red,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Курс: $_currentCourse\n'
                  'Средний балл: 4.0\n' // ← фиксированное значение (или можно хранить в состоянии)
                  'Посещаемость: 92%\n'
                  '${_institutes[_instituteIndex]}',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
                fontSize: 18,
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
              onPressed: _navigateToCourseScreen,
              child: const Text('Выбор курса'),
            ),
          ],
        ),
      ),
    );
  }
}