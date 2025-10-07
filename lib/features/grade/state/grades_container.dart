import 'package:flutter/material.dart';
import '../models/grade_model.dart';
import '../screens/grade_screen.dart';
import '../screens/grade_form_screen.dart';

enum GradesScreen { list, form }

class GradesContainer extends StatefulWidget {
  const GradesContainer({super.key});

  @override
  State<GradesContainer> createState() => _GradesContainerState();
}

class _GradesContainerState extends State<GradesContainer> {
  GradesScreen _currentScreen = GradesScreen.list;
  final List<GradeModel> _grades = [];
  double _averageGrade = 0;

  GradeModel? _recentlyDeleted;
  int? _recentlyDeletedIndex;

  void _showForm() {
    setState(() {
      _currentScreen = GradesScreen.form;
    });
  }

  void _showList() {
    setState(() {
      _currentScreen = GradesScreen.list;
    });
  }

  void _addGrade(String subject, double grade) {
    final newGrade = GradeModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      subject: subject,
      grade: grade,
    );

    setState(() {
      _grades.add(newGrade);
      _calculateAverage();
      _currentScreen = GradesScreen.list;
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
    Widget body = _currentScreen == GradesScreen.list
        ? GradeScreen(
      grades: _grades,
      averageGrade: _averageGrade,
      onAddTap: _showForm,
      onRemove: _removeGrade,
    )
        : GradeFormScreen(
      onSave: _addGrade,
      onCancel: _showList,
    );

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: body,
      ),
    );
  }
}