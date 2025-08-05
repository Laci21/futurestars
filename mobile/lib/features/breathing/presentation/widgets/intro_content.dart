import 'package:flutter/material.dart';
import 'package:mobile/features/breathing/presentation/widgets/oracle_avatar.dart';
import 'package:mobile/features/breathing/presentation/widgets/responsive_text.dart';
import 'package:mobile/features/breathing/presentation/styles/app_styles.dart';

/// Intro content widget for the breathing exercise
/// Displays Oracle introduction and start button
class IntroContent extends StatelessWidget {
  final VoidCallback onStartExercise;

  const IntroContent({
    super.key,
    required this.onStartExercise,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: AppStyles.maxContentWidth),
        padding: const EdgeInsets.symmetric(horizontal: AppStyles.standardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Minimal top spacer to match breathing screens text position
            const SizedBox(height: 60),
            
            // Oracle avatar with text layout per design
            _buildOracleMessage(),
            
            // Flexible space before CTA to align with breathing screens
            const Spacer(),
            
            // CTA section with label and circular button
            _buildStartButton(),
            
            const SizedBox(height: 56), // Bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildOracleMessage() {
    return Column(
      children: [
        // First row: Oracle avatar left, only first line of text right
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const OracleAvatar(size: AppStyles.oracleAvatarSize),
            const SizedBox(width: AppStyles.smallPadding),
            
            // Only first line with "breathe" highlight
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppStyles.headingStyle,
                  children: [
                    const TextSpan(text: 'Take a moment to '),
                    TextSpan(
                      text: 'breathe',
                      style: AppStyles.headingStyle.copyWith(
                        color: AppStyles.lightPurple.withOpacity(AppStyles.highOpacity),
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
        const Text(
          'transform each inhale into power',
          textAlign: TextAlign.center,
          style: AppStyles.headingStyle,
        ),
        
        const SizedBox(height: AppStyles.smallPadding),
        
        // Subtitle below everything
        ResponsiveTextWidgets.introSubtitle(),
      ],
    );
  }

  Widget _buildStartButton() {
    return Column(
      children: [
        // CTA label above button
        const Text(
          'Start the Breath Exercise',
          style: AppStyles.ctaLabelStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppStyles.smallPadding),
        
        // Circular button with arrow (matching design)
        Container(
          width: AppStyles.buttonHeight,
          height: AppStyles.buttonHeight,
          decoration: AppStyles.circularButtonDecoration,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onStartExercise,
              borderRadius: BorderRadius.circular(AppStyles.buttonRadius),
              child: Semantics(
                label: 'Start the breath exercise',
                hint: 'Start the guided breathing exercise with Oracle instructions',
                button: true,
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppStyles.lightGold,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}