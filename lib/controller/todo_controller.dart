import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/model/todo_model.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  void addAllTodo(List<Todo> todos) {
    state = todos;
  }

  void addTodo(Todo todo) {
    state = [
      ...state,
      todo,
    ];
  }
  // void arciveTodo(String todoId){
  //   state = state
  //       .where(
  //         (todo) => todo.id == todoId,
  //       )
  //       .toList();
  // }
  void removeTodo(String? todoId) {
    // final deleteState = state
    //     .where(
    //       (todo) => todo.id == todoId,
    //     )
    //     .toList();
    state = state
        .where(
          (todo) => todo.id != todoId,
        )
        .toList();
  }

  void editTodo(Todo todo) {
    state = state.map((objects) {
      if (objects.id == todo.id) {
        return todo;
      }

      return objects;
    }).toList();
  }

  void pinned(String id, bool pin) {
    final pinState = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(pin: pin);
      }

      return todo;
    }).toList();

    pinState.sort((a, b) => (a.pin == true) ? 0 : 1);
    state = pinState;
  }
}

// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
