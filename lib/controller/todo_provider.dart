import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_trash_provider.dart';
import 'package:todo_riverpod/model/todo_model.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier(this.ref) : super([]);

  final Ref ref;

  void addAllTodo(List<Todo> todos) {
    state = todos;
  }

  void addTodo(Todo todo) {
    todo=todo.copyWith(selected: false);
    state = [...state, todo];
  }

  void removeTodo(String? todoId) {
    Todo? trashTodo;

    state = state.where((todo) {
      if (todo.id != todoId) {
        return true;
      }
      trashTodo = todo;
      return false;
    }).toList();

    //Store Trash todos

    if (trashTodo != null) {
      ref.watch(todoTrashProvider.notifier).addTrashTodo(trashTodo!);
    }
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
