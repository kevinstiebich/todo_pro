import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';

class TodoItem extends ConsumerWidget {
  final Todo todo;

  TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectIds = ref.watch(selectedTodosProvider);
    final isSelected = selectIds.contains(todo.id);

    return Center(
      // Eine ToDo Checkbox erstellen
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onLongPress: () => ref
                      .read(appStateProvider.notifier)
                      .toggleSelection(todo.id),
                  child: Container(
                    width: 370,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isSelected
                            ? [
                                Color.fromARGB(255, 255, 175, 83),
                                Color.fromARGB(255, 213, 255, 241),
                              ]
                            : [
                                Color.fromARGB(255, 0, 253, 169),
                                Color.fromARGB(255, 213, 255, 241),
                              ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (bool? value) {
                              ref
                                  .read(appStateProvider.notifier)
                                  .setTodoCompleted(todo, !todo.isCompleted);
                            },
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              todo.text,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
