import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/breathing/presentation/screens/breathing_exercise_screen.dart';
import 'package:mobile/features/breathing/presentation/screens/episode3_placeholder_screen.dart';





/// App router configuration using go_router
/// Defines all navigation routes for the breathing exercise
final GoRouter appRouter = GoRouter(
  initialLocation: '/breathing-exercise',
  routes: [
    // New Breathing Exercise Screen (single screen, dynamic content)
    GoRoute(
      path: '/breathing-exercise',
      name: 'breathing-exercise',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const BreathingExerciseScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide from right when coming from Episode 3 (going back)
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero),
            ),
            child: child,
          );
        },
      ),
    ),

    GoRoute(
      path: '/episode3-placeholder',
      name: 'episode3',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const Episode3PlaceholderScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide from right when coming from Episode 2 (going forward)
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
            ),
            child: child,
          );
        },
      ),
    ),
  ],
);