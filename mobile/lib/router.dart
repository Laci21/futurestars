import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/breathing/presentation/controller/breathing_controller.dart';
import 'features/breathing/presentation/controller/breathing_animation_controller.dart';
import 'features/breathing/presentation/widgets/breathing_bubble.dart';
import 'features/breathing/presentation/widgets/progress_line.dart';
import 'features/breathing/presentation/screens/breathing_exercise_screen.dart';
import 'features/breathing/presentation/screens/episode3_placeholder_screen.dart';
import 'features/breathing/domain/breathing_phase.dart';

// Test screen for breathing bubble component
class BreathingPlaceholderScreen extends ConsumerStatefulWidget {
  const BreathingPlaceholderScreen({
    super.key,
    required this.phase,
  });

  final BreathingPhase phase;

  @override
  ConsumerState<BreathingPlaceholderScreen> createState() => _BreathingPlaceholderScreenState();
}

class _BreathingPlaceholderScreenState extends ConsumerState<BreathingPlaceholderScreen> 
    with TickerProviderStateMixin {
  late BreathingAnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = BreathingAnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final breathingState = ref.watch(breathingControllerProvider);
    final controller = ref.read(breathingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29), // Dark blue like designs
      body: Column(
        children: [
          // Progress line at the top - static during episode
          const BreathingProgressLine(),
          
          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              // Test breathing bubble with animation
              BreathingBubble(
                animationController: _animationController,
                currentPhase: widget.phase.name, // Use the page phase for display
              ),
              const SizedBox(height: 32),
              
              // Phase title
              Text(
                widget.phase.displayName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              // Oracle message
              Text(
                widget.phase.oracleMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              
              // Animation test controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _animationController.start(),
                    child: const Text('Start'),
                  ),
                  ElevatedButton(
                    onPressed: () => _animationController.pause(),
                    child: const Text('Pause'),
                  ),
                  ElevatedButton(
                    onPressed: () => _animationController.reset(),
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
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
        ],
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