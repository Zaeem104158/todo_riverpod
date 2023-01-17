import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/utils/shared_pref.dart';

final isDarkProvider = StateNotifierProvider<DarkThemeNotifier, bool>((ref) {
  return DarkThemeNotifier(ref: ref);
});


class DarkThemeNotifier extends StateNotifier<bool> {
  DarkThemeNotifier({required this.ref}) : super(true) {
    state = ref.watch(sharedUtilityProvider).isDarkModeEnabled();
  }
  Ref ref;

  void toggleTheme() {
    ref.watch(sharedUtilityProvider).setDarkModeEnabled(
          isdark: !ref.watch(sharedUtilityProvider).isDarkModeEnabled(),
        );
    state = ref.watch(sharedUtilityProvider).isDarkModeEnabled();
  }
}