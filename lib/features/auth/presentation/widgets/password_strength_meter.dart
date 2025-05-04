import 'package:flutter/material.dart';

/// Widget that displays a visual representation of password strength
class PasswordStrengthMeter extends StatelessWidget {
  /// The password to evaluate
  final String password;

  const PasswordStrengthMeter({super.key, required this.password});

  /// Calculate the strength of the password (0-4)
  int _calculateStrength() {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check (basic requirement)
    if (password.length >= 8) strength++;

    // Contains uppercase letters
    if (password.contains(RegExp(r'[A-Z]'))) strength++;

    // Contains numbers
    if (password.contains(RegExp(r'[0-9]'))) strength++;

    // Contains special characters
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    return strength;
  }

  /// Get the color for the current strength level
  Color _getStrengthColor(BuildContext context, int strength) {
    if (strength == 0) return Colors.grey.shade300;

    final colors = [
      Colors.red, // Very weak
      Colors.orange, // Weak
      Colors.yellow, // Fair
      Colors.lightGreen, // Good
      Colors.green, // Strong
    ];

    // Return the color based on strength (index 0-4)
    return colors[strength - 1];
  }

  /// Get text description of password strength
  String _getStrengthText(int strength) {
    if (password.isEmpty) return '';

    final descriptions = ['Very weak', 'Weak', 'Fair', 'Good', 'Strong'];

    // Return the description based on strength (index 0-4)
    return descriptions[strength];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strength = _calculateStrength();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bars
        Row(
          children: List.generate(4, (index) {
            final isActive = strength > index;
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color:
                      isActive
                          ? _getStrengthColor(context, strength)
                          : theme.disabledColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),

        // Strength text
        if (password.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            _getStrengthText(strength),
            style: theme.textTheme.bodySmall?.copyWith(
              color: _getStrengthColor(context, strength),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
