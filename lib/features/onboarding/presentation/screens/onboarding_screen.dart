import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_model.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
          _isLastPage = _currentPage == onboardingPages.length - 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Navigate to the welcome screen
  void _navigateToWelcomeScreen() async {
    // Mark onboarding as completed using our provider
    await ref.read(onboardingStatusProvider.notifier).setOnboardingComplete();
    if (mounted) {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // PageView for the onboarding pages
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(model: onboardingPages[index]);
            },
          ),

          // Skip button (top right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: TextButton(
              onPressed: _navigateToWelcomeScreen,
              child: Text(
                'Skip',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: onboardingPages[_currentPage].textColor,
                ),
              ),
            ),
          ),

          // Bottom controls (indicators and next/done button)
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingPages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color:
                            _currentPage == index
                                ? onboardingPages[_currentPage].textColor
                                : onboardingPages[_currentPage].textColor
                                    .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Next/Done button
                FilledButton(
                  onPressed: () {
                    if (_isLastPage) {
                      _navigateToWelcomeScreen();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    backgroundColor: onboardingPages[_currentPage].textColor,
                    foregroundColor:
                        onboardingPages[_currentPage].backgroundColor,
                  ),
                  child: Text(_isLastPage ? 'Get Started' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
