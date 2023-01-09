import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_provider.dart';
import 'package:todo_riverpod/model/todo_model.dart';

class TodoTrashNotifier extends StateNotifier<List<Todo>> {
  TodoTrashNotifier(this.ref) : super([]);

  final Ref ref;

  void addTrashTodo(
    Todo todo,
  ) {
    state = [...state, todo];
  }

  void checkSelectedTrash(String id) {
    final checkSelectState = state.map((e) {
      if (e.id == id && e.selected == false) {
        log("Yes");
        return e.copyWith(selected: true);
      } else {
        log("No");
        return e.copyWith(selected: false);
      }
    }).toList();
    state = checkSelectState;
  }

  void updateTrashTodo(Todo todo) {
    log("UpdateState:${todo.selected}");
  }

  void removeFromTrashProvider(List<String> todoIds) {
    List<Todo> recoverTodoList = [];

    state = state.where((element) {
      if (todoIds.contains(element.id)) {
        recoverTodoList.add(element);
        return false;
      }

      return true;
    }).toList();

    ref.watch(todosProvider.notifier).addAllTodo(recoverTodoList);
  }
}

final todoTrashProvider =
    StateNotifierProvider<TodoTrashNotifier, List<Todo>>((ref) {
  return TodoTrashNotifier(ref);
});
