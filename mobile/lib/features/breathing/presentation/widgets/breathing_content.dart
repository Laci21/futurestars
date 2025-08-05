import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/breathing/presentation/controller/breathing_animation_controller.dart';
import 'package:mobile/features/breathing/presentation/controller/breathing_controller.dart';
import 'package:mobile/features/breathing/presentation/widgets/breathing_bubble.dart';
import 'package:mobile/features/breathing/presentation/widgets/oracle_avatar.dart';
import 'package:mobile/features/breathing/presentation/widgets/responsive_text.dart';
import 'package:mobile/features/breathing/presentation/widgets/sound_wave_widget.dart';
import 'package:mobile/features/breathing/presentation/styles/app_styles.dart';
import 'package:mobile/features/breathing/domain/breathing_phase.dart';

/// Breathing content widget for active breathing phases (inhale, hold, exhale)
/// Shows Oracle instructions, sound waves, and breathing bubble
class BreathingContent extends ConsumerWidget {
  final BreathingAnimationController animationController;

  const BreathingContent({
    super.key,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: AppStyles.maxContentWidth),
        padding: const EdgeInsets.symmetric(horizontal: AppStyles.standardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top spacer to move content more toward center
            const Spacer(),
            
            // Oracle avatar with instruction speech bubble
            AnimatedBuilder(
              animation: animationController.master,
              builder: (context, child) {
                // Use state phase so the correct instruction appears immediately
                final currentPhase = ref.read(breathingControllerProvider).phase.name;
                return _buildOracleInstructionBubble(currentPhase);
              },
            ),
            
            const SizedBox(height: AppStyles.largePadding), // Increased spacing between text and wave
            
            // Sound waves above the bubble (animated during breathing)
            AnimatedBuilder(
              animation: animationController.master,
              builder: (context, child) {
                return SoundWaveWidget(
                  isAnimating: _shouldShowSoundWaves(ref),
                );
              },
            ),
            
            const SizedBox(height: AppStyles.standardPadding),
            
            // Main breathing bubble - synced with animation controller
            AnimatedBuilder(
              animation: animationController.master,
              builder: (context, child) {
                final currentPhase = ref.read(breathingControllerProvider).phase.name;
                return BreathingBubble(
                  animationController: animationController,
                  currentPhase: currentPhase,
                );
              },
            ),
            
            // Bottom spacer
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildOracleInstructionBubble(String currentPhase) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const OracleAvatar(size: AppStyles.oracleAvatarSize),
        const SizedBox(width: AppStyles.smallPadding),
        
        Expanded(
          child: _buildPhaseInstruction(currentPhase),
        ),
      ],
    );
  }

  bool _shouldShowSoundWaves(WidgetRef ref) {
    final currentPhase = ref.read(breathingControllerProvider).phase;
    // Show sound waves during active breathing phases
    return currentPhase == BreathingPhase.inhale || 
           currentPhase == BreathingPhase.exhale ||
           currentPhase == BreathingPhase.hold;
  }

  Widget _buildPhaseInstruction(String currentPhase) {
    switch (currentPhase) {
      case 'inhale':
        return ResponsiveTextWidgets.subheading('Inhale slowly for 5 seconds and fill your lungs');
      case 'hold':
        return ResponsiveTextWidgets.subheading('Hold in the breath for a while...');
      case 'exhale':
        return ResponsiveTextWidgets.subheading('Exhale slowly for 5 seconds and empty your lungs');
      default:
        return ResponsiveTextWidgets.subheading('Follow the breathing rhythm');
    }
  }
}