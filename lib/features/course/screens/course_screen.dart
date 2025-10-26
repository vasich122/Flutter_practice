// lib/features/academic/screens/course_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CourseScreen extends StatefulWidget {
  final String currentCourse;

  const CourseScreen({super.key, required this.currentCourse});

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
    _courseIndex = _courses.indexOf(widget.currentCourse);
    if (_courseIndex == -1) _courseIndex = 2;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
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

  void _saveAndGoBack() {
    Navigator.pop(context, _courses[_courseIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    const String courseImageUrl =
        'https://cdn-icons-png.flaticon.com/512/4196/4196591.png';

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
              'Текущий курс: ${_courses[_courseIndex]}',
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
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: _attendanceSubjects.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.book, color: colorScheme.primary),
                        title: Text(
                          _attendanceSubjects[index],
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      Divider(color: colorScheme.outline, height: 1),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Опционально: кнопка "Сохранить и выйти" (если нужно явное подтверждение)
            // Но обычно достаточно системной кнопки "Назад"
          ],
        ),
      ),
    );
  }
}