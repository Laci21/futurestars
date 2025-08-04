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
    _animationController.master.addListener(_onAnimationProgressChanged);
  }

  @override
  void dispose() {
    _animationController.master.removeStatusListener(_onAnimationStatusChanged);
    _animationController.master.removeListener(_onAnimationProgressChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onAnimationProgressChanged() {
    // Check if animation has reached success phase (0.8+ progress)
    final animationPhase = _animationController.getCurrentPhase();
    final currentStatePhase = ref.read(breathingControllerProvider).phase;
    
    // Transition to success when animation reaches success phase
    if (animationPhase == 'success' && currentStatePhase != BreathingPhase.success) {
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
    return Center(
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
            
            const SizedBox(height: 24), // Bottom spacing
          ],
        ),
      ),
    );
  }

  void _startBreathingExercise() {
    // Move to next phase (inhale) and start animation
    ref.read(breathingControllerProvider.notifier).nextPhase();
    _animationController.start();
  }
}