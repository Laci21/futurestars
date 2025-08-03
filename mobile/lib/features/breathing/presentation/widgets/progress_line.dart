import 'package:flutter/material.dart';

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
            
            // Dashed episode progress lines matching design exactly
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Episode 1 - completed (white dashed)
                _buildDashedLine(isActive: false, isCompleted: true),
                const SizedBox(width: 6),
                
                // Episode 2 - current/active (yellow dashed) 
                _buildDashedLine(isActive: true, isCompleted: false),
                const SizedBox(width: 6),
                
                // Episode 3 - future (gray dashed)
                _buildDashedLine(isActive: false, isCompleted: false),
                const SizedBox(width: 6),
                
                // Episode 4 - future (gray dashed)
                _buildDashedLine(isActive: false, isCompleted: false),
                const SizedBox(width: 6),
                
                // Episode 5 - future (gray dashed)
                _buildDashedLine(isActive: false, isCompleted: false),
              ],
            ),
            
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDashedLine({required bool isActive, required bool isCompleted}) {
    Color color;
    if (isActive) {
      color = const Color(0xFFFFD700); // Gold for current episode
    } else if (isCompleted) {
      color = Colors.white.withOpacity(0.8); // White for completed
    } else {
      color = Colors.white.withOpacity(0.3); // Dim for future episodes
    }

    return Container(
      width: 40, // Shorter lines like in design
      height: 2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
        boxShadow: isActive ? [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ] : null,
      ),
    );
  }
}