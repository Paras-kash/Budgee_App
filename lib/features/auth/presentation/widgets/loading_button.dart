import 'package:flutter/material.dart';

/// A button that shows a loading indicator when an async operation is in progress
class LoadingButton extends StatelessWidget {
  /// Whether the button is in loading state
  final bool isLoading;

  /// The callback when the button is pressed (not called when loading)
  final VoidCallback? onPressed;

  /// The widget to display when not loading
  final Widget child;

  /// Button width (defaults to match parent)
  final double? width;

  /// Button height
  final double height;

  /// Background color for the button
  final Color? backgroundColor;

  /// Foreground color for the button
  final Color? foregroundColor;

  /// Color of the loading indicator
  final Color? loadingColor;

  /// Border radius for the button
  final double borderRadius;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.child,
    this.width,
    this.height = 50,
    this.backgroundColor,
    this.foregroundColor,
    this.loadingColor,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
          disabledBackgroundColor:
              backgroundColor?.withOpacity(0.7) ??
              theme.colorScheme.primary.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child:
            isLoading
                ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: loadingColor ?? theme.colorScheme.onPrimary,
                    strokeWidth: 2,
                  ),
                )
                : child,
      ),
    );
  }
}
