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

    await saveState();
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

    saveState();
  }

  Future<bool?> setDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);

    saveState();
  }

  void toggleDeletionConfirmation() {
    state = state.copyWith(
      asksForDeletionConfirmation: !state.asksForDeletionConfirmation,
    );
    saveState();
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

  void clearSelection() {
    state = state.copyWith(selectedTodoIds: {});
  }

  Future<void> deleteSelectedTodos() async {
    if (state.selectedTodoIds.isEmpty) return;

    final remainingTodos = state.todos
        .where((todo) => !state.selectedTodoIds.contains(todo.id))
        .toList();

    state = state.copyWith(
      todos: remainingTodos,
      selectedTodoIds: {},
    );

    saveState();
  }

  Future<void> loadState() async {
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

  Future<void> saveState() async {
    try {
      await _storageService.saveAppState(state);
    } catch (e) {
      print('Error saving state: $e');
    }
  }

  @override
  AppState build() {
    Future.microtask(loadState);

    return AppState(
      todos: [],
      isDarkMode: true,
      asksForDeletionConfirmation: true,
    );
  }

  @override
  Future<int?> deleteCompletedTodos() {
    // TODO: implement deleteCompletedTodos
    throw UnimplementedError();
  }

  @override
  Future<int?> deleteTodo(Todo todo) {
    // TODO: implement deleteTodo
    throw UnimplementedError();
  }

  @override
  Future<int?> deleteTodos(List<Todo> todos) {
    // TODO: implement deleteTodos
    throw UnimplementedError();
  }

  @override
  Future<bool?> setDarkMode(bool isDarkMode) {
    // TODO: implement setDarkMode
    throw UnimplementedError();
  }

  @override
  Future<bool?> toggleTodoCompletion(Todo todo) {
    // TODO: implement toggleTodoCompletion
    throw UnimplementedError();
  }

  @override
  Future<Todo?> updateTodo(Todo todo) {
    // TODO: implement updateTodo
    throw UnimplementedError();
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
    await saveState();
    return added;
  }
}
