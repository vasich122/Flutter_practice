import 'package:flutter/material.dart';

import '../screens/grade_screen.dart';

/// Обёртка для совместимости с существующей навигацией.
/// Возвращает статический экран с оценками.
class GradesContainer extends StatelessWidget {
  const GradesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradeScreen();
  }
}
