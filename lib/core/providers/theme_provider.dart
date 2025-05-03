import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../theme/app_theme.dart';
import '../utils/preferences_service.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
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
    await PreferencesService.setDarkMode(newState == ThemeMode.dark);
  }

  Future<void> loadThemePreference() async {
    final isDarkMode = await PreferencesService.isDarkMode();

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
