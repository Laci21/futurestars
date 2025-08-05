import 'package:flutter/material.dart';
import 'package:mobile/features/breathing/presentation/widgets/responsive_text.dart';
import 'package:mobile/features/breathing/presentation/widgets/help_button.dart';

/// Help overlay that displays breathing exercise instructions
/// Matches the design from help.png with white bubble and close button
class HelpOverlay extends StatelessWidget {
  const HelpOverlay({
    super.key,
    this.contentType = HelpContentType.episode2,
  });

  final HelpContentType contentType;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: _buildHelpBubble(context),
      ),
    );
  }

  Widget _buildHelpBubble(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Need Help?',
                  style: ResponsiveTextStyles.heading.copyWith(
                    color: const Color(0xFF1F2951),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Help content based on content type
                ..._buildHelpContent(),
              ],
            ),
          ),
          
          // Close button
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Semantics(
                label: 'Close help',
                hint: 'Close the help information dialog',
                button: true,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHelpContent() {
    switch (contentType) {
      case HelpContentType.episode2:
        return _buildEpisode2Content();
      case HelpContentType.episode3:
        return _buildEpisode3Content();
    }
  }

  List<Widget> _buildEpisode2Content() {
    return [
      // Help content
      Text(
        'This is a guided breathing exercise to help you feel calm and focused.',
        style: ResponsiveTextStyles.body.copyWith(
          color: const Color(0xFF1F2951),
          fontSize: 14,
          height: 1.4,
        ),
      ),
      
      const SizedBox(height: 12),
      
      // Bullet points
      ..._buildBulletPoints([
        'Tap "Start the Breath Exercise" to start',
        'Follow the Oracle\'s voice instructions',
        'Inhale for 5 seconds when prompted',
        'Hold your breath briefly',
        'Exhale for 5 seconds to complete',
        'The glowing bubble will guide your timing',
      ]),
      
      const SizedBox(height: 12),
      
      // Footer message
      Text(
        'Your breath is your superpower - use it to find strength and calm before your next challenge.',
        style: ResponsiveTextStyles.body.copyWith(
          color: const Color(0xFF6B73FF),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
      ),
    ];
  }

  List<Widget> _buildEpisode3Content() {
    return [
      // Minimal content - just like the first line of episode 2 help
      Text(
        'This is a guided breathing exercise to help you feel calm and focused.',
        style: ResponsiveTextStyles.body.copyWith(
          color: const Color(0xFF1F2951),
          fontSize: 14,
          height: 1.4,
        ),
      ),
    ];
  }

  List<Widget> _buildBulletPoints(List<String> points) {
    return points.map((point) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: ResponsiveTextStyles.body.copyWith(
              color: const Color(0xFF6B73FF),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              point,
              style: ResponsiveTextStyles.body.copyWith(
                color: const Color(0xFF1F2951),
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    )).toList();
  }

}