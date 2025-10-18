import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AttendanceScreen extends StatefulWidget {
  final int currentAttendance;

  const AttendanceScreen({super.key, required this.currentAttendance});

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
    const String imageUrl = 'https://cdn-icons-png.flaticon.com/512/7514/7514354.png';
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Посещаемость студента'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 200,
              width: 200,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
                radius: 5,
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
              style: textTheme.bodyLarge
                  ?.copyWith(color: colorScheme.secondary, fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _increaseAttendance, child: const Text('Увеличить')),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _decreaseAttendance, child: const Text('Уменьшить')),
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
                ElevatedButton(onPressed: _addSubject, child: const Text('Добавить')),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _removeFirstSubject, child: const Text('Удалить первый')),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: _subjects
                  .map(
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
              )
                  .toList(),
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