import 'package:flutter/material.dart';

class GradeFormScreen extends StatefulWidget {
  final void Function(String subject, double grade) onSave;
  final VoidCallback onCancel;

  const GradeFormScreen({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<GradeFormScreen> createState() => _GradeFormScreenState();
}

class _GradeFormScreenState extends State<GradeFormScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  void _submit() {
    final subject = _subjectController.text.trim();
    final gradeText = _gradeController.text.trim();
    final grade = double.tryParse(gradeText);
    if (subject.isNotEmpty && grade != null && grade >= 1.0 && grade <= 5.0) {
      widget.onSave(subject, grade);
      _subjectController.clear();
      _gradeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить оценку'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onCancel,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Название предмета',
                labelStyle: TextStyle(color: colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _gradeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Оценка (1.0 - 5.0)',
                labelStyle: TextStyle(color: colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: 20),
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