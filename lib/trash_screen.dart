import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_trash_provider.dart';
import 'package:todo_riverpod/model/todo_model.dart';

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoTrashList = ref.watch(todoTrashProvider);
    //final todoTrashListNotifier = ref.watch(todoTrashProvider.notifier);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Archive List"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: todoTrashList.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        value: todoTrashList[index].selected,
                        onChanged: (value) {
                          todoTrashList[index] =
                              todoTrashList[index].copyWith(selected: value);
                          //todoTrashListNotifier.
                         
                        },
                        title: Text(todoTrashList[index].title),
                        subtitle: Text(
                          todoTrashList[index].description,
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final todoTrashNotifier =
                        ref.read(todoTrashProvider.notifier);

                    //selected trash ids
                    List<String> recoverTodoIdsList = ["123","456"];

                    todoTrashNotifier
                        .removeFromTrashProvider(recoverTodoIdsList);
                  },
                  child: const Text("Recover"),
                )
              ],
            )),
      ),
    );
  }

  bool checkTrashItem() {
    return true;
  }
}
