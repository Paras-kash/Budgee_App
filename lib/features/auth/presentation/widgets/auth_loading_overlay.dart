import 'package:flutter/material.dart';

/// A minimal and elegant loading overlay for authentication processes
/// This overlay completely covers the screen, ensuring no app logo shows through
class AuthLoadingOverlay extends StatelessWidget {
  /// Text to display while loading
  final String loadingText;

  const AuthLoadingOverlay({super.key, required this.loadingText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Minimal loading indicator
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                    strokeWidth: 3,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Loading text
            Text(
              loadingText,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
