import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/home_screen.dart';

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
        primarySwatch: Colors.lightGreen,
      ),
      home: const HomeScreen(),
    );
  }
}

