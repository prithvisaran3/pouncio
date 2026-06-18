import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../services/auth_provider.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' hide GlassCard;
import '../../../shared/widgets/glass_card.dart';
import '../../../theme/colors.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: AppConstants.animationDurationMedium,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError('Error', 'Please fill in all fields.');
      return;
    }

    if (password != confirmPassword) {
      _showError('Error', 'Passwords do not match.');
      return;
    }

    if (password.length < 6) {
      _showError('Error', 'Password must be at least 6 characters.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authServiceProvider).signUpWithEmail(
        email: email,
        password: password,
        name: name,
        phoneNumber: phone,
      );
      if (mounted) {
        context.go('/onboarding');
      }
    } catch (e) {
      _showError('Sign Up Failed', e.toString().replaceFirst(RegExp(r'\[.*\] '), ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String title, String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return CupertinoPageScaffold(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
                    Color(0xFF0D0B14), // Deep dark violet
                    Color(0xFF0A0A0B), // Near black
                    Color(0xFF1E0E0B), // Warm dark orange/red undertone
                  ]
                : const [
                    Color(0xFFFFF7F5), // Peach light glow
                    Color(0xFFFFFFFF), // White
                    Color(0xFFF1EFFF), // Cool slate violet
                  ],
          ),
        ),
        child: Stack(
          children: [
            // Ambient soft glowing blobs
            Positioned(
              top: -80,
              left: -80,
              child: IgnorePointer(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withValues(alpha: isDark ? 0.08 : 0.04),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: isDark ? 0.08 : 0.04),
                        blurRadius: 100,
                        spreadRadius: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.scale(context, AppConstants.screenPadding),
                    ),
                    child: GlassCard(
                      radius: AppConstants.radiusCard,
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.scale(context, AppConstants.screenPadding),
                        vertical: Responsive.scale(context, 24.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: Responsive.scaleText(context, 28.0),
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textPrimary(context),
                              letterSpacing: -0.6,
                            ),
                          ),
                          SizedBox(height: Responsive.scale(context, 20.0)),
                          GlassTextField(
                            controller: _nameController,
                            placeholder: 'Full Name',
                            prefixIcon: Icon(
                              CupertinoIcons.person,
                              size: Responsive.scale(context, 18.0),
                              color: AppColors.textSecondary(context),
                            ),
                            useOwnLayer: false,
                          ),
                          SizedBox(height: Responsive.scale(context, 12.0)),
                          GlassTextField(
                            controller: _emailController,
                            placeholder: 'Email Address',
                            prefixIcon: Icon(
                              CupertinoIcons.mail,
                              size: Responsive.scale(context, 18.0),
                              color: AppColors.textSecondary(context),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            useOwnLayer: false,
                          ),
                          SizedBox(height: Responsive.scale(context, 12.0)),
                          GlassTextField(
                            controller: _phoneController,
                            placeholder: 'Phone Number',
                            prefixIcon: Icon(
                              CupertinoIcons.phone,
                              size: Responsive.scale(context, 18.0),
                              color: AppColors.textSecondary(context),
                            ),
                            keyboardType: TextInputType.phone,
                            useOwnLayer: false,
                          ),
                          SizedBox(height: Responsive.scale(context, 12.0)),
                          GlassTextField(
                            controller: _passwordController,
                            placeholder: 'Password',
                            prefixIcon: Icon(
                              CupertinoIcons.lock,
                              size: Responsive.scale(context, 18.0),
                              color: AppColors.textSecondary(context),
                            ),
                            obscureText: true,
                            useOwnLayer: false,
                          ),
                          SizedBox(height: Responsive.scale(context, 12.0)),
                          GlassTextField(
                            controller: _confirmPasswordController,
                            placeholder: 'Confirm Password',
                            prefixIcon: Icon(
                              CupertinoIcons.lock_shield,
                              size: Responsive.scale(context, 18.0),
                              color: AppColors.textSecondary(context),
                            ),
                            obscureText: true,
                            useOwnLayer: false,
                          ),
                          SizedBox(height: Responsive.scale(context, 20.0)),
                          SizedBox(
                            width: double.infinity,
                            height: Responsive.scale(context, 46.0),
                            child: CNButton(
                              label: _isLoading ? 'Creating Account...' : 'Continue to Onboarding',
                              onPressed: _isLoading ? () {} : _handleSignUp,
                              style: CNButtonStyle.filled,
                              tint: AppColors.accent,
                            ),
                          ),
                          SizedBox(height: Responsive.scale(context, 16.0)),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: Responsive.scaleText(context, 14.0),
                                  color: AppColors.textSecondary(context),
                                ),
                                children: [
                                  const TextSpan(text: 'Already have an account? '),
                                  const TextSpan(
                                    text: 'Log In',
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () async {
                              final router = GoRouter.of(context);
                              await ref.read(authServiceProvider).signOut();
                              router.go('/login');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
