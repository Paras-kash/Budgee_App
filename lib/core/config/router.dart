import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'dart:developer' as dev;

part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Custom page transitions
CustomTransitionPage<T> buildPageWithSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  bool reverse = false,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = reverse ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
      final end = Offset.zero;
      final curve = Curves.easeInOutCubic;
      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

CustomTransitionPage<T> buildPageWithFadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

@riverpod
GoRouter router(Ref ref) {
  final onboardingCompleted = ref.watch(onboardingStatusProvider);

  // Add authentication state watch
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true, // Enable router logging
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder:
            (context, state) => buildPageWithFadeTransition(
              context: context,
              state: state,
              child: const OnboardingScreen(),
            ),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        pageBuilder:
            (context, state) => buildPageWithFadeTransition(
              context: context,
              state: state,
              child: const WelcomeScreen(),
            ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder:
            (context, state) => buildPageWithSlideTransition(
              context: context,
              state: state,
              child: const LoginScreen(),
            ),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder:
            (context, state) => buildPageWithSlideTransition(
              context: context,
              state: state,
              child: const SignupScreen(),
            ),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder:
            (context, state) => buildPageWithFadeTransition(
              context: context,
              state: state,
              child: const DashboardScreen(),
            ),
      ),
    ],
    redirect: (context, state) async {
      final currentLocation = state.uri.toString();
      dev.log('Routing: Redirecting from $currentLocation', name: 'Router');

      // Allow splash screen to handle initial routing logic
      if (currentLocation == '/') {
        dev.log('Routing: Not redirecting from splash screen', name: 'Router');
        return null;
      }

      // Get authentication state
      final isAuthenticated = authState.valueOrNull == AuthState.authenticated;
      dev.log(
        'Routing: Auth state is: ${authState.valueOrNull}',
        name: 'Router',
      );

      // Wait for onboardingCompleted to resolve
      final isOnboardingCompleted = await onboardingCompleted.value;
      dev.log(
        'Routing: Onboarding completed: $isOnboardingCompleted',
        name: 'Router',
      );

      // Public routes that don't require authentication
      final publicRoutes = [
        '/welcome',
        '/login',
        '/signup',
        '/onboarding',
        '/',
      ];

      // If onboarding is not completed and user is not on onboarding screen, redirect to onboarding
      if (isOnboardingCompleted == false &&
          currentLocation != '/onboarding' &&
          currentLocation != '/') {
        dev.log('Routing: Redirecting to onboarding', name: 'Router');
        return '/onboarding';
      }

      // If authenticated and trying to access login/signup/welcome screens, redirect to dashboard
      if (isAuthenticated && publicRoutes.contains(currentLocation)) {
        dev.log(
          'Routing: User is authenticated, redirecting to dashboard',
          name: 'Router',
        );
        return '/dashboard';
      }

      // If not authenticated and trying to access dashboard, redirect to welcome
      if (!isAuthenticated && currentLocation == '/dashboard') {
        dev.log(
          'Routing: User is not authenticated, redirecting to welcome',
          name: 'Router',
        );
        return '/welcome';
      }

      // Handle error state in authentication
      if (authState is AsyncError && !publicRoutes.contains(currentLocation)) {
        dev.log('Routing: Auth error, redirecting to welcome', name: 'Router');
        return '/welcome';
      }

      // No redirection needed
      dev.log(
        'Routing: No redirection needed for $currentLocation',
        name: 'Router',
      );
      return null;
    },
    errorBuilder: (context, state) {
      dev.log('Router Error: ${state.error}', name: 'Router');
      return Material(
        child: Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'An error occurred',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We couldn\'t find the page you were looking for.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Go to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
