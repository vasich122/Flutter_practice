import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/grade_note_cubit.dart';
import '../../../core/models/grade_model.dart';
import 'package:go_router/go_router.dart';

class GradeScreen extends StatelessWidget {
  const GradeScreen({super.key});

  static final List<GradeModel> _grades = [
    GradeModel(id: 'g1', subject: 'Математический анализ', grade: 4.7),
    GradeModel(id: 'g2', subject: 'Алгоритмы и структуры данных', grade: 4.9),
    GradeModel(id: 'g3', subject: 'Базы данных', grade: 4.6),
    GradeModel(id: 'g4', subject: 'Проектирование ПО', grade: 4.8),
    GradeModel(id: 'g5', subject: 'Машинное обучение', grade: 4.5),
  ];

  double get _averageGrade {
    if (_grades.isEmpty) return 0;
    final total = _grades.fold<double>(0, (sum, grade) => sum + grade.grade);
    return total / _grades.length;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GradeNoteCubit(),
      child: const _GradeScreenContent(),
    );
  }
}

class _GradeScreenContent extends StatelessWidget {
  const _GradeScreenContent({super.key});

  void _showNoteDialog(BuildContext context, String gradeId, String subject) {
    final cubit = context.read<GradeNoteCubit>();
    final currentNote = cubit.getNote(gradeId);
    final controller = TextEditingController(text: currentNote);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Заметка по "$subject"'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Например: Нужно подтянуть интегралы',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(), // через GoRouter
              child: const Text('Отмена'),
            ),
            OutlinedButton(
              onPressed: () {
                cubit.clearNote(gradeId);
                context.pop(); // через GoRouter
              },
              child: const Text('Очистить'),
            ),
            ElevatedButton(
              onPressed: () {
                final note = controller.text.trim();
                if (note.isNotEmpty) {
                  cubit.setNote(gradeId, note);
                } else {
                  cubit.clearNote(gradeId);
                }
                context.pop(); // через GoRouter
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final average = GradeScreen()._averageGrade;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оценки'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // переход назад через GoRouter
        ),
      ),
      body: BlocBuilder<GradeNoteCubit, Map<String, String>>(
        builder: (context, notes) {
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: GradeScreen._grades.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Card(
                  elevation: 0,
                  color: colorScheme.primaryContainer,
                  child: ListTile(
                    leading: Icon(
                      Icons.assessment,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    title: Text(
                      'Средний балл',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: const Text('По результатам последней сессии'),
                    trailing: Text(
                      average.toStringAsFixed(2),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: colorScheme.onPrimaryContainer),
                    ),
                  ),
                );
              }

              final grade = GradeScreen._grades[index - 1];
              final note = notes[grade.id] ?? '';

              return Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: InkWell(
                  onTap: () => _showNoteDialog(context, grade.id, grade.subject),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.secondary,
                      child: Text(
                        grade.grade.toStringAsFixed(1),
                        style: TextStyle(color: colorScheme.onSecondary),
                      ),
                    ),
                    title: Text(grade.subject),
                    subtitle: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Экзамен, преподаватель кафедры ИТ',
                          ),
                          if (note.isNotEmpty) ...[
                            const TextSpan(text: '\n'),
                            TextSpan(
                              text: '📌 $note',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}