import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  final int currentAttendance;

  const AttendanceScreen({super.key, required this.currentAttendance});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late int _attendance;
  final List<Map<String, dynamic>> _subjects = []; // список предметов с посещаемостью

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _attendance = widget.currentAttendance;
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
      }
    }
  }

  void _removeFirstSubject() {
    if (_subjects.isNotEmpty) {
      setState(() {
        _subjects.removeAt(0);
      });
    }
  }

  void _goBack() {
    Navigator.pop(context, _attendance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Посещаемость студента'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Общая посещаемость: $_attendance%',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.orange,
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
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите название предмета',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _percentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите процент посещаемости',
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addSubject,
                  child: const Text('Добавить предмет'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _removeFirstSubject,
                  child: const Text('Удалить первый'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _subjects
                      .map(
                        (subject) => Column(
                      children: [
                        ListTile(
                          leading:
                          const Icon(Icons.book, color: Colors.blue),
                          title: Text(subject['subject']),
                          trailing: Text('${subject['percent']}%'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ],
                    ),
                  )
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: 10),
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