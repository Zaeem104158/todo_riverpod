import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_provider.dart';
import 'package:todo_riverpod/model/todo_model.dart';

class TodoTrashNotifier extends StateNotifier<List<Todo>> {
  TodoTrashNotifier(this.ref) : super([]);

  final Ref ref;
  //Add todos to trash screen
  void addTrashTodo(
    Todo todo,
  ) {
    state = [...state, todo];
  }
  //checking the state of trash either selected or deselected
  List<String> idsList = [];
  void checkSelectedTrash(String id) {
    final updateTodoState = state.map((e) {
      if (e.id == id && e.selected == false) {
      

        return e.copyWith(selected: true);
      } else if (e.id == id && e.selected == true) {
      
        return e.copyWith(selected: false);
      } else {
        return e;
      }
    }).toList();
    state = updateTodoState;
  }
  //Remove from trash screen
  void removeFromTrashProvider(List<String> todoIds) {
    List<Todo> recoverTodoList = [];
    state = state.where((element) {
      if (todoIds.contains(element.id)) {
        recoverTodoList.add(element);
        return false;
      }

      return true;
    }).toList();
    recoverTodoList.forEach((todo) {
      ref.watch(todosProvider.notifier).addTodo(todo);
    });
  }
}
//connector with the ui
final todoTrashProvider =
    StateNotifierProvider<TodoTrashNotifier, List<Todo>>((ref) {
  return TodoTrashNotifier(ref);
});
