import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/course_cubit.dart';
import 'package:go_router/go_router.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  static final List<_CourseInfo> _courses = [
    const _CourseInfo(
      title: '1 курс',
      description: 'Базовая подготовка по математике и алгоритмам',
      modules: [
        'Математический анализ',
        'Линейная алгебра',
        'Алгоритмы и структуры данных',
        'Основы программирования на Dart',
      ],
    ),
    const _CourseInfo(
      title: '2 курс',
      description: 'Инженерные дисциплины и проектирование приложений',
      modules: [
        'Операционные системы',
        'Базы данных и SQL',
        'Паттерны проектирования',
        'Мобильная разработка (Flutter)',
      ],
    ),
    const _CourseInfo(
      title: '3 курс',
      description: 'Продвинутая разработка и проектная деятельность',
      modules: [
        'Разработка UI/UX',
        'Инженерия требований',
        'Микросервисная архитектура',
        'Научно-исследовательский семинар',
      ],
    ),
    const _CourseInfo(
      title: '4 курс',
      description: 'Дипломное проектирование и индустриальные практики',
      modules: [
        'Проектирование распределённых систем',
        'Машинное обучение',
        'Производственная практика',
        'Преддипломная практика',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseCubit(),
      child: const _CourseScreenContent(),
    );
  }
}

class _CourseScreenContent extends StatelessWidget {
  const _CourseScreenContent({super.key});

  void _showNoteDialog(BuildContext context, String subject) {
    final cubit = context.read<CourseCubit>();
    final currentNote = cubit.getNote(subject);
    final controller = TextEditingController(text: currentNote);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Критерии по "$subject"'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Например: Автомат при посещаемости ≥90% и сдаче всех лаб',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(), // через GoRouter
              child: const Text('Отмена'),
            ),
            OutlinedButton(
              onPressed: () {
                cubit.clearNote(subject);
                context.pop(); // через GoRouter
              },
              child: const Text('Очистить'),
            ),
            ElevatedButton(
              onPressed: () {
                final note = controller.text.trim();
                if (note.isNotEmpty) {
                  cubit.setNote(subject, note);
                } else {
                  cubit.clearNote(subject);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Учебные курсы'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // переход назад через GoRouter
        ),
      ),
      body: BlocBuilder<CourseCubit, Map<String, String>>(
        builder: (context, notes) {
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: CourseScreen._courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final course = CourseScreen._courses[index];
              return Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            course.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Chip(
                            label: Text('${course.modules.length} дисциплины'),
                            backgroundColor:
                            colorScheme.primary.withOpacity(0.15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: course.modules.map((module) {
                          final note = notes[module] ?? '';
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => _showNoteDialog(context, module),
                                child: Chip(
                                  backgroundColor: colorScheme
                                      .secondaryContainer
                                      .withOpacity(0.6),
                                  label: Text(module),
                                ),
                              ),
                              if (note.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'ℹ️ $note',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                    color:
                                    colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          );
                        }).toList(),
                      ),
                    ],
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

class _CourseInfo {
  const _CourseInfo({
    required this.title,
    required this.description,
    required this.modules,
  });

  final String title;
  final String description;
  final List<String> modules;
}