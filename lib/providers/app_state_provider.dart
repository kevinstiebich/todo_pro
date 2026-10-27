import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:i12_into_012/providers/local_json_notifier.dart';
import 'package:i12_into_012/services/storage_service.dart';
import 'package:i12_into_012/providers/sqflite_notifier.dart';

/// App state notifier provider
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

/// Storage service provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Derived providers for convenience
final todosProvider = Provider<List<Todo>>((ref) {
  return ref.watch(appStateProvider).todos;
});

/// Interface for AppStateNotifiers
abstract class AppStateNotifier extends Notifier<AppState> {
  /// Adds a single ToDo
  Future<Todo?> addTodo(Todo todo);

  /// Adds multiple ToDos
  Future<List<Todo>?> addTodos(List<Todo> todos);

  /// Clears the selection
  void clearSelection();

  /// Deletes ToDos with a checkmark
  Future<int?> deleteCompletedTodos();

  /// Deletes selected ToDos (orange highlighted)
  Future<int?> deleteSelectedTodos();

  /// Deletes a single ToDo
  Future<int?> deleteTodo(Todo todo);

  /// Deletes multiple ToDos
  Future<int?> deleteTodos(List<Todo> todos);

  /// Changes the brightness of the appdesign
  Future<bool?> setDarkMode(bool isDarkMode);

  /// Adds a checkmark to a ToDo
  Future<bool?> setTodoCompleted(Todo todo, bool isCompleted);

  /// When toggled, a confirmation message will be shown before deleting a ToDo
  void toggleDeletionConfirmation();

  void toggleSelection(String id);

  /// Updates a single ToDo
  Future<Todo?> updateTodo(Todo todo);
}
