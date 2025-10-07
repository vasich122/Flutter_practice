import 'package:flutter/material.dart';

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

  void _goBack() {
    Navigator.pop(context, _courses[_courseIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор курса'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Текущий курс: ${_courses[_courseIndex]}',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextCourse,
              child: Text(
                'Следующий курс',
                style: textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
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
                  child: Text(
                    'Добавить предмет',
                    style: textTheme.labelLarge,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _removeFirstSubject,
                  child: Text(
                    'Удалить первый',
                    style: textTheme.labelLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
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

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _goBack,
              child: Text(
                'Вернуться на предыдущий экран',
                style: textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}