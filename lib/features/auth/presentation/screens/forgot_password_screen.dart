import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/validation_utils.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _resetEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      final failure = await authNotifier.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure?.message;
          _resetEmailSent = failure == null;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 30),
          onPressed: () => context.pop(),
        ),
        title: const Text(''),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                // Icon
                SvgPicture.asset(
                  'assets/images/Forgot password-rafiki.svg',
                  height: 300,
                  width: 300,
                ),

                const SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _resetEmailSent ? 'Reset email sent' : 'Forgot Password?',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  _resetEmailSent
                      ? 'We\'ve sent instructions to reset your password to ${_emailController.text.trim()}. Please check your email.'
                      : 'Enter your email address and we\'ll send you instructions to reset your password.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Display error message if any
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_errorMessage != null) const SizedBox(height: 24),

                // Show email field and submit button only if reset email hasn't been sent
                if (!_resetEmailSent) ...[
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    validator: ValidationUtils.validateEmail,
                    enabled: !_isLoading,
                    onFieldSubmitted: (_) => _sendResetEmail(),
                  ),

                  const SizedBox(height: 32),

                  // Reset password button
                  LoadingButton(
                    isLoading: _isLoading,
                    onPressed: _sendResetEmail,
                    height: 50,
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    borderRadius: 20,
                    child: const Text('Send Reset Link'),
                  ),
                ] else ...[
                  // Button to resend email
                  OutlinedButton.icon(
                    onPressed:
                        !_isLoading
                            ? () {
                              setState(() {
                                _resetEmailSent = false;
                              });
                            }
                            : null,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Send to a different email'),
                  ),

                  const SizedBox(height: 16),

                  // Button to go to login
                  FilledButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Return to Login'),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
