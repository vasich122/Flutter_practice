import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  static final List<_AttendanceRecord> _records = [
    const _AttendanceRecord(
      subject: 'Математический анализ',
      lecturer: 'Петров Н.Н.',
      attendance: 96,
      missed: 1,
    ),
    const _AttendanceRecord(
      subject: 'Алгоритмы и структуры данных',
      lecturer: 'Иванова Л.С.',
      attendance: 92,
      missed: 2,
    ),
    const _AttendanceRecord(
      subject: 'Базы данных',
      lecturer: 'Соколов Д.В.',
      attendance: 88,
      missed: 3,
    ),
    const _AttendanceRecord(
      subject: 'Проектирование UI/UX',
      lecturer: 'Громова Е.А.',
      attendance: 100,
      missed: 0,
    ),
    const _AttendanceRecord(
      subject: 'Машинное обучение',
      lecturer: 'Козлов А.И.',
      attendance: 85,
      missed: 4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Посещаемость'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _records.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final record = _records[index];
          final colorScheme = Theme.of(context).colorScheme;

          return Card(
            elevation: 0,
            color: colorScheme.surfaceVariant,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.primary,
                child: Text(
                  record.attendance.toString(),
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
              ),
              title: Text(record.subject),
              subtitle: Text(
                'Преподаватель: ${record.lecturer}\nПропущено занятий: ${record.missed}',
              ),
              trailing: Text('${record.attendance}%'),
            ),
          );
        },
      ),
    );
  }
}

class _AttendanceRecord {
  const _AttendanceRecord({
    required this.subject,
    required this.lecturer,
    required this.attendance,
    required this.missed,
  });

  final String subject;
  final String lecturer;
  final int attendance;
  final int missed;
}
