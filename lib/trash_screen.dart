import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/todo_trash_provider.dart';

class TrashScreen extends ConsumerStatefulWidget {
  const TrashScreen({super.key});

  @override
  ConsumerState<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends ConsumerState<TrashScreen> {
  List<String> recoverList = [];
  @override
  Widget build(BuildContext context) {
    final todoTrashList = ref.watch(todoTrashProvider);
    // bool selected = true;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Archive List"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // CheckboxListTile(
                //   value: selectAll(),
                //   onChanged: (value) {

                //   },
                //   title: const Text("Select All"),
                // ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: todoTrashList.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        value: checkId(todoTrashList[index].id.toString()),
                        selected: checkId(todoTrashList[index].id.toString()),
                        onChanged: (value) {
                          handleData(todoTrashList[index].id.toString());
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
                        ref.watch(todoTrashProvider.notifier);
                  
                    todoTrashNotifier.removeFromTrashProvider(recoverList);

                  },
                  child: const Text("Recover"),
                )
              ],
            )),
      ),
    );
  }

  handleData(String id) {
    if (recoverList.contains(id)) {
      recoverList.remove(id);
    } else {
      recoverList.add(id);
    }

    setState(() {});
  }

  bool checkId(String id) {
    if (recoverList.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  // bool selectAll() {
  //   if (ref.watch(todoTrashProvider).length == recoverList.length) {
  //     return true;

  //   } else {

  //     return false;
  //   }
  // }
  // handleAlldata(){
  //   if){

  //   }
  // }
}
