import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';

class SqfliteNotifier extends AppStateNotifier {
  @override
  Future<Todo?> addTodo(Todo todo) {
    // TODO: implement addTodo
    throw UnimplementedError();
  }

  @override
  Future<List<Todo>?> addTodos(List<Todo> todos) {
    // TODO: implement addTodos
    throw UnimplementedError();
  }

  @override
  AppState build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  void clearSelection() {
    // TODO: implement clearSelection
  }

  @override
  Future<int?> deleteCompletedTodos() {
    // TODO: implement deleteCompletedTodos
    throw UnimplementedError();
  }

  @override
  Future<int?> deleteSelectedTodos() {
    // TODO: implement deleteSelectedTodos
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
  Future<bool?> setTodoCompleted(Todo todo, bool isCompleted) {
    // TODO: implement setTodoCompleted
    throw UnimplementedError();
  }

  @override
  void toggleDeletionConfirmation() {
    // TODO: implement toggleDeletionConfirmation
  }

  @override
  void toggleSelection(String id) {
    // TODO: implement toggleSelection
  }

  @override
  Future<Todo?> updateTodo(Todo todo) {
    // TODO: implement updateTodo
    throw UnimplementedError();
  }
}
