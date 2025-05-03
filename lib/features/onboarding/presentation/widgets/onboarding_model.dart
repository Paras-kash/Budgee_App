import 'package:flutter/material.dart';

/// Represents a single page in the onboarding carousel
class OnboardingPageModel {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final Color textColor;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.textColor,
  });
}

/// List of onboarding pages to be displayed
final List<OnboardingPageModel> onboardingPages = [
  OnboardingPageModel(
    title: 'Track Your Expenses',
    description:
        'Keep track of your daily spending and see where your money goes in real-time.',
    imagePath: 'assets/images/tracking.svg',
    backgroundColor: Color(
      0xFFEADDFF,
    ), // Light purple (M3 primary color light variant)
    textColor: Color(0xFF21005D), // Deep purple (M3 primary color dark variant)
  ),
  OnboardingPageModel(
    title: 'Create Budget Goals',
    description:
        'Set financial goals and get personalized plans to achieve them faster.',
    imagePath: 'assets/images/goals.svg',
    backgroundColor: Color(
      0xFFFFD8E4,
    ), // Light pink (M3 secondary color light variant)
    textColor: Color(0xFF31111D), // Deep pink (M3 secondary color dark variant)
  ),
  OnboardingPageModel(
    title: 'Smart Insights',
    description:
        'Get detailed analytics and suggestions to improve your financial health.',
    imagePath: 'assets/images/insights.svg',
    backgroundColor: Color(
      0xFFDEF5E5,
    ), // Light green (M3 tertiary color light variant)
    textColor: Color(0xFF002022), // Deep green (M3 tertiary color dark variant)
  ),
  OnboardingPageModel(
    title: 'Secure & Private',
    description:
        'Your financial data remains secure with end-to-end encryption and local storage.',
    imagePath: 'assets/images/security.svg',
    backgroundColor: Color(0xFFF2F2F2), // Light grey
    textColor: Color(0xFF1D1B20), // Dark grey (M3 neutral color)
  ),
];
