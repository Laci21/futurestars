import 'package:flutter/material.dart';
import 'responsive_text.dart';

/// Episode progress lines exactly matching the design
/// Shows dashed lines with Episode 2 (breathing exercise) as active yellow line
class BreathingProgressLine extends StatelessWidget {
  const BreathingProgressLine();

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
                  // Episode 1 - should be grey like others (not white)
                  _buildDashedLine(isActive: false, isCompleted: false),
                  const SizedBox(width: 2),
                  
                  // Episode 2 - current/active (yellow dashed) 
                  _buildDashedLine(isActive: true, isCompleted: false),
                  const SizedBox(width: 2),
                  
                  // Episodes 3-15 - future (gray dashed) - 15 total as per design
                  for (int i = 3; i <= 15; i++) ...[
                    _buildDashedLine(isActive: false, isCompleted: false),
                    if (i < 15) const SizedBox(width: 2),
                  ],
                ],
              ),
            
            const SizedBox(height: 12),
            
            // Episode label matching design
            Text(
              'E2: Shadow Swagger Showdown',
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
}