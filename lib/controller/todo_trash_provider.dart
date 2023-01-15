import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_provider.dart';
import 'package:todo_riverpod/model/todo_model.dart';

class TodoTrashNotifier extends StateNotifier<List<Todo>> {
  TodoTrashNotifier(this.ref) : super([]);

  final Ref ref;

  //Add todos to trash screen
  void addtrashTodo(Todo todo) {
    state = [...state, todo];
  }

  //Clear trash
  void clearAllTrashProvider() {
    state = [];
  }

  //Recover from trash screen
  void restoreTodoProvider() {
    List<Todo> recoverTodoList = [];
    final trashState = ref.read(selectDeselectTrashTodoProvider.notifier).state;
    for (var element in trashState) {
      state = state.where((todo) {
        if (element == todo.id) {
          recoverTodoList.add(todo);
          //return false;
        }
        return true;
      }).toList();
    }
    ref.read(todosProvider.notifier).addAllTodo(recoverTodoList);
  }
}

  //connector with the ui
  final todotrashProvider =
      StateNotifierProvider<TodoTrashNotifier, List<Todo>>((ref) {
    return TodoTrashNotifier(ref);
  });

  //Select or Deselect in trash notifier
  class TodoSelectTrashNotifier extends StateNotifier<List<String>> {
    TodoSelectTrashNotifier() : super([]);

    //Select or Deselect Todos
    void selectDeselectTrashTodo(String todoId) {
      if (state.contains(todoId)) {
        state = state.where((id) => id != todoId).toList();
      } else {
        state = [...state, todoId];
      }
    }
  }

  //connector with the ui
  final selectDeselectTrashTodoProvider =
      StateNotifierProvider.autoDispose<TodoSelectTrashNotifier, List<String>>(
          (ref) {
    return TodoSelectTrashNotifier();
  });
