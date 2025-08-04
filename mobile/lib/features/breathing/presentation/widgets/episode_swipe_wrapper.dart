import 'package:flutter/material.dart';
import 'episode_navigation_button.dart';

/// Wrapper widget that adds swipe gesture detection and episode navigation buttons
/// to screens that support episode navigation
class EpisodeSwipeWrapper extends StatelessWidget {
  const EpisodeSwipeWrapper({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.showLeftButton = false,
    this.showRightButton = false,
    this.leftEpisodeNumber,
    this.rightEpisodeNumber,
    this.swipeHintText,
  });

  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final bool showLeftButton;
  final bool showRightButton;
  final int? leftEpisodeNumber;
  final int? rightEpisodeNumber;
  final String? swipeHintText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // Allow gestures to pass through
      onHorizontalDragEnd: (details) {
        // Lower sensitivity for better gesture detection
        const sensitivity = 30.0;
        final velocity = details.velocity.pixelsPerSecond.dx;
        
        // Swipe right (positive velocity) should call onSwipeRight
        // Swipe left (negative velocity) should call onSwipeLeft
        if (velocity > sensitivity && onSwipeRight != null) {
          onSwipeRight!.call();
        } else if (velocity < -sensitivity && onSwipeLeft != null) {
          onSwipeLeft!.call();
        }
      },
      child: Stack(
        children: [
          // Main content
          child,
          
          // Left navigation button - bottom left corner
          if (showLeftButton && leftEpisodeNumber != null)
            Positioned(
              left: 16,
              bottom: 40, // Bottom left corner
              child: EpisodeNavigationButton(
                direction: EpisodeNavigationDirection.previous,
                onTap: onSwipeRight ?? onSwipeLeft ?? () {}, // Left button uses right swipe destination
                episodeNumber: leftEpisodeNumber!,
              ),
            ),
          
          // Right navigation button - bottom right corner
          if (showRightButton && rightEpisodeNumber != null)
            Positioned(
              right: 16,
              bottom: 40, // Bottom right corner
              child: EpisodeNavigationButton(
                direction: EpisodeNavigationDirection.next,
                onTap: onSwipeLeft ?? onSwipeRight ?? () {}, // Right button uses left swipe destination
                episodeNumber: rightEpisodeNumber!,
              ),
            ),
          
          // Swipe hint text - bottom center between navigation buttons
          if (swipeHintText != null)
            Positioned(
              bottom: 16, // Bottom center, below navigation buttons
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  swipeHintText!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35), // Same opacity as breathing instructions
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}