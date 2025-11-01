import 'package:flutter/material.dart';

class AcademicScreen extends StatelessWidget {
  const AcademicScreen({super.key});

  static final List<_AcademicItem> _items = [
    const _AcademicItem(
      icon: Icons.account_balance,
      title: 'Институт',
      subtitle: 'Институт искусственного интеллекта',
    ),
    const _AcademicItem(
      icon: Icons.menu_book,
      title: 'Профиль подготовки',
      subtitle: 'Разработка программного обеспечения',
      trailing: '2022–2026',
    ),
    const _AcademicItem(
      icon: Icons.schedule,
      title: 'Общий рейтинг успеваемости',
      subtitle: 'Средний балл за семестр — 4.3',
    ),
    const _AcademicItem(
      icon: Icons.event,
      title: 'Учебный семестр',
      subtitle: 'Весна 2025/2026',
    ),
    const _AcademicItem(
      icon: Icons.workspace_premium,
      title: 'Научные активности',
      subtitle: 'Участие в проекте «Умный кампус», публикация в сборнике МИРЭА',
    ),
    const _AcademicItem(
      icon: Icons.group_work,
      title: 'Практика',
      subtitle:
          'Преддипломная практика в лаборатории искусственного интеллекта',
    ),
    const _AcademicItem(
      icon: Icons.assignment,
      title: 'Курсовые работы',
      subtitle: 'Подготовлено 6 работ, 2 отмечены как лучшие в группе',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Академические данные'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: ListTile(
              leading: Icon(
                item.icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(item.title),
              subtitle: Text(item.subtitle),
              trailing: item.trailing != null ? Text(item.trailing!) : null,
            ),
          );
        },
      ),
    );
  }
}

class _AcademicItem {
  const _AcademicItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailing;
}
