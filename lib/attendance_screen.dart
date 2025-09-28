import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  final int currentAttendance;

  const AttendanceScreen({super.key, required this.currentAttendance});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late int _attendance;

  @override
  void initState() {
    super.initState();
    _attendance = widget.currentAttendance;
  }

  void _increaseAttendance() {
    setState(() {
      if (_attendance < 100) _attendance++; // не больше 100%
    });
  }

  void _decreaseAttendance() {
    setState(() {
      if (_attendance > 0) _attendance--; // не меньше 0%
    });
  }

  void _goBack() {
    Navigator.pop(context, _attendance); // возвращаем обновлённое значение
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Посещаемость студента'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Посещаемость: $_attendance%',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.orange,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _increaseAttendance,
              child: const Text('Увеличить посещаемость'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _decreaseAttendance,
              child: const Text('Уменьшить посещаемость'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goBack,
              child: const Text('Вернуться на предыдущий экран'),
            ),
          ],
        ),
      ),
    );
  }
}