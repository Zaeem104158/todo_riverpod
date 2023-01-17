import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_provider.dart';
import 'package:todo_riverpod/model/todo_model.dart';
import 'package:todo_riverpod/utils/const.dart';
import 'package:todo_riverpod/utils/shared_pref.dart';

class TodoTrashNotifier extends StateNotifier<List<Todo>> {
  TodoTrashNotifier(this.ref) : super([]);

  final Ref ref;

  writeTrashTodoInDevice() async {
    List<Todo> trashTodosList = state;
    final String encodedData = Todo.encode(trashTodosList);
    ref.watch(sharedUtilityProvider).write(deletedTodoKey, encodedData);
  }

  // Read data from local storage
  readTrashTodoFromDevice() async {
    final String? trashTodosString =
        await ref.watch(sharedUtilityProvider).read(deletedTodoKey);
    if (trashTodosString != null) {
      final List<Todo> trashTodosList = Todo.decode(trashTodosString);
      ref.read(todotrashProvider.notifier).addAllTrashTodo(trashTodosList);
    } else {
      ref.read(todotrashProvider.notifier).addAllTrashTodo([]);
    }
  }

  void addAllTrashTodo(List<Todo> todos) {
    state = todos;
  }

  //Add todos to trash screen
  void addtrashTodo(Todo todo) {
    state = [...state, todo];
    writeTrashTodoInDevice();
  }

  //Clear trash
  void clearAllTrashProvider() {
    state = [];
    ref.watch(sharedPreferencesProvider).remove(deletedTodoKey);
  }

  //Recover from trash screen
  void restoreTodoProvider() {
    List<Todo> recoverTodoList = [];
    final trashState = ref.read(selectDeselectTrashTodoProvider.notifier).state;
    for (var element in trashState) {
      state = state.where((todo) {
        if (element == todo.id) {
          recoverTodoList.add(todo);

          return false;
        }
        return true;
      }).toList();
    }
    writeTrashTodoInDevice();
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
