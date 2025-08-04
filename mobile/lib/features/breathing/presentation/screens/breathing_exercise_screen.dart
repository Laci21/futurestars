import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controller/breathing_controller.dart';
import '../controller/breathing_animation_controller.dart';
import '../widgets/breathing_bubble.dart';
import '../widgets/progress_line.dart';
import '../widgets/oracle_avatar.dart';
import '../widgets/gradient_background.dart';
import '../widgets/sound_wave_widget.dart';
import '../../domain/breathing_phase.dart';

/// Single screen for the entire breathing exercise experience
/// Content changes dynamically based on the current breathing phase
class BreathingExerciseScreen extends ConsumerStatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  ConsumerState<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends ConsumerState<BreathingExerciseScreen> 
    with TickerProviderStateMixin {
  late BreathingAnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = BreathingAnimationController(vsync: this);
    
    // Listen for animation completion to handle auto-progression
    _animationController.master.addStatusListener(_onAnimationStatusChanged);
  }

  @override
  void dispose() {
    _animationController.master.removeStatusListener(_onAnimationStatusChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Animation completed - auto-advance to success phase
      // Note: The animation controller handles the breathing sequence automatically
      // This transitions from the final exhale phase to success
      final currentPhase = ref.read(breathingControllerProvider).phase;
      if (currentPhase == BreathingPhase.exhale) {
        ref.read(breathingControllerProvider.notifier).nextPhase();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final breathingState = ref.watch(breathingControllerProvider);
    
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Episode progress lines at top - static throughout
              const BreathingProgressLine(),
              
              // Dynamic content based on current phase
              Expanded(
                child: _buildPhaseContent(breathingState.phase),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseContent(BreathingPhase phase) {
    switch (phase) {
      case BreathingPhase.intro:
        return _buildIntroContent();
      case BreathingPhase.inhale:
      case BreathingPhase.hold:
      case BreathingPhase.exhale:
        return _buildBreathingContent();
      case BreathingPhase.success:
        return _buildSuccessContent();
    }
  }

  Widget _buildIntroContent() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Oracle avatar with message (design shows Oracle + speech bubble)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OracleAvatar(size: 60),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Take a moment to breathe, transform each inhale into power',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your breath is a bridge between challenge and tranquility',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 120),
          
          // NO breathing bubble on intro screen (per design)
          // Design shows only Oracle + message + button
          
          // Start button with rounded design matching design
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFFFD700), // Gold border
                width: 2,
              ),
            ),
            child: ElevatedButton(
              onPressed: _startBreathingExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Start the Breath Exercise',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    color: const Color(0xFFFFD700), // Gold arrow
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingContent() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Oracle avatar with instruction speech bubble (per design)
          AnimatedBuilder(
            animation: _animationController.master,
            builder: (context, child) {
              final currentPhase = _animationController.getCurrentPhase();
              return _buildOracleInstructionBubble(currentPhase);
            },
          ),
          
          // Sound waves above the bubble (animated during breathing)
          AnimatedBuilder(
            animation: _animationController.master,
            builder: (context, child) {
              final isAnimating = _animationController.master.isAnimating;
              return SoundWaveWidget(
                isAnimating: isAnimating,
                barCount: 15,
                maxHeight: 30,
                color: const Color(0xFFE8F8FF).withOpacity(0.8),
              );
            },
          ),
          
          // Animated breathing bubble (handles all phases automatically)
          BreathingBubble(
            animationController: _animationController,
            currentPhase: _animationController.getCurrentPhase(),
          ),
          
          // Fixed bottom instruction text (per design)
          const Text(
            'Follow the breathing instructions',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Build Oracle avatar with instruction speech bubble for breathing phases
  Widget _buildOracleInstructionBubble(String phase) {
    String instruction;
    switch (phase) {
      case 'inhale':
        instruction = 'Inhale slowly for 5 seconds and fill your lungs';
        break;
      case 'hold':
        instruction = 'Hold in the breath for a while...';
        break;
      case 'exhale':
        instruction = 'Exhale slowly for 5 seconds and empty your lungs';
        break;
      default:
        instruction = 'Follow the breathing instructions';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OracleAvatar(size: 50),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            instruction,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseInstructions(String phase) {
    String instruction;
    switch (phase) {
      case 'inhale':
        instruction = 'Inhale slowly for 5 seconds\nand fill your lungs.';
        break;
      case 'hold':
        instruction = 'Hold the breath for a while...';
        break;
      case 'exhale':
        instruction = 'Exhale slowly for 5 seconds\nand empty your lungs.';
        break;
      default:
        instruction = 'Follow the breathing instructions.';
    }

    return Text(
      instruction,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
        height: 1.4,
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Oracle avatar with success message (per design)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OracleAvatar(size: 50),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fantastic job!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your breath is your superpower, offering strength and calm.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Trust it to guide you and empower your journey ahead.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // NO sound waves on success screen (per design)
          // Success breathing bubble (checkmark)
          BreathingBubble(
            animationController: _animationController,
            currentPhase: 'success',
          ),
          
          // Green circular continue button (per success2.png design)
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00D4AA), // Green/teal color from design
            ),
            child: IconButton(
              onPressed: () => context.go('/episode3-placeholder'),
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startBreathingExercise() {
    // Move to next phase (inhale) and start animation
    ref.read(breathingControllerProvider.notifier).nextPhase();
    _animationController.start();
  }
}