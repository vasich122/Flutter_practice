import 'package:flutter/material.dart';
import 'package:pr1/core/models/application_model.dart';

class ApplicationItem extends StatelessWidget {
  final ApplicationModel application;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSend;

  const ApplicationItem({
    super.key,
    required this.application,
    this.onEdit,
    this.onDelete,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHighest,
      child: ListTile(
        title: Text(application.type),
        subtitle: Text(
          '${application.description}\nСтатус: ${application.status}',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (application.editable) ...[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: onSend,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ]
          ],
        ),
      ),
    );
  }
}