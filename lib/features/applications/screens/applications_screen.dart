import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pr1/features/applications/cubit/applications_cubit.dart';
import 'package:pr1/features/applications/widgets/application_item.dart';

class ApplicationScreen extends StatelessWidget {
  const ApplicationScreen({super.key});

  void _showApplicationDialog(BuildContext context, {String? id, String? type, String? description}) {
    final typeController = TextEditingController(text: type ?? '');
    final descriptionController = TextEditingController(text: description ?? '');
    final cubit = context.read<ApplicationCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(id == null ? 'Создать заявление' : 'Редактировать заявление'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Тип заявления'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final t = typeController.text.trim();
                final d = descriptionController.text.trim();
                if (t.isEmpty || d.isEmpty) return;

                if (id == null) {
                  cubit.addApplication(t, d);
                } else {
                  cubit.updateApplication(id, t, d);
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
    return BlocProvider(
      create: (_) => ApplicationCubit(),
      child: BlocBuilder<ApplicationCubit, List>(builder: (context, applications) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Заявления'),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final app = applications[index];
              return ApplicationItem(
                application: app,
                onEdit: () => _showApplicationDialog(context, id: app.id, type: app.type, description: app.description),
                onDelete: () => context.read<ApplicationCubit>().deleteApplication(app.id),
                onSend: () => context.read<ApplicationCubit>().sendApplication(app.id),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showApplicationDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }
}