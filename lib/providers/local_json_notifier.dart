import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';
import 'package:i12_into_012/services/storage_service.dart';

class LocalJsonNotifier extends AppStateNotifier {
  final _storageService = StorageService();

  Future<Todo?> addTodo(Todo todo) async {
    state = state.copyWith(
      todos: [...state.todos, todo],
    );

    await _saveState();
    return todo;
  }

  @override
  Future<List<Todo>?> addTodos(List<Todo> todos) async {
    final added = <Todo>[];
    for (final todo in todos) {
      final result = await addTodo(todo);
      if (result != null) {
        added.add(result);
      }
    }
    await _saveState();
    return added;
  }

  @override
  AppState build() {
    // Future.microtask = Überholspur, direkt nach dem Code, aber vor allen anderen Futures
    Future.microtask(_loadState);

    return AppState(
      todos: [],
      isDarkMode: true,
      asksForDeletionConfirmation: true,
    );
  }

  void clearSelection() {
    state = state.copyWith(selectedTodoIds: {});
  }

  @override
  Future<int?> deleteCompletedTodos() async {
    final oldLength = state.todos.length;
    final newTodos = state.todos.where((todo) => !todo.isCompleted).toList();
    final newLength = newTodos.length;
    state = state.copyWith(todos: newTodos);
    await _saveState();
    return oldLength - newLength;
  }

  Future<int?> deleteSelectedTodos() async {
    if (state.selectedTodoIds.isEmpty) return 0;

    final oldLength = state.selectedTodoIds.length;
    final remainingTodos = state.todos
        .where((todo) => !state.selectedTodoIds.contains(todo.id))
        .toList();
    final newLength = remainingTodos.length;

    state = state.copyWith(
      todos: remainingTodos,
      selectedTodoIds: {},
    );

    await _saveState();
    return oldLength - newLength;
  }

  @override
  Future<int?> deleteTodo(Todo todo) async {
    final oldLength = state.todos.length;
    final newTodos = state.todos.where((t) => t.id != todo.id).toList();
    final newLength = newTodos.length;
    state = state.copyWith(todos: newTodos);
    await _saveState();
    return oldLength - newLength;
  }

  @override
  Future<int?> deleteTodos(List<Todo> todos) async {
    final todoIds = todos.map((t) => t.id).toList();
    final oldLength = state.todos.length;
    final newTodos = state.todos.where((t) => !todoIds.contains(t.id)).toList();
    final newLength = newTodos.length;
    state = state.copyWith(todos: newTodos);
    await _saveState();
    return oldLength - newLength;
  }

  Future<void> _loadState() async {
    try {
      final appState = await _storageService.loadAppState();
      if (appState != null) {
        state = appState;
      }
    } catch (e) {
      // Handle error or use default state
      print('Error loading state: $e');
    }
  }

  Future<void> _saveState() async {
    try {
      await _storageService.saveAppState(state);
    } catch (e) {
      print('Error saving state: $e');
    }
  }

  @override
  Future<bool?> setDarkMode(bool isDarkMode) async {
    state = state.copyWith(isDarkMode: isDarkMode);

    _saveState();
    return isDarkMode;
  }

  @override
  Future<bool?> setTodoCompleted(Todo todo, bool isCompleted) async {
    final newTodos = state.todos.map((t) {
      if (t.id == todo.id) {
        return todo.copyWith(isCompleted: isCompleted);
      }
      return todo;
    }).toList();
    state = state.copyWith(todos: newTodos);
    await _saveState();
    return isCompleted;
  }

  void toggleDeletionConfirmation() {
    state = state.copyWith(
      asksForDeletionConfirmation: !state.asksForDeletionConfirmation,
    );
    _saveState();
  }

  void toggleSelection(String id) {
    final selectedIds = Set<String>.from(state.selectedTodoIds);
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }

    state = state.copyWith(selectedTodoIds: selectedIds);
  }

  void toggleTodo(String id) {
    state = state.copyWith(
      todos: state.todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList(),
    );

    _saveState();
  }

  @override
  Future<Todo?> updateTodo(Todo todo) async {
    final newTodos = state.todos
        .map((t) => t.id == todo.id ? todo : t)
        .toList();
    state = state.copyWith(todos: newTodos);
    await _saveState();
    return todo;
  }
}
