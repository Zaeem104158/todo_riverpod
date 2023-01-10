import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_provider.dart';
import 'package:todo_riverpod/home_drawer_widget.dart';
import 'package:todo_riverpod/model/todo_model.dart';
import 'package:todo_riverpod/seemore_description_screen.dart';
import 'package:todo_riverpod/utils/size_config.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:readmore/readmore.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController todoTitleController = TextEditingController();
  TextEditingController todoDescriptionController = TextEditingController();
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final initialTodos = List.generate(
        4,
        (index) {
          return Todo(
            id: const Uuid().v4(),
            description:
                "Descriptionn $index",
            title: "Title $index",
            pin: false,
            selected: false,
          );
        },
      );

      ref.read(todosProvider.notifier).addAllTodo(initialTodos);
    });
  }

  @override
  void dispose() {
    todoTitleController.dispose();
    todoDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoList = ref.watch(todosProvider);

    List<String> items = [
      "Pin",
      'Edit',
      'Delete',
    ];

    final double gridItemHeight = SizeConfig.getScreenHeight(context) / 8;
    final double gridItemWidth = SizeConfig.getScreenHeight(context) / 5;

    return AdvancedDrawer(
      backdropColor: Colors.blueGrey[700],
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 250),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      drawer: const HomeScreenDrawerWidget(),
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: const Text("Welcome to Home"),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: todoList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: (gridItemWidth / gridItemHeight),
              crossAxisCount: 2,
            ),
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              final todos = todoList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: !todoList[index].pin
                      ? Colors.blueGrey[200]
                      : Colors.blue[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Menu Icon of todos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                            child: Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              labelPadding: const EdgeInsets.all(0.0),
                              side: const BorderSide(
                                color: Color.fromARGB(
                                  255,
                                  160,
                                  229,
                                  229,
                                ),
                              ),
                              label: Padding(
                                padding: const EdgeInsets.only(
                                  left: 6.0,
                                  right: 6,
                                  top: 2,
                                  bottom: 2,
                                ),
                                child: Text(
                                  todos.title,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          PopupMenuButton(itemBuilder: (context) {
                            return [
                              PopupMenuItem<int>(
                                value: 0,
                                child: !todos.pin
                                    ? const Text("Pin")
                                    : const Text("Unpin"),
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
                            final todo = todoList[index];
                            final todoNotifier = ref.read(
                              todosProvider.notifier,
                            );

                            if (value == 0) {
                              //Pin Todo
                              todoNotifier.pinned(todo.id, !todo.pin);
                            } else if (value == 1) {
                              todoTitleController.text = todo.title;

                              todoDescriptionController.text = todo.description;
                              //Edit Todo
                              customStatefullAlertWidget(
                                id: todo.id,
                                editable: true,
                                pin: todo.pin,
                              );
                            } else {
                              //Delete Todo
                              todoNotifier.removeTodo(todo.id);
                            }
                          }),
                        ],
                      ),
                      // Description of todos
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                todoList[index].description,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SeeMoreDescription(
                                        todoList[index].description,
                                      ),
                                    ));
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    "See More",
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 8,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: customStatefullAlertWidget,
          label: const Text(
            "Add Todo",
            style: TextStyle(color: Colors.white),
          ),
          tooltip: "Add your todo",
        ),
      )),
    );
  }

  customStatefullAlertWidget({
    String? id,
    bool editable = false,
    bool pin = false,
    bool selected = false,
  }) async {
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
                    Todo todo = Todo(
                      id: const Uuid().v4(),
                      description: todoDescriptionController.text,
                      title: todoTitleController.text,
                      pin: pin,
                      selected: selected,
                    );

                    final todoNotifier = ref.read(
                      todosProvider.notifier,
                    );

                    if (editable == false) {
                      todoNotifier.addTodo(todo);
                    } else {
                      todo = todo.copyWith(id: id);
                      todoNotifier.editTodo(todo);
                    }

                    todoTitleController.clear();
                    todoDescriptionController.clear();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
