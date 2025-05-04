import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budgee/core/providers/theme_provider.dart';
import 'package:budgee/core/config/router.dart';
import 'package:budgee/core/config/dependency_injection.dart';
import 'package:budgee/core/theme/app_theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'dart:io' show Platform;
import 'dart:async';

// Global error handler for uncaught Flutter errors
void _handleFlutterError(FlutterErrorDetails details) {
  FlutterError.dumpErrorToConsole(details);
  // You could also report to a crash reporting service here
  print('Flutter error caught by global handler: ${details.exception}');
}

// Handler for uncaught async errors
Future<void> _handleUncaughtError(Object error, StackTrace stack) async {
  print('Uncaught async error: $error');
  print('Stack trace: $stack');
  // You could also report to a crash reporting service here
}

Future<void> main() async {
  // Set up error handlers
  FlutterError.onError = _handleFlutterError;

  // Handle uncaught async errors
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Lock device orientation to portrait
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    try {
      // Initialize Firebase with error handling
      await Firebase.initializeApp().catchError((error) {
        print('Firebase initialization error: $error');
        throw Exception('Failed to initialize Firebase: $error');
      });

      // Initialize Firebase App Check with platform-specific providers
      await _initializeAppCheck();

      // Initialize dependencies
      await initDependencies();

      runApp(
        ProviderScope(
          // Override any providers if needed for error reporting
          child: BudgeeApp(),
        ),
      );
    } catch (e, stackTrace) {
      print('Error during app initialization: $e');
      print('Stack trace: $stackTrace');

      // Show error UI to the user
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 60),
                    SizedBox(height: 20),
                    Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please restart the app or contact support if the problem persists.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    if (kDebugMode)
                      Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[200],
                        child: Text(
                          'Error details (debug mode):\n$e',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }, _handleUncaughtError);
}

Future<void> _initializeAppCheck() async {
  try {
    // Choose appropriate providers based on platform and environment
    if (kDebugMode) {
      // Debug mode configuration - use debug providers across all platforms
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    } else {
      // Production configuration
      if (Platform.isAndroid) {
        await FirebaseAppCheck.instance.activate(
          androidProvider: AndroidProvider.playIntegrity,
        );
      } else if (Platform.isIOS || Platform.isMacOS) {
        await FirebaseAppCheck.instance.activate(
          appleProvider: AppleProvider.deviceCheck,
        );
      } else if (kIsWeb) {
        await FirebaseAppCheck.instance.activate(
          webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
        );
      }
    }
    print('Firebase App Check initialized successfully');
  } catch (e) {
    print('Error initializing Firebase App Check: $e');
    // Continue execution even if App Check fails - Firebase will still work
  }
}

class BudgeeApp extends ConsumerWidget {
  const BudgeeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      title: 'Budgee',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      builder: (context, child) {
        // Add error handling for widget errors
        ErrorWidget.builder = (FlutterErrorDetails details) {
          if (kDebugMode) {
            // In debug mode, show the standard error widget for easier debugging
            return ErrorWidget(details.exception);
          }
          // In production, show a more user-friendly error widget
          return Container(
            alignment: Alignment.center,
            child: Text(
              'Something went wrong',
              style: TextStyle(color: Colors.red),
            ),
          );
        };

        return child!;
      },
    );
  }
}
