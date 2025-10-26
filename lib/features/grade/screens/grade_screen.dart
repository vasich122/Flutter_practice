// lib/features/grade/screens/grade_screen.dart
import 'package:flutter/material.dart';
import '../models/grade_model.dart';
import 'grade_form_screen.dart';

class GradeScreen extends StatelessWidget {
  final List<GradeModel> grades;
  final double averageGrade;
  final ValueChanged<GradeModel> onGradeAdded;
  final ValueChanged<String> onRemove;

  const GradeScreen({
    super.key,
    required this.grades,
    required this.averageGrade,
    required this.onGradeAdded,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    const String gradeImageUrl =
        'https://img.icons8.com/?size=1200&id=uAfcxibacUgO&format=jpg';

    return SingleChildScrollView(
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
            onPressed: () async {
              final GradeModel? newGrade = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GradeFormScreen()),
              );
              if (newGrade != null) {
                onGradeAdded(newGrade);
              }
            },
            child: const Text('Добавить предмет'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: grades.length,
              itemBuilder: (context, index) {
                final grade = grades[index];
                return ListTile(
                  title: Text('${grade.subject} - ${grade.grade}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onRemove(grade.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}