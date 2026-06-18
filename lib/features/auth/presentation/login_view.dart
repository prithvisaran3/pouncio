import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../services/auth_provider.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/google_logo.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' hide GlassCard;
import '../../../theme/colors.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Error', 'Please fill in all fields.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final router = GoRouter.of(context);
      await ref.read(authServiceProvider).signInWithEmail(email, password);
      final user = ref.read(authServiceProvider).currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final bool isOnboarded = doc.data()?['isOnboardingComplete'] as bool? ?? false;
        if (isOnboarded) {
          router.go('/home');
        } else {
          router.go('/onboarding');
        }
      }
    } catch (e) {
      if (mounted) _showError('Login Failed', e.toString().replaceFirst(RegExp(r'\[.*\] '), ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final router = GoRouter.of(context);
      final credential = await ref.read(authServiceProvider).signInWithGoogle();
      if (credential != null) {
        final user = credential.user;
        if (user != null) {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          final bool isOnboarded = doc.data()?['isOnboardingComplete'] as bool? ?? false;
          if (isOnboarded) {
            router.go('/home');
          } else {
            router.go('/onboarding');
          }
        }
      }
    } catch (e) {
      if (mounted) _showError('Google Sign-In Failed', e.toString());
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
        // Modern Premium Mesh/Gradient Background
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
              right: -80,
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
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: Responsive.scale(context, 42.0)),
                          child: GlassCard(
                            radius: AppConstants.radiusCard,
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.scale(context, AppConstants.screenPadding),
                              vertical: Responsive.scale(context, 24.0),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: Responsive.scale(context, 38.0)),
                                Text(
                                  'Pouncio',
                                  style: TextStyle(
                                    fontFamily: 'Georgia',
                                    fontSize: Responsive.scaleText(context, 32.0),
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textPrimary(context),
                                    letterSpacing: -0.6,
                                  ),
                                ),
                                SizedBox(height: Responsive.scale(context, 26.0)),
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
                                SizedBox(height: Responsive.scale(context, 24.0)),
                                SizedBox(
                                  width: double.infinity,
                                  height: Responsive.scale(context, 46.0),
                                  child: CNButton(
                                    label: _isLoading ? 'Authenticating...' : 'Log In',
                                    onPressed: _isLoading ? () {} : _handleLogin,
                                    style: CNButtonStyle.filled,
                                    tint: AppColors.accent,
                                  ),
                                ),
                                SizedBox(height: Responsive.scale(context, 12.0)),
                                SizedBox(
                                  width: double.infinity,
                                  height: Responsive.scale(context, 46.0),
                                  child: GlassButton.custom(
                                    onTap: () {
                                      if (!_isLoading) _handleGoogleSignIn();
                                    },
                                    persistPressOnDrag: false,
                                    useOwnLayer: false,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GoogleLogo(size: Responsive.scale(context, 18.0)),
                                        SizedBox(width: Responsive.scale(context, 10.0)),
                                        Text(
                                          'Continue with Google',
                                          style: TextStyle(
                                            color: AppColors.textPrimary(context),
                                            fontWeight: FontWeight.bold,
                                            fontSize: Responsive.scaleText(context, 14.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: Responsive.scale(context, 24.0)),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: Responsive.scaleText(context, 14.0),
                                        color: AppColors.textSecondary(context),
                                      ),
                                      children: [
                                        const TextSpan(text: "Don't have an account? "),
                                        const TextSpan(
                                          text: 'Sign Up',
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
                                    router.go('/signup');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            width: Responsive.scale(context, 84.0),
                            height: Responsive.scale(context, 84.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: isDark ? 0.35 : 0.2),
                                  blurRadius: 24,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
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
