import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budgee/core/providers/theme_provider.dart';
import 'package:budgee/core/config/router.dart';
import 'package:budgee/core/theme/app_theme.dart';
import 'package:budgee/core/config/dependency_injection.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initDependencies();

  // Run the app wrapped in a ProviderScope for Riverpod
  runApp(const ProviderScope(child: BudgeeApp()));
}

class BudgeeApp extends ConsumerStatefulWidget {
  const BudgeeApp({super.key});

  @override
  ConsumerState<BudgeeApp> createState() => _BudgeeAppState();
}

class _BudgeeAppState extends ConsumerState<BudgeeApp> {
  @override
  void initState() {
    super.initState();
    // Load user's theme preference
    Future.delayed(Duration.zero, () {
      ref.read(themeControllerProvider.notifier).loadThemePreference();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get router from provider
    final router = ref.watch(routerProvider);

    // Get current theme mode from theme provider
    final themeMode = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      title: 'Budgee',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
