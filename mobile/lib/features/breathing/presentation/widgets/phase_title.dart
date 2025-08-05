import 'package:flutter/material.dart';
import 'package:mobile/features/breathing/presentation/widgets/responsive_text.dart';
import 'package:mobile/features/breathing/domain/breathing_phase.dart';

/// Clean phase title display widget for breathing exercise screens
/// Shows the current phase with proper styling and responsive layout
/// 
/// Flutter Learning Notes:
/// - Enum handling: Converting enum values to user-friendly strings
/// - Conditional rendering: Showing different content based on phase
/// - Widget composition: Combining multiple simple widgets into complex UI
/// - Animation integration: Smooth transitions between phase titles
class PhaseTitle extends StatelessWidget {
  const PhaseTitle({
    super.key,
    required this.phase,
    this.subtitle,
    this.showPhasePrefix = true,
    this.animated = true,
  });

  /// Current breathing phase to display
  final BreathingPhase phase;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// Whether to show "Phase:" prefix
  final bool showPhasePrefix;
  
  /// Whether to animate title changes
  final bool animated;

  @override
  Widget build(BuildContext context) {
    if (animated) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _buildTitleContent(context),
      );
    } else {
      return _buildTitleContent(context);
    }
  }

  /// Build the main title content
  /// Flutter Learning: Extract complex widget building into separate methods
  Widget _buildTitleContent(BuildContext context) {
    return Padding(
      padding: context.responsivePadding,
      child: Column(
        key: ValueKey(phase), // Important for AnimatedSwitcher
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main phase title
          _buildMainTitle(context),
          
          // Subtitle if provided
          if (subtitle != null) ...[
            SizedBox(height: context.responsiveSpacing * 0.5),
            _buildSubtitle(context),
          ],
        ],
      ),
    );
  }

  /// Build the main title based on the current phase
  Widget _buildMainTitle(BuildContext context) {
    final titleText = _getTitleForPhase(phase);
    
    return ResponsiveTextWidgets.heading(
      titleText,
      textAlign: TextAlign.center,
    );
  }

  /// Build the subtitle text
  Widget _buildSubtitle(BuildContext context) {
    return ResponsiveTextWidgets.subheading(
      subtitle!,
      textAlign: TextAlign.center,
    );
  }

  /// Get the appropriate title text for each phase
  /// Flutter Learning: Switch statements with enums are type-safe
  String _getTitleForPhase(BreathingPhase phase) {
    final prefix = showPhasePrefix ? 'Phase: ' : '';
    
    switch (phase) {
      case BreathingPhase.intro:
        return '${prefix}Welcome';
      case BreathingPhase.inhale:
        return '${prefix}Inhale';
      case BreathingPhase.hold:
        return '${prefix}Hold';
      case BreathingPhase.exhale:
        return '${prefix}Exhale';
      case BreathingPhase.success:
        return '${prefix}Complete';
    }
  }
}

/// Specialized phase instruction widget for breathing exercises
/// Shows phase-specific instructions with Oracle guidance
/// 
/// Flutter Learning: Create specialized widgets for specific use cases
class PhaseInstructionTitle extends StatelessWidget {
  const PhaseInstructionTitle({
    super.key,
    required this.phase,
    this.showOracle = true,
  });

  final BreathingPhase phase;
  final bool showOracle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.responsivePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Oracle avatar (if enabled)
          if (showOracle) ...[
            // Note: Oracle avatar will be added to the screen layout directly
            SizedBox(height: context.responsiveSpacing),
          ],
          
          // Phase instruction text
          ResponsiveTextWidgets.subheading(
            _getInstructionForPhase(phase),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Get Oracle's instruction for each phase
  /// Flutter Learning: Centralize text content for easy maintenance
  String _getInstructionForPhase(BreathingPhase phase) {
    switch (phase) {
      case BreathingPhase.intro:
        return 'Take some moment to breathe, transform each inhale into power';
      case BreathingPhase.inhale:
        return 'Inhale slowly for 5 seconds and fill your lungs';
      case BreathingPhase.hold:
        return 'Hold in the breath for a while...';
      case BreathingPhase.exhale:
        return 'Exhale slowly for 5 seconds and empty your lungs';
      case BreathingPhase.success:
        return 'Fantastic job! Your breath is your superpower, offering strength and calm.';
    }
  }
}

/// Compact phase indicator for minimal spaces
/// Flutter Learning: Create lightweight versions for different contexts
class CompactPhaseIndicator extends StatelessWidget {
  const CompactPhaseIndicator({
    super.key,
    required this.phase,
    this.color,
  });

  final BreathingPhase phase;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? Colors.white).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (color ?? Colors.white).withOpacity(0.3),
        ),
      ),
      child: ResponsiveText(
        phase.displayName.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.white,
          letterSpacing: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Phase progress indicator showing current step in the sequence
/// Flutter Learning: Visual progress indicators improve user experience
class PhaseProgressIndicator extends StatelessWidget {
  const PhaseProgressIndicator({
    super.key,
    required this.currentPhase,
    this.showLabels = false,
  });

  final BreathingPhase currentPhase;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    const phases = BreathingPhase.values;
    final currentIndex = phases.indexOf(currentPhase);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: phases.asMap().entries.map((entry) {
        final index = entry.key;
        final phase = entry.value;
        final isActive = index == currentIndex;
        final isCompleted = index < currentIndex;

        return _buildPhaseStep(
          context,
          phase,
          isActive: isActive,
          isCompleted: isCompleted,
          isLast: index == phases.length - 1,
        );
      }).toList(),
    );
  }

  Widget _buildPhaseStep(
    BuildContext context,
    BreathingPhase phase, {
    required bool isActive,
    required bool isCompleted,
    required bool isLast,
  }) {
    Color dotColor;
    if (isActive) {
      dotColor = const Color(0xFFFFD700); // Gold for active
    } else if (isCompleted) {
      dotColor = Colors.white; // White for completed
    } else {
      dotColor = Colors.white.withOpacity(0.3); // Dim for future
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Phase dot
        Container(
          width: isActive ? 12 : 8,
          height: isActive ? 12 : 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            boxShadow: isActive ? [
              BoxShadow(
                color: dotColor.withOpacity(0.4),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ] : null,
          ),
        ),
        
        // Phase label (if enabled)
        if (showLabels) ...[
          const SizedBox(width: 4),
          ResponsiveText(
            phase.displayName,
            style: TextStyle(
              fontSize: 10,
              color: dotColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
        
        // Connector line (except for last item)
        if (!isLast) ...[
          const SizedBox(width: 8),
          Container(
            width: 20,
            height: 1,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}
