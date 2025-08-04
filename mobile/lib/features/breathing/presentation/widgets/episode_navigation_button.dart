import 'package:flutter/material.dart';

/// Reusable episode navigation button for consistent navigation between episodes
/// Matches the help button design but positioned for episode navigation
class EpisodeNavigationButton extends StatelessWidget {
  const EpisodeNavigationButton({
    super.key,
    required this.direction,
    required this.onTap,
    required this.episodeNumber,
  });

  final EpisodeNavigationDirection direction;
  final VoidCallback onTap;
  final int episodeNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Navigation button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1F2951).withOpacity(0.9), // Slightly more opaque for episode nav
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F1438).withOpacity(0.8),
                blurRadius: 16,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: Semantics(
                label: direction == EpisodeNavigationDirection.next 
                  ? 'Next episode button'
                  : 'Previous episode button',
                hint: direction == EpisodeNavigationDirection.next
                  ? 'Navigate to Episode $episodeNumber'
                  : 'Go back to Episode $episodeNumber',
                button: true,
                child: Center(
                  child: Icon(
                    direction == EpisodeNavigationDirection.next 
                      ? Icons.arrow_forward
                      : Icons.arrow_back,
                    color: const Color(0xFFFFD700), // Gold to match design
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Episode label
        Text(
          direction == EpisodeNavigationDirection.next 
            ? 'Episode $episodeNumber'
            : 'Episode $episodeNumber',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

enum EpisodeNavigationDirection {
  next,
  previous,
}