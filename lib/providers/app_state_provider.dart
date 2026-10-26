import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:i12_into_012/providers/local_json_notifier.dart';
import 'package:i12_into_012/services/storage_service.dart';
import 'package:i12_into_012/providers/sqflite_notifier.dart';

// App state notifier provider
final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(() {
  return SqfliteNotifier();
});

final hasSelectedTodosProvider = Provider<bool>((ref) {
  return ref.watch(selectedTodosProvider).isNotEmpty;
});

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).isDarkMode;
});

final selectedTodosProvider = Provider<Set<String>>((ref) {
  return ref.watch(appStateProvider).selectedTodoIds;
});

// Storage service provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Derived providers for convenience
final todosProvider = Provider<List<Todo>>((ref) {
  return ref.watch(appStateProvider).todos;
});

abstract class AppStateNotifier extends Notifier<AppState> {
  Future<Todo?> addTodo(Todo todo);

  Future<List<Todo>?> addTodos(List<Todo> todos);

  void clearSelection();

  Future<int?> deleteCompletedTodos();

  Future<int?> deleteSelectedTodos();

  Future<int?> deleteTodo(Todo todo);

  Future<int?> deleteTodos(List<Todo> todos);

  Future<bool?> setDarkMode(bool isDarkMode);

  Future<bool?> setTodoCompleted(Todo todo, bool isCompleted);

  void toggleDeletionConfirmation();

  void toggleSelection(String id);

  Future<Todo?> updateTodo(Todo todo);
}
