import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_riverpod/controller/todo_trash_provider.dart';
import 'package:todo_riverpod/utils/size_config.dart';

class TrashScreen extends ConsumerStatefulWidget {
  const TrashScreen({super.key});

  @override
  ConsumerState<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends ConsumerState<TrashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final todosNotifier = ref.watch(todotrashProvider.notifier);
      todosNotifier.readTrashTodoFromDevice();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todotrashList = ref.watch(todotrashProvider);
    final selectDeselect = ref.watch(selectDeselectTrashTodoProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Trash List",
          ),
          leading: InkWell(
            onTap: () {
              context.go("/");
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          actions: [
            InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('Do you want to clear the trash?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final todotrashListNotifier =
                                ref.read(todotrashProvider.notifier);
                            todotrashListNotifier.clearAllTrashProvider();
                            // final prefs = await SharedPreferences.getInstance();
                            // final success = await prefs.remove(deletedTodoKey);
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Clear All",
                    style: TextStyle(
                        fontSize: 24, color: Color.fromARGB(255, 133, 0, 0)),
                  ),
                ))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: todotrashList.length,
                        itemBuilder: (context, index) {
                          final trashTodo = todotrashList[index];
                          return CheckboxListTile(
                            value: selectDeselect.contains(trashTodo.id),
                            onChanged: (value) {
                              ref
                                  .read(
                                      selectDeselectTrashTodoProvider.notifier)
                                  .selectDeselectTrashTodo(trashTodo.id);
                            },
                            title: Text(trashTodo.title),
                            subtitle: Text(trashTodo.description),
                          );
                        },
                      ),
                    ],
                  )),
            ),
            SizedBox(
              width: SizeConfig.getScreenWidth(context),
              child: ElevatedButton(
                onPressed: () {
                  final recoverTodoListNotifer = ref.read(
                    todotrashProvider.notifier,
                  );
                  recoverTodoListNotifer.restoreTodoProvider();
                },
                child: const Text(
                  "Recover",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
