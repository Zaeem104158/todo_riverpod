import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/controller/setting_view_provider.dart';
import 'package:todo_riverpod/utils/size_config.dart';

class SettingScreen extends ConsumerWidget {
   const SettingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isTabContainerSelected = ref.watch(tabContainerProvider);
    
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Setting",
              ),
            ),
            body: SizedBox(
              height: SizeConfig.getScreenHeight(context) / 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      isTabContainerSelected = !isTabContainerSelected;
                      toggleTab(ref, isTabContainerSelected);
                    },
                    child: Text(
                        isTabContainerSelected ? "Selected" : "Unselected"),
                  ),
                ],
              ),
            )));
  }

  toggleTab(WidgetRef ref, bool onClickBool) {
    log("${onClickBool}");
    ref.read(tabContainerProvider.notifier).state = onClickBool;
  }
}
