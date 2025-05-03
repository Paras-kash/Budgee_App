import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageModel model;

  const OnboardingPage({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: model.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(model.imagePath, height: 200, width: 200),
          const SizedBox(height: 48),
          Text(
            model.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: model.textColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              model.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: model.textColor.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
