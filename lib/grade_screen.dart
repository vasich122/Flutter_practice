import 'package:flutter/material.dart';

class GradeScreen extends StatefulWidget {
  final double currentGrade;

  const GradeScreen({super.key, required this.currentGrade});

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  late double _grade;
  final List<Map<String, dynamic>> _grades = []; // список предметов и оценок

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _grade = widget.currentGrade;
  }

  void _addSubject() {
    final subject = _subjectController.text.trim();
    final gradeText = _gradeController.text.trim();
    if (subject.isNotEmpty && gradeText.isNotEmpty) {
      final gradeValue = double.tryParse(gradeText);
      if (gradeValue != null && gradeValue >= 1.0 && gradeValue <= 5.0) {
        setState(() {
          _grades.add({'subject': subject, 'grade': gradeValue});
          _updateAverageGrade();
          _subjectController.clear();
          _gradeController.clear();
        });
      }
    }
  }

  // теперь удаляется первый элемент списка
  void _removeFirstSubject() {
    if (_grades.isNotEmpty) {
      setState(() {
        _grades.removeAt(0);
        _updateAverageGrade();
      });
    }
  }

  void _updateAverageGrade() {
    if (_grades.isEmpty) {
      _grade = widget.currentGrade;
    } else {
      final total = _grades.fold(0.0, (sum, item) => sum + item['grade']);
      _grade = double.parse((total / _grades.length).toStringAsFixed(2));
    }
  }

  void _increaseGrade() {
    setState(() {
      if (_grade < 5.0) {
        _grade += 0.1;
        _grade = double.parse(_grade.toStringAsFixed(1));
      }
    });
  }

  void _decreaseGrade() {
    setState(() {
      if (_grade > 1.0) {
        _grade -= 0.1;
        _grade = double.parse(_grade.toStringAsFixed(1));
      }
    });
  }

  void _goBack() {
    Navigator.pop(context, _grade); // возвращаем обновлённый средний балл
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Средний балл и предметы'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Средний балл: $_grade',
              style: const TextStyle(fontSize: 20, color: Colors.orange),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите название предмета',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _gradeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите оценку (1.0 - 5.0)',
              ),
            ),
            const SizedBox(height: 10),

            // кнопки управления списком
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addSubject,
                  child: const Text('Добавить предмет'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _removeFirstSubject,
                  child: const Text('Удалить первый'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: _grades.length,
                itemBuilder: (context, index) {
                  final item = _grades[index];
                  return ListTile(
                    leading: const Icon(Icons.book),
                    title: Text(item['subject']),
                    trailing: Text(
                      item['grade'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _goBack,
              child: const Text('Вернуться на предыдущий экран'),
            ),
          ],
        ),
      ),
    );
  }
}