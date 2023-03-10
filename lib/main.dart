import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_riverpod/controller/theme_provider.dart';
import 'package:todo_riverpod/home_screen.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_riverpod/seemore_description_screen.dart';
import 'package:todo_riverpod/setting_screen.dart';
import 'package:todo_riverpod/trash_screen.dart';
import 'package:todo_riverpod/utils/shared_pref.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: generateMaterialColor(color: Colors.blueGrey),
  brightness: Brightness.light,
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: generateMaterialColor(color: Colors.blueGrey),
  brightness: Brightness.dark,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    // override the previous value with the new object
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
  ], child: const TodoRiverPod()));
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
        //
        GoRoute(
          path: 'seeMoreDescriptionScreen',
          builder: (BuildContext context, GoRouterState state) {
            return SeeMoreDescriptionScreen(
              description: state.extra.toString(),
            );
          },
        ),
        GoRoute(
          path: 'settingScreen',
          builder: (BuildContext context, GoRouterState state) {
            return  SettingScreen();
          },
        ),
      ],
    ),
  ],
);

class TodoRiverPod extends ConsumerWidget {
  const TodoRiverPod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter todo with riverpod demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _router,
    );
  }
}
