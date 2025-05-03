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

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
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
      // Allow splash screen to handle initial routing logic
      if (state.uri.toString() == '/') {
        return null;
      }

      // Wait for onboardingCompleted to resolve
      final isOnboardingCompleted = await onboardingCompleted.value;

      // If onboarding is not completed and user is not on onboarding screen, redirect to onboarding
      if (isOnboardingCompleted == false &&
          state.uri.toString() != '/onboarding' &&
          state.uri.toString() != '/') {
        return '/onboarding';
      }

      return null;
    },
    errorBuilder:
        (context, state) => Material(
          child: Center(
            child: Text(
              'Route not found: ${state.uri}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
  );
}
