import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_riverpod/controller/todo_trash_provider.dart';

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todotrashList = ref.watch(todotrashProvider);
    final todotrashListNotifier = ref.read(todotrashProvider.notifier);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("trash List"),
          leading: InkWell(
            onTap: () {
              final todotrashList = ref.read(todotrashProvider);
              final todotrashListNotifier =
                  ref.read(todotrashProvider.notifier);
              todotrashListNotifier.unselectedOrCleartrashProvider();
              for (var todo in todotrashList) {
                todo = todo.copyWith(
                  selected: false,
                );
                todotrashListNotifier.addtrashTodo(todo);
              }
              context.go("/");
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          actions: [
            InkWell(
                onTap: () {
                  final todotrashListNotifier =
                      ref.read(todotrashProvider.notifier);
                  todotrashListNotifier.unselectedOrCleartrashProvider();
                },
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Clear",
                    style: TextStyle(fontSize: 24),
                  ),
                ))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: todotrashList.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        value: todotrashList[index].selected,
                        onChanged: (value) {
                          todotrashListNotifier.checkSelectedtrash(
                            todotrashList[index].id,
                            value ?? false,
                          );
                        },
                        title: Text(todotrashList[index].title),
                        subtitle: Text(
                          todotrashList[index].description,
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final recoverTodoListNotifer = ref.read(
                      todotrashProvider.notifier,
                    );
                    recoverTodoListNotifer.restoreTodoProvider();
                  },
                  child: const Text("Recover"),
                )
              ],
            )),
      ),
    );
  }
  // final todotrashList = ref.read(todotrashProvider);
  // final todotrashListNotifier = ref.read(todotrashProvider.notifier);

  // for (var todo in todotrashList) {
  //     todo = todo.copyWith(selected: false);
  //     todotrashListNotifier.addtrashTodo(todo);
  //   }
  //   Future<bool> _onWillPop() async {
  //   return (await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Are you sure?'),
  //           content: const Text('Do you want to exit an App'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(false),
  //               child: const Text('No'),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(true),
  //               child: const Text('Yes'),
  //             ),
  //           ],
  //         ),
  //       )) ??
  //       false;
  // }
}
