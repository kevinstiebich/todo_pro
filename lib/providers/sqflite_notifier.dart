import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteNotifier extends AppStateNotifier {
  Future<Database> get _database => openDb();

  Future<Database> openDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todos.db');

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE todos (id TEXT PRIMARY KEY, text TEXT, isCompleted INTEGER)',
        );
      },
    );

    return database;
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

  Future<AppState?> loadAppState() async {
    try {
      final db = await _database;

      final List<Map<String, Object?>> rows = await db.query('todos');

      final List<Todo> loadedTodos = rows
          .map(
            (row) => Todo(
              id: row['id'] as String,
              text: row['text'] as String,
              isCompleted: row['isCompleted'] == 1,
            ),
          )
          .toList();

      return AppState(todos: loadedTodos);
    } catch (e) {
      print('Error loading app state: $e');
      return null;
    }
  }

  Future<void> _loadState() async {
    try {
      final appState = await loadAppState();
      if (appState != null) {
        state = appState;
      }
    } catch (e) {
      // Handle error or use default state
      print('Error loading state: $e');
    }
  }

  Future<Todo?> addTodo(Todo todo) async {
    final db = await _database;

    // speichert in der SQLite-Datenbank
    db.insert('todos', {
      'id': todo.id,
      'text': todo.text,
      'isCompleted': todo.isCompleted ? 1 : 0,
    });

    // aktualisiert den State für die UI
    state = state.copyWith(
      todos: [...state.todos, todo],
    );

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

    return added;
  }

  void clearSelection() {
    state = state.copyWith(selectedTodoIds: {});
  }

  @override
  Future<int?> deleteCompletedTodos() async {
    final db = await _database;
    int count = await db.delete(
      'todos',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );

    final newTodos = state.todos.where((todo) => !todo.isCompleted).toList();
    state = state.copyWith(todos: newTodos);

    return count;
  }

  Future<int?> deleteSelectedTodos() async {
    if (state.selectedTodoIds.isEmpty) return 0;

    int count = 0;
    final db = await _database;

    for (final i in state.selectedTodoIds) {
      await db.delete('todos', where: 'id = ?', whereArgs: [i]);
      count++;
    }

    final remainingTodos = state.todos
        .where((todo) => !state.selectedTodoIds.contains(todo.id))
        .toList();

    state = state.copyWith(
      todos: remainingTodos,
      selectedTodoIds: {},
    );

    return count;
  }

  @override
  Future<int?> deleteTodo(Todo todo) async {
    final db = await _database;
    // löscht das Todo mit der UUID, gibt die Anzahl gelöschter Rows als int zurück
    int count = await db.delete('todos', where: 'id = ?', whereArgs: [todo.id]);

    final newTodos = state.todos.where((t) => t.id != todo.id).toList();
    state = state.copyWith(todos: newTodos);

    return count;
  }

  @override
  Future<int?> deleteTodos(List<Todo> todos) async {
    int removed = 0;
    for (final todo in todos) {
      final result = await deleteTodo(todo);
      if (result != null) {
        removed++;
      }
    }

    return removed;
  }

  @override
  Future<bool?> setDarkMode(bool isDarkMode) async {
    state = state.copyWith(isDarkMode: isDarkMode);

    return isDarkMode;
  }

  @override
  Future<bool?> setTodoCompleted(Todo todo, bool isCompleted) async {
    final newTodos = state.todos.map((t) {
      if (t.id == todo.id) {
        return todo.copyWith(isCompleted: isCompleted);
      }
      return t;
    }).toList();

    state = state.copyWith(todos: newTodos);

    return isCompleted;
  }

  void toggleDeletionConfirmation() {
    state = state.copyWith(
      asksForDeletionConfirmation: !state.asksForDeletionConfirmation,
    );
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
  }

  @override
  Future<Todo?> updateTodo(Todo todo) async {
    final db = await _database;
    int count = await db.update(
      'todos',
      {'text': todo.text, 'isCompleted': todo.isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [todo.id],
    );

    final newTodos = state.todos
        .map((t) => t.id == todo.id ? todo : t)
        .toList();
    state = state.copyWith(todos: newTodos);

    return todo;
  }
}
