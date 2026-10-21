import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';
import 'package:i12_into_012/screens/settings_screen.dart';
import 'package:i12_into_012/widgets/add_todo_dialog.dart';
import 'package:i12_into_012/widgets/todo_item.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 253, 169),
        title: Text(
          'ToDo List',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (ref.read(appStateProvider).asksForDeletionConfirmation) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Do you want to delete the selected (orange highlighted), or completed ToDos?',
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
                                .deleteSelectedTodos();
                            Navigator.pop(context);
                          },
                          child: const Text('Delete selected ToDos'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(appStateProvider.notifier)
                                .deleteCompletedTodos();
                            Navigator.pop(context);
                          },
                          child: const Text('Delete completed ToDos'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                ref.read(appStateProvider.notifier).deleteSelectedTodos();
              }
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.black,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(12),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            child: Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView(
        children: todos
            .map(
              (todo) => TodoItem(
                todo: todo,
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTodoDialog(),
          );
        },
        backgroundColor: Color.fromARGB(255, 0, 253, 169),
        foregroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}
