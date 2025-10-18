import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    const String imageUrl = 'https://upload.wikimedia.org/wikipedia/ru/thumb/6/61/РТУ_МИРЭА_логотип.png/330px-РТУ_МИРЭА_логотип.png';
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статус и информация студента'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
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
                'Курс: ${widget.currentCourse}\n'
                    'Средний балл: ${widget.averageGrade.toStringAsFixed(1)}\n'
                    'Посещаемость: ${widget.initialAttendance}%\n'
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
                onPressed: _goBack,
                child: Text(
                  'Вернуться на главный экран',
                  style: textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}