import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/academic_cubit.dart';

class AcademicScreen extends StatelessWidget {
  const AcademicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AcademicCubit(),
      child: const _AcademicScreenContent(),
    );
  }
}

class _AcademicScreenContent extends StatelessWidget {
  const _AcademicScreenContent({super.key});

  void _showAddActivityDialog(BuildContext context) {
    final cubit = context.read<AcademicCubit>();
    final currentText = cubit.state;

    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Добавить научную активность'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Описание активности',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final newText = controller.text.trim();
                if (newText.isNotEmpty) {
                  cubit.addScientificActivity(newText);
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Добавить'),
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
        title: const Text('Академические данные'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<AcademicCubit, String>(
        builder: (context, scientificActivities) {
          final items = [
            _AcademicItemData(
              icon: Icons.account_balance,
              title: 'Институт',
              subtitle: 'Институт искусственного интеллекта',
            ),
            _AcademicItemData(
              icon: Icons.menu_book,
              title: 'Профиль подготовки',
              subtitle: 'Разработка программного обеспечения',
              trailing: '2022–2026',
            ),
            _AcademicItemData(
              icon: Icons.schedule,
              title: 'Общий рейтинг успеваемости',
              subtitle: 'Средний балл за семестр — 4.3',
            ),
            _AcademicItemData(
              icon: Icons.event,
              title: 'Учебный семестр',
              subtitle: 'Весна 2025/2026',
            ),
            _AcademicItemData(
              icon: Icons.workspace_premium,
              title: 'Научные активности',
              subtitle: scientificActivities,
              onTap: () => _showAddActivityDialog(context),
            ),
            _AcademicItemData(
              icon: Icons.group_work,
              title: 'Практика',
              subtitle: 'Преддипломная практика в лаборатории искусственного интеллекта',
            ),
            _AcademicItemData(
              icon: Icons.assignment,
              title: 'Курсовые работы',
              subtitle: 'Подготовлено 6 работ, 2 отмечены как лучшие в группе',
            ),
          ];

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: ListTile(
                  leading: Icon(
                    item.icon,
                    color: colorScheme.primary,
                  ),
                  title: Text(item.title),
                  subtitle: Text(item.subtitle),
                  trailing: item.trailing != null ? Text(item.trailing!) : null,
                  onTap: item.onTap,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AcademicItemData {
  const _AcademicItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailing;
  final VoidCallback? onTap;
}