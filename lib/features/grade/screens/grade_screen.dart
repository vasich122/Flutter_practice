import 'package:flutter/material.dart';
import '../models/grade_model.dart';

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

    const String gradeImageUrl =
        'https://img.icons8.com/?size=1200&id=uAfcxibacUgO&format=jpg';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Средний балл и предметы'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(gradeImageUrl),
            ),
            const SizedBox(height: 20),
            Text(
              'Средний балл: ${averageGrade.toStringAsFixed(1)}',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.secondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAddTap,
              child: const Text('Добавить предмет'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: grades.length,
                itemBuilder: (context, index) {
                  final grade = grades[index];
                  return ListTile(
                    title: Text('${grade.subject} - ${grade.grade}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => onRemove(grade.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}