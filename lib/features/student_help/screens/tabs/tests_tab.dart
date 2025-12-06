import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../cubit/student_help_cubit.dart';
import '../../../../core/models/math_test_model.dart';

class TestsTab extends StatefulWidget {
  const TestsTab({super.key});

  @override
  State<TestsTab> createState() => _TestsTabState();
}

class _TestsTabState extends State<TestsTab> {
  String? _selectedDifficulty;
  String? _selectedTopic;
  bool _initialLoad = false;

  @override
  void initState() {
    super.initState();
    // Загружаем тесты при первой загрузке вкладки
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialLoad) {
        _initialLoad = true;
        context.read<StudentHelpCubit>().loadMathTests();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StudentHelpCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDifficulty,
                  decoration: InputDecoration(
                    labelText: 'Сложность',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Все')),
                    DropdownMenuItem(value: 'легкий', child: Text('Легкий')),
                    DropdownMenuItem(value: 'средний', child: Text('Средний')),
                    DropdownMenuItem(value: 'сложный', child: Text('Сложный')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedDifficulty = value;
                    });
                    cubit.loadMathTests(
                      topic: _selectedTopic,
                      difficulty: _selectedDifficulty,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedTopic,
                  decoration: InputDecoration(
                    labelText: 'Тема',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Все')),
                    DropdownMenuItem(value: 'Алгебра', child: Text('Алгебра')),
                    DropdownMenuItem(value: 'Геометрия', child: Text('Геометрия')),
                    DropdownMenuItem(
                      value: 'Математический анализ',
                      child: Text('Анализ'),
                    ),
                    DropdownMenuItem(
                      value: 'Линейная алгебра',
                      child: Text('Линейная алгебра'),
                    ),
                    DropdownMenuItem(
                      value: 'Теория вероятностей',
                      child: Text('Вероятность'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTopic = value;
                    });
                    cubit.loadMathTests(
                      topic: _selectedTopic,
                      difficulty: _selectedDifficulty,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<StudentHelpCubit, StudentHelpState>(
            builder: (context, state) {
              if (state.isLoadingTests) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.errorTests != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ошибка: ${state.errorTests}',
                        style: TextStyle(color: colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => cubit.loadMathTests(),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                );
              }

              if (state.mathTests.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 64,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Тесты не найдены',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.mathTests.length,
                itemBuilder: (context, index) {
                  final test = state.mathTests[index];
                  return _TestCard(test: test);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TestCard extends StatelessWidget {
  final MathTestModel test;

  const _TestCard({required this.test});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color getDifficultyColor(String difficulty) {
      switch (difficulty) {
        case 'легкий':
          return Colors.green;
        case 'средний':
          return Colors.orange;
        case 'сложный':
          return Colors.red;
        default:
          return colorScheme.primary;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Открываем экран прохождения теста
          context.push('/test-taking', extra: test);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      test.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getDifficultyColor(test.difficulty),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      test.difficulty,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                test.topic,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                test.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${test.questionCount} вопросов',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

