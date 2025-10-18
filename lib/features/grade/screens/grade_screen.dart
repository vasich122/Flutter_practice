import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/grade_model.dart';
import '../widgets/grade_table.dart';

class GradeScreen extends StatelessWidget {
  final List<GradeModel> grades;
  final double averageGrade;
  final VoidCallback onAddTap;
  final ValueChanged<String> onRemove;

  const GradeScreen({
    super.key,
    required this.grades,
    required this.averageGrade,
    required this.onAddTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    const String gradeImageUrl =
        'https://img.icons8.com/?size=1200&id=uAfcxibacUgO&format=jpg';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Средний балл и предметы'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CachedNetworkImage(
              imageUrl: gradeImageUrl,
              height: 120,
              width: 120,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
                radius: 60,
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
              'Средний балл: ${averageGrade.toStringAsFixed(1)}',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.secondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAddTap,
              child: const Text('Добавить предмет'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: GradeTable(
                grades: grades,
                onRemove: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}