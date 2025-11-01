import 'package:flutter/material.dart';

import '../models/grade_model.dart';

class GradeScreen extends StatelessWidget {
  const GradeScreen({super.key});

  static final List<GradeModel> _grades = [
    GradeModel(id: 'g1', subject: 'Математический анализ', grade: 4.7),
    GradeModel(id: 'g2', subject: 'Алгоритмы и структуры данных', grade: 4.9),
    GradeModel(id: 'g3', subject: 'Базы данных', grade: 4.6),
    GradeModel(id: 'g4', subject: 'Проектирование ПО', grade: 4.8),
    GradeModel(id: 'g5', subject: 'Машинное обучение', grade: 4.5),
  ];

  double get _averageGrade {
    if (_grades.isEmpty) {
      return 0;
    }
    final total = _grades.fold<double>(0, (sum, grade) => sum + grade.grade);
    return total / _grades.length;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final average = _averageGrade;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оценки'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _grades.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              elevation: 0,
              color: colorScheme.primaryContainer,
              child: ListTile(
                leading: Icon(
                  Icons.assessment,
                  color: colorScheme.onPrimaryContainer,
                ),
                title: Text(
                  'Средний балл',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: const Text('По результатам последней сессии'),
                trailing: Text(
                  average.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            );
          }

          final grade = _grades[index - 1];
          return Card(
            elevation: 0,
            color: colorScheme.surfaceVariant,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.secondary,
                child: Text(
                  grade.grade.toStringAsFixed(1),
                  style: TextStyle(color: colorScheme.onSecondary),
                ),
              ),
              title: Text(grade.subject),
              subtitle: const Text('Экзамен, преподаватель кафедры ИТ'),
            ),
          );
        },
      ),
    );
  }
}
