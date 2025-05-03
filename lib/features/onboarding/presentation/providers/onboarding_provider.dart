import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/utils/preferences_service.dart';

part 'onboarding_provider.g.dart';

@riverpod
class OnboardingStatus extends _$OnboardingStatus {
  @override
  Future<bool> build() async {
    return PreferencesService.isOnboardingCompleted();
  }

  Future<void> setOnboardingComplete() async {
    await PreferencesService.setOnboardingCompleted();
    ref.invalidateSelf();
  }
}
