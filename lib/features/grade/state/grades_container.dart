// lib/features/grade/state/grades_container.dart
import 'package:flutter/material.dart';
import '../models/grade_model.dart';
import '../screens/grade_screen.dart';
// Убираем импорт grade_form_screen — он вызывается через Navigator

class GradesContainer extends StatefulWidget {
  const GradesContainer({super.key});

  @override
  State<GradesContainer> createState() => _GradesContainerState();
}

class _GradesContainerState extends State<GradesContainer> {
  final List<GradeModel> _grades = [];
  double _averageGrade = 0;

  GradeModel? _recentlyDeleted;
  int? _recentlyDeletedIndex;

  void _addGrade(GradeModel grade) {
    setState(() {
      _grades.add(grade);
      _calculateAverage();
    });
  }

  void _removeGrade(String id) {
    final index = _grades.indexWhere((g) => g.id == id);
    if (index == -1) return;

    setState(() {
      _recentlyDeleted = _grades[index];
      _recentlyDeletedIndex = index;
      _grades.removeAt(index);
      _calculateAverage();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Оценка удалена'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            if (_recentlyDeleted != null && _recentlyDeletedIndex != null) {
              setState(() {
                _grades.insert(_recentlyDeletedIndex!, _recentlyDeleted!);
                _calculateAverage();
              });
            }
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _calculateAverage() {
    if (_grades.isEmpty) {
      _averageGrade = 0;
    } else {
      final total = _grades.fold<double>(0, (sum, g) => sum + g.grade);
      _averageGrade = total / _grades.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradeScreen(
      grades: _grades,
      averageGrade: _averageGrade,
      onGradeAdded: _addGrade,     // теперь принимает GradeModel
      onRemove: _removeGrade,
    );
  }
}