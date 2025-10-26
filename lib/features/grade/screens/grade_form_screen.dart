// lib/features/grade/screens/grade_form_screen.dart
import 'package:flutter/material.dart';
import '../models/grade_model.dart';
import 'package:flutter/services.dart';

class GradeFormScreen extends StatefulWidget {
  const GradeFormScreen({super.key});

  @override
  State<GradeFormScreen> createState() => _GradeFormScreenState();
}

class _GradeFormScreenState extends State<GradeFormScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  void _submit() {
    final subject = _subjectController.text.trim();
    final gradeText = _gradeController.text.trim();
    if (subject.isEmpty) {
      _showError('Введите название предмета');
      return;
    }

    final grade = double.tryParse(gradeText);
    if (grade == null || grade < 1.0 || grade > 5.0) {
      _showError('Оценка должна быть от 1.0 до 5.0');
      return;
    }

    final newGrade = GradeModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subject: subject,
      grade: grade,
    );

    Navigator.pop(context, newGrade);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить оценку'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _subjectController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Название предмета',
                labelStyle: TextStyle(color: colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _gradeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
              ],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Оценка (1.0 – 5.0)',
                labelStyle: TextStyle(color: colorScheme.onSurface),
                helperText: 'Например: 4.5',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}