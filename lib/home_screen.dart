import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_controller.dart';
import 'package:todo_riverpod/model/todo_model.dart';
import 'package:uuid/uuid.dart';

// var addTodoKey = const Uuid().v4();
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
      "Pin",
      'Edit',
      'Delete',
    ];
    bool pinned = false;
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height / 14;
    final double itemWidth = size.width / 6;

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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (itemWidth / itemHeight),
                    crossAxisCount: 2),
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: pinned == true ? Colors.blue : Colors.black54,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, left: 8.0),
                                  child: Chip(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      labelPadding: const EdgeInsets.all(0.0),
                                      side: const BorderSide(
                                          color: Colors.black87),
                                      label: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6.0,
                                            right: 6,
                                            top: 2,
                                            bottom: 2),
                                        child: Text(
                                          todoList[index].title,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                      backgroundColor: Colors.white),
                                ),
                                const Spacer(),
                                PopupMenuButton(itemBuilder: (context) {
                                  return [
                                    const PopupMenuItem<int>(
                                      value: 0,
                                      child: Text("Pin"),
                                    ),
                                    const PopupMenuItem<int>(
                                      value: 1,
                                      child: Text("Edit"),
                                    ),
                                    const PopupMenuItem<int>(
                                      value: 2,
                                      child: Text("Delete"),
                                    ),
                                  ];
                                }, onSelected: (value) {
                                  if (value == 0) {
                                    pinned = true;
                                    log("$pinned");
                                   
                                  } else if (value == 1) {
                                    todoTitleController.text =
                                        todoList[index].title;

                                    todoDescriptionController.text =
                                        todoList[index].description;

                                    customStatefullAlertWidget(
                                        editable: true, id: todoList[index].id);
                                  } else {
                                    ref
                                        .read(todosProvider.notifier)
                                        .removeTodo(todoList[index].id);
                                  }
                                }),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6.0, right: 6, top: 2, bottom: 2),
                                  child: Text(
                                    todoList[index].description,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  child: Text("See More"),
                                )
                              ],
                            ),
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

  customStatefullAlertWidget({bool editable = false, String? id}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 4.5,
              child: Column(
                children: [
                  //Title
                  TextField(
                    maxLength: 10,
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
                    maxLength: 1000,
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
              ElevatedButton(
                  child: const Text("Cancle"),
                  onPressed: () {
                    todoDescriptionController.clear();
                    todoTitleController.clear();
                    Navigator.of(context).pop();
                  }),
              ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () {
                    if (editable == false) {
                      ref.read(todosProvider.notifier).addTodo(
                            Todo(
                              id: Uuid().v4(),
                              title: todoTitleController.text,
                              description: todoDescriptionController.text,
                            ),
                          );

                      todoDescriptionController.clear();
                      todoTitleController.clear();

                      Navigator.of(context).pop();
                    } else {
                      Todo todo = Todo(
                          id: id!,
                          description: todoDescriptionController.text,
                          title: todoTitleController.text);

                      ref.read(todosProvider.notifier).editTodo(todo);

                      todoDescriptionController.clear();
                      todoTitleController.clear();

                      Navigator.of(context).pop();
                    }
                  }),
            ],
          );
        });
  }
}
