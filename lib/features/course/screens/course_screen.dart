import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Учебные курсы'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final course = _courses[index];
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
                        backgroundColor: colorScheme.primary.withOpacity(0.15),
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
                    children: course.modules
                        .map(
                          (module) => Chip(
                            backgroundColor: colorScheme.secondaryContainer
                                .withOpacity(0.6),
                            label: Text(module),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
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
