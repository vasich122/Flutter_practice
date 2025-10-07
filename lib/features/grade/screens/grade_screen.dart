import 'package:flutter/material.dart';
import '../models/grade_model.dart';
import '../widgets/grade_table.dart';

class GradeScreen extends StatelessWidget {
  final List<GradeModel> grades;
  final double averageGrade;
  final VoidCallback onAddTap;
  final ValueChanged<String> onRemove;

  const GradeScreen({
    super.key,
    required this.grades,
    required this.averageGrade,
    required this.onAddTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Средний балл и предметы'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Средний балл: $averageGrade',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAddTap,
              child: const Text('Добавить предмет'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GradeTable(
                grades: grades,
                onRemove: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}