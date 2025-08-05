import 'package:flutter/material.dart';
import 'package:mobile/features/breathing/presentation/widgets/help_overlay.dart';

/// Content type for help overlay
enum HelpContentType {
  episode2,
  episode3,
}

/// Help button that appears in top-right corner of breathing screens
/// Matches the existing design system with circular button and soft shadow
class HelpButton extends StatelessWidget {
  const HelpButton({
    super.key,
    this.contentType = HelpContentType.episode2,
  });

  final HelpContentType contentType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1F2951).withOpacity(0.8), // Semi-transparent navy
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F1438).withOpacity(0.6),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showHelpOverlay(context),
          borderRadius: BorderRadius.circular(20),
          child: Semantics(
            label: 'Help button',
            hint: 'Opens help information about the breathing exercise',
            button: true,
            child: const Center(
              child: Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Show the help overlay matching the design
  void _showHelpOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3), // Subtle overlay
      builder: (context) => HelpOverlay(contentType: contentType),
    );
  }
}