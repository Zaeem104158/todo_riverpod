import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/model/todo_model.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  void addTodo(Todo todo) {
    //log(todo.id);
    state = [...state, todo];
  }

  void removeTodo(String todoId) {
    state = state.where((todo) => todo.id != todoId).toList();

    // state = [
    //   for (final todo in state)
    //     if (todo.id != todoId) todo,
    // ];
  }

  void editTodo(Todo todo) {
    state = state.map((e) {
      if (e.id == todo.id) {
        return todo;
      }

      return e;
    }).toList();

    // for (var i = 0; i < state.length; i++) {
    //   if (state[i].id == todo.id) {
    //     state[i] = todo;
    //   }
    // }
  }
}

// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
