import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  static const _themePrefsKey = 'is_dark_mode';

  @override
  ThemeMode build() {
    // Default to system theme
    return ThemeMode.system;
  }

  Future<void> toggleTheme() async {
    final currentState = state;
    final newState =
        currentState == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    // Update the state
    state = newState;

    // Persist the theme preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePrefsKey, newState == ThemeMode.dark);
  }

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themePrefsKey);

    if (isDarkMode != null) {
      state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }
}

/// Provides the current theme data based on theme mode
@riverpod
ThemeData currentTheme(Ref ref) {
  final themeMode = ref.watch(themeControllerProvider);

  return switch (themeMode) {
    ThemeMode.light => AppTheme.light(),
    ThemeMode.dark => AppTheme.dark(),
    ThemeMode.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark
          ? AppTheme.dark()
          : AppTheme.light(),
  };
}
