import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';
import 'package:uuid/uuid.dart';

class AddTodoDialog extends ConsumerWidget {
  const AddTodoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();

    return AlertDialog(
      title: const Text('Add a new ToDo:'),
      content: TextField(
        controller: textController,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            ref
                .read(appStateProvider.notifier)
                .addTodo(
                  Todo(text: textController.text, id: const Uuid().v4()),
                );
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
