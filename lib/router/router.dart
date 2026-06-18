import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_view.dart';
import '../features/auth/presentation/signup_view.dart';
import '../features/auth/presentation/onboarding_view.dart';
import '../features/splash/presentation/splash_view.dart';
import '../features/home/presentation/home_view.dart';
import '../features/job_detail/presentation/job_detail_view.dart';
import '../features/notifications/presentation/notifications_view.dart';
import '../features/profile/presentation/profile_view.dart';
import '../features/saved_jobs/presentation/saved_jobs_view.dart';
import '../shared/widgets/scaffold_with_nested_navigation.dart';

/// AppRouter defines the GoRouter configuration for Pouncio.
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final goingToAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/onboarding';
      final goingToSplash = state.matchedLocation == '/splash';

      if (goingToSplash) return null;

      if (user == null) {
        if (!goingToAuth) {
          return '/login';
        }
      } else {
        if (state.matchedLocation == '/login' || state.matchedLocation == '/signup') {
          return '/home';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/signup',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const OnboardingView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/saved',
                builder: (context, state) => const SavedJobsView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notifications',
                builder: (context, state) => const NotificationsView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/job/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final jobId = state.pathParameters['id'] ?? '';
          return JobDetailView(jobId: jobId);
        },
      ),
    ],
  );
}
