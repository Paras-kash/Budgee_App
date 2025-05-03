// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentThemeHash() => r'39a7a28630f0318aff8573a1ba4af86d677aab82';

/// Provides the current theme data based on theme mode
///
/// Copied from [currentTheme].
@ProviderFor(currentTheme)
final currentThemeProvider = AutoDisposeProvider<ThemeData>.internal(
  currentTheme,
  name: r'currentThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentThemeRef = AutoDisposeProviderRef<ThemeData>;
String _$themeControllerHash() => r'34f0bcf37b5ccda99ac6b487aafcc68fac124d84';

/// See also [ThemeController].
@ProviderFor(ThemeController)
final themeControllerProvider =
    NotifierProvider<ThemeController, ThemeMode>.internal(
      ThemeController.new,
      name: r'themeControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$themeControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ThemeController = Notifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
