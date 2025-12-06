import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/test_taking_cubit.dart';
import '../../../core/models/math_test_model.dart';
import '../../../core/models/question_model.dart';

class TestTakingScreen extends StatelessWidget {
  final MathTestModel test;

  const TestTakingScreen({
    super.key,
    required this.test,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestTakingCubit()..loadQuestions(test.id, test.difficulty),
      child: const _TestTakingScreenContent(),
    );
  }
}

class _TestTakingScreenContent extends StatelessWidget {
  const _TestTakingScreenContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Прохождение теста'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<TestTakingCubit, TestTakingState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
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
                    'Ошибка: ${state.error}',
                    style: TextStyle(color: colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Назад'),
                  ),
                ],
              ),
            );
          }

          if (state.isCompleted) {
            return _ResultsView(state: state);
          }

          if (state.currentQuestion == null) {
            return const Center(child: Text('Вопросы не найдены'));
          }

          return Column(
            children: [
              // Прогресс-бар
              _ProgressBar(state: state),
              // Вопрос и варианты ответов
              Expanded(
                child: _QuestionView(
                  question: state.currentQuestion!,
                  onAnswerSelected: (answer) {
                    context.read<TestTakingCubit>().selectAnswer(answer);
                  },
                ),
              ),
              // Навигация
              _NavigationButtons(state: state),
            ],
          );
        },
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final TestTakingState state;

  const _ProgressBar({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Вопрос ${state.currentQuestionIndex + 1} из ${state.totalQuestions}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                '${(state.progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: state.progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  final QuestionModel question;
  final Function(String) onAnswerSelected;

  const _QuestionView({
    required this.question,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Текст вопроса
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              question.question,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          // Варианты ответов
          ...question.answers.map<Widget>((answer) {
            final isSelected = question.selectedAnswer == answer;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => onAnswerSelected(answer),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primaryContainer
                        : colorScheme.surface,
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                size: 16,
                                color: colorScheme.onPrimary,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          answer,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  final TestTakingState state;

  const _NavigationButtons({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TestTakingCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (state.currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => cubit.previousQuestion(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Назад'),
              ),
            ),
          if (state.currentQuestionIndex > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                if (state.currentQuestionIndex < state.totalQuestions - 1) {
                  cubit.nextQuestion();
                } else {
                  cubit.finishTest();
                }
              },
              icon: Icon(
                state.currentQuestionIndex < state.totalQuestions - 1
                    ? Icons.arrow_forward
                    : Icons.check,
              ),
              label: Text(
                state.currentQuestionIndex < state.totalQuestions - 1
                    ? 'Следующий'
                    : 'Завершить',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  final TestTakingState state;

  const _ResultsView({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final score = state.score;
    final percentage = (score * 100).toInt();

    Color getScoreColor() {
      if (score >= 0.8) return Colors.green;
      if (score >= 0.6) return Colors.orange;
      return Colors.red;
    }

    String getScoreText() {
      if (score >= 0.8) return 'Отлично!';
      if (score >= 0.6) return 'Хорошо!';
      if (score >= 0.4) return 'Удовлетворительно';
      return 'Нужно подтянуть знания';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Иконка результата
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getScoreColor().withOpacity(0.2),
            ),
            child: Icon(
              score >= 0.6 ? Icons.check_circle : Icons.cancel,
              size: 64,
              color: getScoreColor(),
            ),
          ),
          const SizedBox(height: 24),
          // Процент правильных ответов
          Text(
            '$percentage%',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: getScoreColor(),
                ),
          ),
          const SizedBox(height: 8),
          // Текст результата
          Text(
            getScoreText(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          // Статистика
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _StatRow(
                    label: 'Правильных ответов',
                    value: '${state.correctAnswers}',
                    color: Colors.green,
                  ),
                  const Divider(),
                  _StatRow(
                    label: 'Неправильных ответов',
                    value: '${state.totalQuestions - state.correctAnswers}',
                    color: Colors.red,
                  ),
                  const Divider(),
                  _StatRow(
                    label: 'Всего вопросов',
                    value: '${state.totalQuestions}',
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Детали по вопросам
          Text(
            'Детали по вопросам',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...state.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: question.isCorrect
                      ? Colors.green
                      : Colors.red,
                  child: Icon(
                    question.isCorrect ? Icons.check : Icons.close,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'Вопрос ${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      question.question,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (!question.isCorrect) ...[
                      Text(
                        'Правильный ответ: ${question.correctAnswer}',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (question.selectedAnswer != null)
                        Text(
                          'Ваш ответ: ${question.selectedAnswer}',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          // Кнопка "Начать заново"
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<TestTakingCubit>().reset();
                context.pop();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Вернуться к тестам'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }
}

