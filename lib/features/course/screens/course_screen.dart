// lib/features/course/screens/course_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart'; // 🔸 Добавлен импорт go_router

class CourseScreen extends StatefulWidget {
  // 🔸 Убран параметр currentCourse
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final List<String> _courses = [
    '1 курс',
    '2 курс',
    '3 курс',
    '4 курс',
    '5 курс',
  ];

  late int _courseIndex;
  final List<String> _attendanceSubjects = [];
  final TextEditingController _subjectController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 🔸 Используем значение по умолчанию
    _courseIndex = 2; // по умолчанию "3 курс"
  }

  void _saveAndGoBack() {
    final selectedCourse = _courses[_courseIndex];
    context.pop(selectedCourse);
  }

  @override
  Widget build(BuildContext context) {
    // ... как и было, но без widget.currentCourse
    const String courseImageUrl =
        'https://cdn-icons-png.flaticon.com/512/4196/4196591.png'; // 🔸 Убран пробел в конце URL

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор курса'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CachedNetworkImage(
              imageUrl: courseImageUrl,
              height: 120,
              width: 120,
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
              'Текущий курс: ${_courses[_courseIndex]}', // ← используем локальное состояние
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.secondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextCourse,
              child: Text('Следующий курс', style: textTheme.labelLarge),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Введите предмет данного курса',
                labelStyle: TextStyle(color: colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addSubject,
                  child: Text('Добавить предмет', style: textTheme.labelLarge),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _removeFirstSubject,
                  child: Text('Удалить первый', style: textTheme.labelLarge),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox( // 🔸 Заменён Container на SizedBox для лучшей совместимости
              height: 300,
              child: ListView.builder(
                itemCount: _attendanceSubjects.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.book, color: colorScheme.primary),
                        title: Text(_attendanceSubjects[index],
                            style: textTheme.bodyMedium),
                      ),
                      Divider(color: colorScheme.outline, height: 1),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // 🔸 Добавлена кнопка "Сохранить и выйти"
            ElevatedButton(
              onPressed: _saveAndGoBack,
              child: const Text('Сохранить и выйти'),
            ),
          ],
        ),
      ),
    );
  }

  void _nextCourse() {
    setState(() {
      _courseIndex = (_courseIndex + 1) % _courses.length;
    });
  }

  void _addSubject() {
    if (_subjectController.text.isNotEmpty) {
      setState(() {
        _attendanceSubjects.add(_subjectController.text.trim());
        _subjectController.clear();
      });
    }
  }

  void _removeFirstSubject() {
    if (_attendanceSubjects.isNotEmpty) {
      setState(() {
        _attendanceSubjects.removeAt(0);
      });
    }
  }
}