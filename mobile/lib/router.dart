import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO: Import breathing exercise screens when created
// import 'features/breathing/presentation/screens/intro_screen.dart';
// import 'features/breathing/presentation/screens/inhale_screen.dart';
// import 'features/breathing/presentation/screens/hold_screen.dart';
// import 'features/breathing/presentation/screens/exhale_screen.dart';
// import 'features/breathing/presentation/screens/success_screen.dart';

/// App router configuration using go_router
/// Defines all navigation routes for the breathing exercise
final GoRouter appRouter = GoRouter(
  initialLocation: '/intro',
  routes: [
    // Breathing Exercise Routes
    GoRoute(
      path: '/intro',
      name: 'intro',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Intro Screen - Coming Soon!')),
      ),
    ),
    GoRoute(
      path: '/inhale',
      name: 'inhale',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Inhale Screen - Coming Soon!')),
      ),
    ),
    GoRoute(
      path: '/hold',
      name: 'hold',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Hold Screen - Coming Soon!')),
      ),
    ),
    GoRoute(
      path: '/exhale',
      name: 'exhale',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Exhale Screen - Coming Soon!')),
      ),
    ),
    GoRoute(
      path: '/success',
      name: 'success',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Success Screen - Coming Soon!')),
      ),
    ),
    GoRoute(
      path: '/episode3-placeholder',
      name: 'episode3',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Episode 3 - Coming Soon!')),
      ),
    ),
  ],
);