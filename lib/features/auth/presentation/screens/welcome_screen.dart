import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed: Using SvgPicture.asset instead of Image.asset for SVG files
            SvgPicture.asset(
              'assets/images/Welcome.svg',
              height: size.height * 0.6,
              width: size.width * 0.8,
              fit: BoxFit.contain,
            ),
            // App  and welcome text
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Welcome to ',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Text(
                  'Budgee ',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Take charge of your finances with Budgee. Plan better, spend smarter, and stay on top of your money — every day.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black38,
                  ),
                ),
              ),
            ),

            // Auth options
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Login button
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FilledButton(
                      onPressed: () => context.push('/login'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Log In'),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Sign up button
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: OutlinedButton(
                      onPressed: () => context.push('/signup'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: theme.colorScheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Continue as guest
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
