import 'package:flutter/material.dart';
import '../../../core/models/grade_model.dart';
import 'grade_row.dart';

class GradeTable extends StatelessWidget {
  final List<GradeModel> grades;
  final ValueChanged<String> onRemove;

  const GradeTable({
    super.key,
    required this.grades,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: grades.length,
      itemBuilder: (context, index) {
        return GradeRow(
          grade: grades[index],
          onRemove: onRemove,
        );
      },
    );
  }
}