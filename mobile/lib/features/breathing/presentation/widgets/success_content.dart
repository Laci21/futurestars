import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/breathing/presentation/widgets/oracle_avatar.dart';
import 'package:mobile/features/breathing/presentation/widgets/responsive_text.dart';
import 'package:mobile/features/breathing/presentation/widgets/episode_navigation_button.dart';
import 'package:mobile/features/breathing/presentation/styles/app_styles.dart';

/// Success content widget for completion of breathing exercise
/// Shows celebration message and navigation to next episode
class SuccessContent extends StatelessWidget {
  const SuccessContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: AppStyles.maxContentWidth),
        padding: const EdgeInsets.symmetric(horizontal: AppStyles.standardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top spacer
            const Spacer(),
            
            // Oracle success message
            _buildSuccessMessage(),
            
            const SizedBox(height: AppStyles.largePadding),
            
            // Success celebration text
            ResponsiveTextWidgets.heading('Fantastic job! Your breath is your superpower, offering strength and calm.'),
            
            // Bottom spacer before navigation
            const Spacer(flex: 2),
            
            // Navigation to Episode 3
            _buildNavigationButton(context),
            
            const SizedBox(height: AppStyles.buttonHeight), // Bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OracleAvatar(size: AppStyles.oracleAvatarSize),
        SizedBox(width: AppStyles.smallPadding),
        
        Expanded(
          child: Text(
            'Fantastic job! Your breath is your superpower, offering strength and calm.',
            style: AppStyles.headingStyle,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButton(BuildContext context) {
    return EpisodeNavigationButton(
      direction: EpisodeNavigationDirection.next,
      episodeNumber: 3,
      onTap: () => context.push('/episode3-placeholder'),
    );
  }
}