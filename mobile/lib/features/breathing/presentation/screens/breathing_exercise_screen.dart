import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/breathing/presentation/controller/breathing_controller.dart';
import 'package:mobile/features/breathing/presentation/controller/breathing_animation_controller.dart';
import 'package:mobile/features/breathing/presentation/widgets/progress_line.dart';
import 'package:mobile/features/breathing/presentation/widgets/gradient_background.dart';
import 'package:mobile/features/breathing/presentation/widgets/help_button.dart';
import 'package:mobile/features/breathing/presentation/widgets/intro_content.dart';
import 'package:mobile/features/breathing/presentation/widgets/breathing_content.dart';
import 'package:mobile/features/breathing/presentation/widgets/success_content.dart';
import 'package:mobile/features/breathing/domain/breathing_phase.dart';
import 'package:mobile/shared/providers/audio_provider.dart';

/// Single screen for the entire breathing exercise experience
/// Content changes dynamically based on the current breathing phase
class BreathingExerciseScreen extends ConsumerStatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  ConsumerState<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends ConsumerState<BreathingExerciseScreen> 
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late BreathingAnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = BreathingAnimationController(vsync: this);
    
    // Listen for animation completion to handle auto-progression
    _animationController.master.addStatusListener(_onAnimationStatusChanged);
    _animationController.master.addListener(_onAnimationProgressChanged);
    
    // Register for app lifecycle changes to handle audio interruptions
    WidgetsBinding.instance.addObserver(this);
    
    // Auto-initialize audio and play intro voiceover when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(breathingControllerProvider.notifier).initializeAudio();
    });
  }

  @override
  void dispose() {
    // Remove lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    
    // Clean up animation listeners
    _animationController.master.removeStatusListener(_onAnimationStatusChanged);
    _animationController.master.removeListener(_onAnimationProgressChanged);
    _animationController.dispose();
    
    super.dispose();
  }

  void _onAnimationProgressChanged() {
    final animationPhase = _animationController.getCurrentPhase();
    final currentStatePhase = ref.read(breathingControllerProvider).phase;
    
    // Auto-progress through breathing phases based on animation timing
    // But skip intro phase - that should be user-controlled
    if (currentStatePhase == BreathingPhase.intro) {
      // Don't auto-progress from intro - wait for user interaction
      return;
    }
    
    // Sync animation phases with state phases
    final shouldTransition = switch (animationPhase) {
      'inhale' when currentStatePhase == BreathingPhase.intro => true,
      'hold' when currentStatePhase == BreathingPhase.inhale => true,
      'exhale' when currentStatePhase == BreathingPhase.hold => true,
      'success' when currentStatePhase == BreathingPhase.exhale => true,
      _ => false,
    };
    
    if (shouldTransition) {
      ref.read(breathingControllerProvider.notifier).nextPhase();
    }
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Ensure we're in success phase when animation completes
      final currentStatePhase = ref.read(breathingControllerProvider).phase;
      if (currentStatePhase != BreathingPhase.success) {
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
          child: Stack(
            children: [
              // Main content
              Column(
                children: [
                  // Episode progress lines at top - static throughout
                  const BreathingProgressLine(),
                  
                  // Dynamic content based on current phase
                  Expanded(
                    child: _buildPhaseContent(breathingState.phase),
                  ),
                ],
              ),
              
              // Help button in top-right corner
              const Positioned(
                top: 16,
                right: 16,
                child: HelpButton(),
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
        return IntroContent(onStartExercise: _startBreathingExercise);
      case BreathingPhase.inhale:
      case BreathingPhase.hold:
      case BreathingPhase.exhale:
        return BreathingContent(animationController: _animationController);
      case BreathingPhase.success:
        return const SuccessContent();
    }
  }

  void _startBreathingExercise() {
    // Always stop intro voiceover immediately and start breathing sequence
    final controller = ref.read(breathingControllerProvider.notifier);
    
    // Stop any current voiceover before starting the exercise
    controller.stopCurrentVoiceover();
    
    // Move to inhale phase and start the master animation
    controller.nextPhase();
    _animationController.start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Get audio service through the provider
    final audioService = ref.read(audioServiceProvider);
    
    switch (state) {
      case AppLifecycleState.paused:
        // App went to background - pause audio
        audioService.pauseAll();
        _animationController.pause();
        break;
      case AppLifecycleState.resumed:
        // App came back to foreground - resume audio if we're in an active phase
        final currentPhase = ref.read(breathingControllerProvider).phase;
        if (currentPhase != BreathingPhase.intro && currentPhase != BreathingPhase.success) {
          audioService.resumeAll();
          _animationController.resume();
        }
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // Handle other states if needed
        break;
    }
  }
}