import 'package:flutter/material.dart';
import 'package:mobile/features/breathing/presentation/controller/breathing_animation_controller.dart';

/// The central breathing bubble that animates during the exercise
/// - Scales with breathing phases (grows on inhale, shrinks on exhale)
/// - Shows countdown numbers inside during timed phases
/// - Has glowing effect matching the designs exactly
class BreathingBubble extends StatelessWidget {
  const BreathingBubble({
    super.key,
    required this.animationController,
    required this.currentPhase,
    this.countdownValue,
  });

  final BreathingAnimationController animationController;
  final String currentPhase;
  final int? countdownValue;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController.master,
      builder: (context, child) {
        final bubbleScale = animationController.bubbleScale.value;
        final middleScale = animationController.middleCircleScale.value;
        final currentPhase = animationController.getCurrentPhase();
        final countdown = animationController.countdown.value;
        
        return Center(
          child: Semantics(
            label: _getAccessibilityLabel(currentPhase, countdown),
            hint: _getAccessibilityHint(currentPhase),
            liveRegion: true, // Announces changes automatically
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle behind everything
                Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1A1D4A).withOpacity(0.3), // Dark blue background circle
                  ),
                ),
                
                // Outer circles for all timed phases (inhale, hold, exhale)
                if (_shouldShowOuterCircles(currentPhase)) ..._buildOuterCircles(middleScale, currentPhase),
                
                // Main breathing bubble
                Transform.scale(
                  scale: bubbleScale,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: currentPhase == 'success' ? [
                          const Color(0xFFE8FFF8), // Light green center for success
                          const Color(0xFFB8FFE6), // Green-cyan
                          const Color(0xFF87CEBB), // Light green edge
                        ] : [
                          const Color(0xFFF0F8FF), // Very light cyan center
                          const Color(0xFFD1E7FF), // Light blue
                          const Color(0xFFADD8E6), // Light blue edge
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                      boxShadow: [
                        // Different glow color for success
                        BoxShadow(
                          color: currentPhase == 'success' 
                            ? const Color(0xFF00C853).withOpacity(0.4) // Green glow for success
                            : const Color(0xFF87CEEB).withOpacity(0.3), // Default blue glow
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Center(
                      child: _buildBubbleContent(currentPhase, countdown),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBubbleContent(String phase, int countdown) {
    // Special case for hold phase - show pause bars only (no text)
    if (phase == 'hold' && countdown == -1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF4A5FBB), // Blue/purple from design
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF4A5FBB), // Blue/purple from design
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      );
    }

    // Show countdown with phase label during timed phases
    if (countdown > 0 && _shouldShowCountdown(phase)) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getPhaseDisplayName(phase),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A5FBB), // Blue/purple from design
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4), // Closer spacing
          Text(
            countdown.toString(),
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5FBB), // Blue/purple from design
            ),
          ),
        ],
      );
    }

    // Show phase-specific icons for non-countdown phases
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _getPhaseIcon(phase),
          size: 60,
          color: phase == 'success' 
            ? const Color(0xFF00C853) // Green for success checkmark
            : const Color(0xFF1A1D29),
        ),
        const SizedBox(height: 8),
        Text(
          phase.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: phase == 'success' 
              ? const Color(0xFF00C853) // Green for success text
              : const Color(0xFF1A1D29),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  bool _shouldShowCountdown(String phase) {
    return phase == 'inhale' || phase == 'exhale';
  }

  IconData _getPhaseIcon(String phase) {
    switch (phase) {
      case 'intro':
        return Icons.self_improvement;
      case 'success':
        return Icons.check;
      default:
        return Icons.circle;
    }
  }

  /// Get proper case phase name for display
  String _getPhaseDisplayName(String phase) {
    switch (phase) {
      case 'inhale':
        return 'Inhale';
      case 'exhale':
        return 'Exhale';
      default:
        return phase;
    }
  }

  /// Check if outer circles should be shown
  bool _shouldShowOuterCircles(String phase) {
    return phase == 'inhale' || phase == 'hold' || phase == 'exhale';
  }

  /// Build outer circles for all timed phases - same static circles for all phases
  List<Widget> _buildOuterCircles(double baseScale, String phase) {
    return _buildStaticCircles(baseScale);
  }

  /// Build static concentric circles - only 2 circles with filled colors like design
  List<Widget> _buildStaticCircles(double baseScale) {
    return [
      // Outer circle - ALWAYS same size (never scales) - darker blue like design
      Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF2A3B8A).withOpacity(0.4), // Darker blue, more visible
        ),
      ),
      // Middle circle - scales with breathing - lighter blue like design
      Transform.scale(
        scale: baseScale,
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF4A5FBB).withOpacity(0.6), // More visible than before
          ),
        ),
      ),
    ];
  }

  /// Get accessibility label for screen readers
  /// Flutter Learning: Provide clear, descriptive labels for assistive technology
  String _getAccessibilityLabel(String phase, int countdown) {
    switch (phase) {
      case 'intro':
        return 'Breathing exercise starting. Prepare to begin.';
      case 'inhale':
        if (countdown > 0) {
          return 'Inhale phase. Breathe in slowly. $countdown seconds remaining.';
        }
        return 'Inhale phase. Breathe in slowly.';
      case 'hold':
        return 'Hold phase. Hold your breath gently.';
      case 'exhale':
        if (countdown > 0) {
          return 'Exhale phase. Breathe out slowly. $countdown seconds remaining.';
        }
        return 'Exhale phase. Breathe out slowly.';
      case 'success':
        return 'Breathing exercise completed successfully. Well done!';
      default:
        return 'Breathing exercise in progress.';
    }
  }

  /// Get accessibility hint for additional guidance
  /// Flutter Learning: Hints provide context about what will happen
  String _getAccessibilityHint(String phase) {
    switch (phase) {
      case 'intro':
        return 'Tap to start the breathing exercise';
      case 'inhale':
        return 'Follow the visual guide and breathe in slowly';
      case 'hold':
        return 'Hold your breath comfortably, do not strain';
      case 'exhale':
        return 'Release your breath slowly and completely';
      case 'success':
        return 'Exercise completed, tap to continue';
      default:
        return 'Follow the breathing instructions';
    }
  }
}