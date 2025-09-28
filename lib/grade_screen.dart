import 'package:flutter/material.dart';

class GradeScreen extends StatefulWidget {
  final double currentGrade;

  const GradeScreen({super.key, required this.currentGrade});

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  late double _grade;

  @override
  void initState() {
    super.initState();
    _grade = widget.currentGrade;
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
        title: const Text('Изменить средний балл'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Средний балл: $_grade',
              style: const TextStyle(fontSize: 20, color: Colors.orange),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _increaseGrade,
              child: const Text(
                'Увеличить',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _decreaseGrade,
              child: const Text(
                'Уменьшить',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
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