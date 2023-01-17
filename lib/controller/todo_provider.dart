import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_trash_provider.dart';
import 'package:todo_riverpod/model/todo_model.dart';
import 'package:todo_riverpod/utils/const.dart';
import 'package:todo_riverpod/utils/shared_pref.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier(this.ref) : super([]);

  final Ref ref;

  // Write data in local storage
  writeTodoInDevice() async {
    List<Todo> todosList = state;
    final String encodedData = Todo.encode(todosList);
    ref.watch(sharedUtilityProvider).write(todoKey, encodedData);
  }

  // Read data from local storage
  readTodoFromDevice() async {
    final String? todosString =
        await ref.watch(sharedUtilityProvider).read(todoKey);
    if (todosString != null) {
      final List<Todo> todosList = Todo.decode(todosString);
      ref.read(todosProvider.notifier).addAllTodo(todosList);
    } else {
      ref.read(todosProvider.notifier).addAllTodo([]);
    }
  }

  //Add new todo in previous state
  void addAllTodo(List<Todo> todos) {
    final List<Todo> previousTodos = [];
    previousTodos.addAll(state);
    previousTodos.addAll(todos);
    state = previousTodos;
    writeTodoInDevice();
  }

  // Add new todo
  void addTodo(Todo todo) {
    state = [...state, todo];
    writeTodoInDevice();
  }

  //Remove todo
  void removeTodo(String? todoId) {
    Todo? trashTodo;

    state = state.where((todo) {
      if (todo.id != todoId) {
        return true;
      }

      trashTodo = todo;
      return false;
    }).toList();

    //adding deleted todos in trash screen
    if (trashTodo != null) {
      ref.watch(todotrashProvider.notifier).addtrashTodo(trashTodo!);
    }
    writeTodoInDevice();
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
  return TodosNotifier(ref);
});
