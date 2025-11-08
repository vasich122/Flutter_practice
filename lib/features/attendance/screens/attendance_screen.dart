import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/attendance_cubit.dart';

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
    return BlocProvider(
      create: (context) => AttendanceCubit(),
      child: const _AttendanceScreenContent(),
    );
  }
}

class _AttendanceScreenContent extends StatelessWidget {
  const _AttendanceScreenContent({super.key});

  void _showClassroomDialog(BuildContext context, String subject) {
    final cubit = context.read<AttendanceCubit>();
    final currentRoom = cubit.getClassroom(subject);

    final controller = TextEditingController(text: currentRoom);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Кабинет для "$subject"'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Номер кабинета',
              hintText: 'Например: А304, Г-501',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            OutlinedButton(
              onPressed: () {
                cubit.clearClassroom(subject);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Очистить'),
            ),
            ElevatedButton(
              onPressed: () {
                final room = controller.text.trim();
                if (room.isNotEmpty) {
                  cubit.setClassroom(subject, room);
                } else {
                  cubit.clearClassroom(subject);
                }
                Navigator.of(dialogContext).pop();
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
        title: const Text('Посещаемость'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<AttendanceCubit, Map<String, String>>(
        builder: (context, classrooms) {
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: AttendanceScreen._records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final record = AttendanceScreen._records[index];
              final room = classrooms[record.subject] ?? '';

              return Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      record.attendance.toString(),
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                  ),
                  title: Text(record.subject),
                  subtitle: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Преподаватель: ${record.lecturer}\n'),
                        TextSpan(text: 'Пропущено занятий: ${record.missed}'),
                        if (room.isNotEmpty) ...[
                          const TextSpan(text: '\n'),
                          TextSpan(
                            text: 'Кабинет: $room',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ],
                    ),
                  ),
                  trailing: Text('${record.attendance}%'),
                  onTap: () => _showClassroomDialog(context, record.subject),
                ),
              );
            },
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