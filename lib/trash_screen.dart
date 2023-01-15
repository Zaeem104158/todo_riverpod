import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_riverpod/controller/todo_trash_provider.dart';

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todotrashList = ref.watch(todotrashProvider);
    final selectDeselect = ref.watch(selectDeselectTrashTodoProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Trash List"),
          leading: InkWell(
            onTap: () {
              context.go("/");
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          actions: [
            InkWell(
                onTap: () {
                  final todotrashListNotifier =
                      ref.read(todotrashProvider.notifier);
                  todotrashListNotifier.clearAllTrashProvider();
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
                      final trashTodo = todotrashList[index];
                      return CheckboxListTile(
                        value: selectDeselect.contains(trashTodo.id),
                        onChanged: (value) {
                          ref
                              .read(selectDeselectTrashTodoProvider.notifier)
                              .selectDeselectTrashTodo(trashTodo.id);
                        },
                        title: Text(trashTodo.title),
                        subtitle: Text(trashTodo.description),
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
}
