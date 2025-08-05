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
import '../widgets/responsive_text.dart';
import '../widgets/help_button.dart';
import '../widgets/episode_swipe_wrapper.dart';
import '../../domain/breathing_phase.dart';
import '../../../../shared/providers/audio_provider.dart';

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
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                          // Oracle avatar with text layout per design - avatar only left to first line
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First row: Oracle avatar left, only first line of text right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                    const OracleAvatar(size: 50),
                    const SizedBox(width: 16),
                    
                    // Only first line with "breathe" highlight
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: ResponsiveTextStyles.heading.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.24,
                            ),
                            children: [
                              const TextSpan(text: 'Take a moment to '),
                              TextSpan(
                                text: 'breathe',
                                style: ResponsiveTextStyles.heading.copyWith(
                                  color: const Color(0xFFAEAFFC).withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              const TextSpan(text: ','),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Second line below avatar (centered)
                  Text(
                    'transform each inhale into power',
                    textAlign: TextAlign.center,
                    style: ResponsiveTextStyles.heading.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.24,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subtitle below everything
                  ResponsiveTextWidgets.introSubtitle(),
                ],
              ),
            
            const Spacer(), // Flexible space before CTA
            
            // CTA section with label and circular button (matching design)
            Column(
              children: [
                // CTA label above button
                Text(
                  'Start the Breath Exercise',
                  style: ResponsiveTextStyles.ctaLabel,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Circular button with arrow (matching design)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1F2951), // Darker navy to match design precisely
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F1438).withOpacity(0.8),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _startBreathingExercise,
                      borderRadius: BorderRadius.circular(28),
                      child: Semantics(
                        label: 'Start the breath exercise',
                        hint: 'Start the guided breathing exercise with Oracle instructions',
                        button: true,
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFFFD700), // Bright gold to match progress line
                            size: 24, // 24px as per design
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 56), // Bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingContent() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Oracle avatar with instruction speech bubble (per design)
            AnimatedBuilder(
              animation: _animationController.master,
              builder: (context, child) {
                // Use state phase so the correct instruction appears immediately
                final currentPhase = ref.read(breathingControllerProvider).phase.name;
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
                  color: const Color(0xFF87CEEB).withOpacity(0.4), // Blue tint as per inhale.png
                );
              },
            ),
            
            const SizedBox(height: 24), // Space between sound waves and bubble
            
            // Animated breathing bubble (handles all phases automatically)
            BreathingBubble(
              animationController: _animationController,
              currentPhase: _animationController.getCurrentPhase(),
            ),
            
            // Add flexible space to push helper text to bottom
            const Spacer(),
            
                          // Helper text at bottom of screen
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(
                  'Follow the breathing instructions',
                  textAlign: TextAlign.center,
                  style: ResponsiveTextStyles.body.copyWith(
                    color: Colors.white.withOpacity(0.35), // Same opacity as episode label
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build Oracle avatar with instruction speech bubble for breathing phases
  Widget _buildOracleInstructionBubble(String phase) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Oracle avatar on the left
        const OracleAvatar(size: 50),
        const SizedBox(width: 16),
        
        // Instruction text on the right with colored words
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8), // Align with avatar
            child: _buildColoredInstruction(phase),
          ),
        ),
      ],
    );
  }

  /// Build instruction text with colored keywords
  Widget _buildColoredInstruction(String phase) {
    const lavenderColor = Color(0xFFAEAFFC); // Same as "breathe" highlight
    
    switch (phase) {
      case 'inhale':
        return RichText(
          text: TextSpan(
            style: ResponsiveTextStyles.subheading,
            children: [
              TextSpan(
                text: 'Inhale',
                style: ResponsiveTextStyles.subheading.copyWith(
                  color: lavenderColor, // Same lavender as "breathe"
                ),
              ),
              const TextSpan(text: ' slowly for '),
              TextSpan(
                text: '5 seconds',
                style: ResponsiveTextStyles.subheading.copyWith(
                  color: lavenderColor, // Same lavender as "breathe"
                ),
              ),
              const TextSpan(text: ' and fill your lungs'),
            ],
          ),
        );
      case 'hold':
        return RichText(
          text: TextSpan(
            style: ResponsiveTextStyles.subheading,
            children: [
              TextSpan(
                text: 'Hold in',
                style: ResponsiveTextStyles.subheading.copyWith(
                  color: lavenderColor, // Same lavender as "breathe"
                ),
              ),
              const TextSpan(text: ' the breath for a while...'),
            ],
          ),
        );
      case 'exhale':
        return RichText(
          text: TextSpan(
            style: ResponsiveTextStyles.subheading,
            children: [
              TextSpan(
                text: 'Exhale',
                style: ResponsiveTextStyles.subheading.copyWith(
                  color: lavenderColor, // Same lavender as "breathe"
                ),
              ),
              const TextSpan(text: ' slowly for '),
              TextSpan(
                text: '5 seconds',
                style: ResponsiveTextStyles.subheading.copyWith(
                  color: lavenderColor, // Same lavender as "breathe"
                ),
              ),
              const TextSpan(text: ' and empty your lungs'),
            ],
          ),
        );
      default:
        return Text(
          'Follow the breathing instructions',
          style: ResponsiveTextStyles.subheading,
        );
    }
  }

  Widget _buildSuccessContent() {
    return EpisodeSwipeWrapper(
      showRightButton: true,
      rightEpisodeNumber: 3,
      onSwipeLeft: () => context.go('/episode3-placeholder'), // Only left swipe works
      onSwipeRight: null, // No right swipe allowed
      swipeHintText: 'Swipe left for Episode 3',
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40), // Top spacing to match other screens
              // Oracle avatar with success message (per success1.png and success2.png)
              Column(
                children: [
                  // First row: Oracle avatar left, "Fantastic job!" right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const OracleAvatar(size: 50),
                      const SizedBox(width: 16),
                      
                      // Only first line next to avatar
                      Expanded(
                        child: Text(
                          'Fantastic job!',
                          style: ResponsiveTextStyles.heading,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rest of text below avatar (centered)
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: ResponsiveTextStyles.body,
                      children: [
                        TextSpan(
                          text: 'Your breath is your superpower',
                          style: ResponsiveTextStyles.body.copyWith(
                            color: const Color(0xFFAEAFFC).withOpacity(0.8), // Same purple as "breathe"
                          ),
                        ),
                        const TextSpan(text: ',\noffering strength and calm.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Trust it to guide you and\nempower your journey ahead.',
                    textAlign: TextAlign.center,
                    style: ResponsiveTextStyles.body,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Success green icon (hand gesture like design)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00D968), // Bright vibrant green to match design
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D968).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.thumb_up,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 160), // Extra bottom spacing for episode navigation
            ],
          ),
        ),
      ),
    );
  }

  void _startBreathingExercise() {
    // Always stop intro voiceover immediately and start breathing sequence
    final controller = ref.read(breathingControllerProvider.notifier);
    
    // Stop intro voiceover immediately
    controller.stopCurrentVoiceover();
    
    // Start the breathing sequence (move to inhale phase)
    controller.nextPhase();
    
    _animationController.start();
  }
  
  /// Handle app lifecycle changes for audio management
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
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