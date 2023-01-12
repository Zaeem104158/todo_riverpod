import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_provider.dart';
import 'package:todo_riverpod/model/todo_model.dart';

class TodotrashNotifier extends StateNotifier<List<Todo>> {
  TodotrashNotifier(this.ref) : super([]);

  final Ref ref;

  //Add todos to trash screen
  void addtrashTodo(Todo todo) {
    state = [...state, todo];
  }

  //checking the state of trash either selected or deselected
  void checkSelectedtrash(String id, bool selected) {
    state = state.map((todo) {
      if (todo.id == id) {
        todo = todo.copyWith(
          selected: selected,
        );
      }

      return todo;
    }).toList();
  }

  //unselected or clear trash
  void unselectedOrCleartrashProvider() {
    state = [];
  }

  //Remove from trash screen
  void restoreTodoProvider() {
    List<Todo> recoverTodoList = [];

    state = state.where((todo) {
      if (todo.selected) {
        todo = todo.copyWith(
          selected: false,
        );

        recoverTodoList.add(todo);
        return false;
      }

      return true;
    }).toList();

    ref.read(todosProvider.notifier).addAllTodo(recoverTodoList);
  }
}

//connector with the ui
final todotrashProvider =
    StateNotifierProvider<TodotrashNotifier, List<Todo>>((ref) {
  return TodotrashNotifier(ref);
});
