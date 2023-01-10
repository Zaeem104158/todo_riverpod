import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_provider.dart';
import 'package:todo_riverpod/model/todo_model.dart';

class TodoTrashNotifier extends StateNotifier<List<Todo>> {
  TodoTrashNotifier(this.ref) : super([]);

  final Ref ref;
  //Add todos to trash screen
  void addTrashTodo(Todo todo) {
    state = [...state, todo];
  }

  //checking the state of trash either selected or deselected
  void checkSelectedTrash(String id, bool selected) {
    state = state.map((todo) {
      if (todo.id == id) {
        todo = todo.copyWith(
          selected: selected,
        );
      }

      return todo;
    }).toList();
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
final todoTrashProvider =
    StateNotifierProvider<TodoTrashNotifier, List<Todo>>((ref) {
  return TodoTrashNotifier(ref);
});
