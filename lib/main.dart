import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/home_screen.dart';
import 'package:material_color_generator/material_color_generator.dart';

void main() {
  runApp(const ProviderScope(child: TodoRiverPod()));
}

class TodoRiverPod extends StatelessWidget {
  const TodoRiverPod({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter todo with riverpod demo',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(
            color: Colors.blueGrey),
      ),
      home: const HomeScreen(),
    );
  }
}
