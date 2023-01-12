import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/home_screen.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_riverpod/seemore_description_screen.dart';
import 'package:todo_riverpod/trash_screen.dart';

void main() {
  runApp(const ProviderScope(child: TodoRiverPod()));
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'trashScreen',
          builder: (BuildContext context, GoRouterState state) {
            return const TrashScreen();
          },
        ),
        GoRoute(
          path: 'seeMoreDescriptionScreen',
          builder: (BuildContext context, GoRouterState state) {
            return SeeMoreDescriptionScreen(
              description: state.extra.toString(),
            );
          },
        ),
      ],
    ),
  ],
);

class TodoRiverPod extends StatelessWidget {
  const TodoRiverPod({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter todo with riverpod demo',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: Colors.blueGrey),
      ),
      routerConfig: _router,
    );
  }
}
