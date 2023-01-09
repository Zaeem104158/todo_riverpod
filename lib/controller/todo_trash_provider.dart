import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_provider.dart';
import 'package:todo_riverpod/model/todo_model.dart';

class TodoTrashNotifier extends StateNotifier<List<Todo>> {
  TodoTrashNotifier(this.ref) : super([]);

  final Ref ref;

  void addTrashTodo(Todo todo) {
    state = [...state, todo];
  }

  void removeFromTrashProvider(List<String> todoId) {
    List<Todo> recoverTodoList = [];
    todoId.forEach(
      (id) {
        state = state.where((element) {
          if (element.id != id) {
            return true;
          } else {
            recoverTodoList.add(element);
            return false;
          }
        }).toList();
      },
    );
    for (var element in recoverTodoList) {
      ref.watch(todosProvider.notifier).addTodo(element);
    }
  }
}

final todoTrashProvider =
    StateNotifierProvider<TodoTrashNotifier, List<Todo>>((ref) {
  return TodoTrashNotifier(ref);
});
