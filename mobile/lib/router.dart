import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/breathing/presentation/controller/breathing_controller.dart';
import 'features/breathing/domain/breathing_phase.dart';

// Placeholder breathing screen that shows phase info and navigation
class BreathingPlaceholderScreen extends ConsumerWidget {
  const BreathingPlaceholderScreen({
    super.key,
    required this.phase,
  });

  final BreathingPhase phase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breathingState = ref.watch(breathingControllerProvider);
    final controller = ref.read(breathingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29), // Dark blue like designs
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Phase icon
              Icon(
                _getPhaseIcon(phase),
                size: 100,
                color: const Color(0xFF4A90E2),
              ),
              const SizedBox(height: 24),
              
              // Phase title
              Text(
                phase.displayName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              // Oracle message
              Text(
                phase.oracleMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              
              // Current state info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Current State: ${breathingState.phase.displayName}',
                      style: const TextStyle(color: Colors.white54),
                    ),
                    Text(
                      'Progress: ${(breathingState.progress * 100).toInt()}%',
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.nextPhase();
                      final nextPhase = breathingState.phase.nextPhase;
                      if (nextPhase != null) {
                        context.go(nextPhase.routePath);
                      }
                    },
                    child: const Text('Next Phase'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.reset();
                      context.go('/intro');
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPhaseIcon(BreathingPhase phase) {
    switch (phase) {
      case BreathingPhase.intro:
        return Icons.self_improvement;
      case BreathingPhase.inhale:
        return Icons.keyboard_arrow_down;
      case BreathingPhase.hold:
        return Icons.pause_circle;
      case BreathingPhase.exhale:
        return Icons.keyboard_arrow_up;
      case BreathingPhase.success:
        return Icons.check_circle;
    }
  }
}

// TODO: Import actual breathing exercise screens when created
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
      builder: (context, state) => const BreathingPlaceholderScreen(
        phase: BreathingPhase.intro,
      ),
    ),
    GoRoute(
      path: '/inhale',
      name: 'inhale',
      builder: (context, state) => const BreathingPlaceholderScreen(
        phase: BreathingPhase.inhale,
      ),
    ),
    GoRoute(
      path: '/hold',
      name: 'hold',
      builder: (context, state) => const BreathingPlaceholderScreen(
        phase: BreathingPhase.hold,
      ),
    ),
    GoRoute(
      path: '/exhale',
      name: 'exhale',
      builder: (context, state) => const BreathingPlaceholderScreen(
        phase: BreathingPhase.exhale,
      ),
    ),
    GoRoute(
      path: '/success',
      name: 'success',
      builder: (context, state) => const BreathingPlaceholderScreen(
        phase: BreathingPhase.success,
      ),
    ),
    GoRoute(
      path: '/episode3-placeholder',
      name: 'episode3',
      builder: (context, state) => const Scaffold(
        backgroundColor: Color(0xFF1A1D29),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.upcoming,
                size: 80,
                color: Color(0xFF4A90E2),
              ),
              SizedBox(height: 24),
              Text(
                'Episode 3',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Coming Soon!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
);