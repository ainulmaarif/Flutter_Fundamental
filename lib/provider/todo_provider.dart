import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model Todo
class Todo {
  final String title;
  final bool done;

  Todo(this.title, {this.done = false});

  Todo copyWith({String? title, bool? done}) {
    return Todo(
      title ?? this.title,
      done: done ?? this.done,
    );
  }
}

// Notifier untuk mengelola daftar List<Todo>
class TodoListNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => const [];

  // Menambah tugas baru
  void add(String title) {
    state = [...state, Todo(title)];
  }

  // Mengubah status selesai tugas
  void toggle(int index) {
    final todos = [...state];
    todos[index] = todos[index].copyWith(done: !todos[index].done);
    state = todos;
  }

  // FITUR BARU: Mengubah teks tugas
  void edit(int index, String newTitle) {
    final todos = [...state];
    todos[index] = todos[index].copyWith(title: newTitle);
    state = todos;
  }

  // Menghapus tugas
  void remove(int index) {
    state = [...state]..removeAt(index);
  }
}

// Provider global
final todoListProvider =
    NotifierProvider<TodoListNotifier, List<Todo>>(TodoListNotifier.new);