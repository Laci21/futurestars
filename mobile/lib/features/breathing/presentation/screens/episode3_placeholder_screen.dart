import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/gradient_background.dart';
import '../widgets/oracle_avatar.dart';
import '../widgets/responsive_text.dart';
import '../widgets/episode_swipe_wrapper.dart';
import '../widgets/progress_line.dart';
import '../widgets/help_button.dart';

/// Placeholder screen for Episode 3
/// Matches the breathing exercise design language with Oracle and gradient background
class Episode3PlaceholderScreen extends StatelessWidget {
  const Episode3PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Main navigation and content
              EpisodeSwipeWrapper(
                showLeftButton: true,
                leftEpisodeNumber: 2,
                onSwipeLeft: null, // No left swipe allowed
                onSwipeRight: () => context.go('/breathing-exercise'), // Only right swipe works
                swipeHintText: 'Swipe right for Episode 2',
                child: Column(
                  children: [
                    // Episode progress lines at top
                    const BreathingProgressLine(activeEpisode: 3),
                    
                    // Main content
                    Expanded(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Minimal top spacer to match other screens text position
                          const SizedBox(height: 60),
                          // Oracle avatar with coming soon message
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // First row: Oracle avatar left, main message right
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const OracleAvatar(size: 50),
                            const SizedBox(width: 16),
                            
                            // Main coming soon message
                            Expanded(
                              child: Text(
                                'Coming Soon!',
                                style: ResponsiveTextStyles.heading.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Episode description centered below
                        Text(
                          'Episode 3: Mystic Mind Mastery',
                          textAlign: TextAlign.center,
                          style: ResponsiveTextStyles.heading.copyWith(
                            color: const Color(0xFFAEAFFC).withOpacity(0.8), // Same purple as "breathe"
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.24,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Description message
                        Text(
                          'Get ready for your next challenge.\nThe Oracle will guide you through new adventures.',
                          textAlign: TextAlign.center,
                          style: ResponsiveTextStyles.body.copyWith(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 48), // Increased spacing to match other screens
                    
                    // Placeholder icon - use a star or similar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFD700).withOpacity(0.2), // Golden background
                        border: Border.all(
                          color: const Color(0xFFFFD700),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 40,
                        color: Color(0xFFFFD700), // Gold to match progress line
                      ),
                    ),
                    
                          // Bottom spacer to match other screens
                          const Spacer(),
                          
                          const SizedBox(height: 40), // Bottom padding
                        ],
                      ),
                    ),
                  ),
                ),
                  ],
                ),
              ),
              
              // Help button in top-right corner (same position as Episode 2)
              const Positioned(
                top: 16,
                right: 16,
                child: HelpButton(contentType: HelpContentType.episode3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}