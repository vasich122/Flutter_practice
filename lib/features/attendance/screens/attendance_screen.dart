// lib/features/attendance/screens/attendance_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AttendanceScreen extends StatefulWidget {
  // 🔸 Убран обязательный параметр currentAttendance
  // Экран теперь сам управляет начальным состоянием
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late int _attendance;
  final List<Map<String, dynamic>> _subjects = [];

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 🔸 Используем значение по умолчанию вместо внешнего параметра
    _attendance = 92; // ← можно заменить на данные из состояния, если нужно
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _percentController.dispose();
    super.dispose();
  }

  void _increaseAttendance() {
    setState(() {
      if (_attendance < 100) _attendance++;
    });
  }

  void _decreaseAttendance() {
    setState(() {
      if (_attendance > 0) _attendance--;
    });
  }

  void _addSubject() {
    final subject = _subjectController.text.trim();
    final percentText = _percentController.text.trim();
    if (subject.isNotEmpty && percentText.isNotEmpty) {
      final percent = int.tryParse(percentText);
      if (percent != null && percent >= 0 && percent <= 100) {
        setState(() {
          _subjects.add({'subject': subject, 'percent': percent});
          _subjectController.clear();
          _percentController.clear();
        });
      } else {
        _showError('Процент должен быть от 0 до 100');
      }
    } else {
      _showError('Заполните все поля');
    }
  }

  void _removeFirstSubject() {
    if (_subjects.isNotEmpty) {
      setState(() {
        _subjects.removeAt(0);
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔸 Исправлен URL: убран пробел в конце
    const String imageUrl = 'https://cdn-icons-png.flaticon.com/512/7514/7514354.png';
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: 100,
            width: 100,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundImage: imageProvider,
              radius: 50,
            ),
            progressIndicatorBuilder: (context, url, progress) =>
            const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Общая посещаемость: $_attendance%',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.secondary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _increaseAttendance,
                child: const Text('Увеличить'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _decreaseAttendance,
                child: const Text('Уменьшить'),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
            controller: _percentController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Процент посещаемости',
              labelStyle: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _addSubject,
                child: const Text('Добавить'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _removeFirstSubject,
                child: const Text('Удалить первый'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._subjects.map(
                (subject) => Column(
              children: [
                ListTile(
                  leading: Icon(Icons.book, color: colorScheme.primary),
                  title: Text(subject['subject']),
                  trailing: Text('${subject['percent']}%'),
                ),
                Divider(color: colorScheme.outline, height: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}