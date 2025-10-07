import 'package:flutter/material.dart';
import '../models/grade_model.dart';

class GradeRow extends StatelessWidget {
  final GradeModel grade;
  final ValueChanged<String> onRemove;

  const GradeRow({
    super.key,
    required this.grade,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      key: ValueKey(grade.id),
      leading: Icon(Icons.book, color: colorScheme.primary),
      title: Text(grade.subject),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            grade.grade.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: colorScheme.error),
            onPressed: () => onRemove(grade.id),
          ),
        ],
      ),
    );
  }
}