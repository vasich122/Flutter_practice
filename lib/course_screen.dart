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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор курса'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Текущий курс: ${_courses[_courseIndex]}',
              style: const TextStyle(fontSize: 20, color: Colors.purple),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextCourse,
              child: const Text(
                'Следующий курс',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите предмет данного курса',
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addSubject,
                  child: const Text(
                    'Добавить предмет',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _removeFirstSubject,
                  child: const Text(
                    'Удалить первый',
                    style: TextStyle(fontSize: 16, color: Colors.black),
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
                        leading: const Icon(Icons.book, color: Colors.blue),
                        title: Text(
                          _attendanceSubjects[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Divider(color: Colors.grey, height: 1),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _goBack,
              child: const Text(
                'Вернуться на предыдущий экран',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}