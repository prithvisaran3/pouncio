import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils.dart';
import '../../../theme/colors.dart';
import '../../home/application/jobs_provider.dart';

/// SplashView provides the entry/splash animation for Pouncio.
/// Features a modern, fluid typewriter animation of the Georgia bold italic wordmark.
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _cursorController;
  late Animation<int> _charCountAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _cursorOpacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _charCountAnimation = IntTween(begin: 0, end: 7).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.85, 1.0, curve: Curves.easeInOut),
      ),
    );

    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..repeat(reverse: true);

    _cursorOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cursorController,
        curve: Curves.easeInOut,
      ),
    );

    _mainController.forward();

    Timer(const Duration(milliseconds: 1850), () async {
      if (!mounted) return;
      
      final router = GoRouter.of(context);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        router.go('/login');
      } else {
        try {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          final data = doc.data();
          final bool isOnboarded = data?['isOnboardingComplete'] as bool? ?? false;
          if (isOnboarded) {
            router.go('/home');
          } else {
            router.go('/onboarding');
          }
        } catch (e) {
          debugPrint('[Splash ERROR] Failed to load onboarding status: $e');
          router.go('/home'); // Fallback safe navigation
        }
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch jobsStateProvider to preload job list data from Firestore on startup
    ref.watch(jobsStateProvider);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      child: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_mainController, _cursorController]),
          builder: (context, child) {
            final charCount = _charCountAnimation.value;
            final overallOpacity = _fadeAnimation.value;
            final isDoneTyping = _mainController.value >= 0.65;
            
            return Opacity(
              opacity: overallOpacity,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Pouncio'.substring(0, charCount),
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontSize: Responsive.scaleText(context, 48.0),
                        color: AppColors.textPrimary(context),
                        letterSpacing: -1.0,
                      ),
                    ),
                    TextSpan(
                      text: '│',
                      style: TextStyle(
                        fontSize: Responsive.scaleText(context, 46.0),
                        fontWeight: FontWeight.w200,
                        color: AppColors.accent.withValues(
                          alpha: isDoneTyping && _mainController.value > 0.82
                              ? 0.0
                              : _cursorOpacityAnimation.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
