import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_controller.dart';
import 'package:todo_riverpod/model/todo_model.dart';
import 'package:uuid/uuid.dart';

var addTodoKey = const Uuid().v4();
// final activeFilterKey = UniqueKey();
// final completedFilterKey = UniqueKey();
// final allFilterKey = UniqueKey();
// final trashFilterKey = UniqueKey();
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController todoTitleController = TextEditingController();
  TextEditingController todoDescriptionController = TextEditingController();

  @override
  void dispose() {
    todoTitleController.dispose();
    todoDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoList = ref.watch(todosProvider);
    var items = [
      'Edit',
      'Delete',
    ];
    var editedTodoId;
    return SafeArea(
        child: Scaffold(
      // appBar: AppBar(
      //   title: const Text("Welcome to Home"),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu_rounded),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: todoList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return InkWell(
                    onTap: () {
                      log("ViewID::${todoList[index].id}");
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Chip(
                                    label: Text(
                                      todoList[index].title,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                PopupMenuButton(itemBuilder: (context) {
                                  return [
                                    const PopupMenuItem<int>(
                                      value: 0,
                                      child: Text("Edit"),
                                    ),
                                    const PopupMenuItem<int>(
                                      value: 1,
                                      child: Text("Delete"),
                                    ),
                                  ];
                                }, onSelected: (value) {
                                  if (value == 0) {
                                    // editedTodoId = todoList[index].id;
                                   
                                    // customStatefullAlertWidget(
                                    //     editable: true,
                                    //     editedTodoId: editedTodoId);
                                  } else {
                                    // ref
                                    //     .read(todosProvider.notifier)
                                    //     .removeTodo(todoList[index].id);
                                  }
                                }),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(todoList[index].description),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: customStatefullAlertWidget,
        label: const Text(
          "Add",
          style: TextStyle(color: Colors.white),
        ),
        tooltip: "Add your todo",
      ),
    ));
  }

  customStatefullAlertWidget(
      {bool editable = false, String? editedTodoId}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  //Title
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Title",
                      hintText: "Work / Exam",
                      hintStyle:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    controller: todoTitleController,
                  ),
                  //Description
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "Meeting at 12PM",
                      hintStyle:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    controller: todoDescriptionController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  child: const Text("Save"),
                  onPressed: () {
                    if (editable == false) {
                      ref.read(todosProvider.notifier).addTodo(
                            Todo(
                              id: addTodoKey,
                              title: todoTitleController.text,
                              description: todoDescriptionController.text,
                            ),
                          );

                      todoDescriptionController.clear();
                      todoTitleController.clear();

                      Navigator.of(context).pop();
                    } else {
                      // ref.read(todosProvider.notifier).editTodo(Todo(
                      //         id: editable,
                      //         title: todoTitleController.text,
                      //         description: todoDescriptionController.text,
                      //       ),);
                      // todoDescriptionController.clear();
                      // todoTitleController.clear();

                      // Navigator.of(context).pop();
                    }
                  })
            ],
          );
        });
  }
}
