import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

/// Button for biometric authentication (fingerprint, face ID, etc.)
class BiometricButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;

  const BiometricButton({
    super.key,
    this.onPressed,
    this.label = 'Sign in with biometrics',
  });

  @override
  State<BiometricButton> createState() => _BiometricButtonState();
}

class _BiometricButtonState extends State<BiometricButton> {
  late Future<List<BiometricType>> _availableBiometrics;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _availableBiometrics = _getAvailableBiometrics();
  }

  Future<List<BiometricType>> _getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  IconData _getBiometricIcon(List<BiometricType> biometrics) {
    if (biometrics.contains(BiometricType.face)) {
      return Icons.face_outlined;
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return Icons.fingerprint;
    } else if (biometrics.contains(BiometricType.iris)) {
      return Icons.remove_red_eye_outlined;
    } else if (biometrics.contains(BiometricType.strong)) {
      return Icons.shield_outlined;
    } else if (biometrics.contains(BiometricType.weak)) {
      return Icons.security_outlined;
    }
    return Icons.lock_outlined;
  }

  String _getBiometricLabel(List<BiometricType> biometrics) {
    if (biometrics.contains(BiometricType.face)) {
      return 'Sign in with Face ID';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Sign in with Fingerprint';
    }
    return widget.label;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<BiometricType>>(
      future: _availableBiometrics,
      builder: (context, snapshot) {
        final biometrics = snapshot.data ?? [];

        return OutlinedButton.icon(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: theme.colorScheme.secondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: Icon(_getBiometricIcon(biometrics)),
          label: Text(_getBiometricLabel(biometrics)),
        );
      },
    );
  }
}
