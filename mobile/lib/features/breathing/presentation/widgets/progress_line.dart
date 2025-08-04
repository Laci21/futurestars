import 'package:flutter/material.dart';
import 'responsive_text.dart';

/// Episode progress lines exactly matching the design
/// Shows dashed lines with specified episode as active yellow line
class BreathingProgressLine extends StatelessWidget {
  const BreathingProgressLine({
    super.key,
    this.activeEpisode = 2,
  });

  final int activeEpisode;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 16),
            
                          // 15 dashed episode progress lines (as per design)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Generate all 15 episodes dynamically
                  for (int i = 1; i <= 15; i++) ...[
                    _buildDashedLine(
                      isActive: i == activeEpisode,
                      isCompleted: i < activeEpisode,
                    ),
                    if (i < 15) const SizedBox(width: 2),
                  ],
                ],
              ),
            
            const SizedBox(height: 12),
            
            // Episode label matching design
            Text(
              _getEpisodeLabel(),
              style: ResponsiveTextStyles.episodeLabel,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32), // Increased spacing for better vertical rhythm
          ],
        ),
      ),
    );
  }

  Widget _buildDashedLine({required bool isActive, required bool isCompleted}) {
    Color color;
    if (isActive) {
      color = const Color(0xFFFFD700); // Bright gold to match design exactly
    } else if (isCompleted) {
      color = Colors.white.withOpacity(0.9); // Brighter white for completed
    } else {
      color = Colors.white.withOpacity(0.25); // More subtle for future episodes
    }

    return Container(
      width: 16, // Smaller to prevent overflow on iPhone mini
      height: 2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
        boxShadow: isActive ? [
          BoxShadow(
            color: const Color(0xFFFFD54F).withOpacity(0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ] : null,
      ),
    );
  }

  /// Get the episode label based on the active episode
  String _getEpisodeLabel() {
    switch (activeEpisode) {
      case 2:
        return 'E2: Shadow Swagger Showdown';
      case 3:
        return 'E3: Mystic Mind Mastery';
      default:
        return 'E$activeEpisode: Coming Soon';
    }
  }
}