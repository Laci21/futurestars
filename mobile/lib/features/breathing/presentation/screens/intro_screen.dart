import 'package:flutter/material.dart';
import 'package:mobile/features/breathing/presentation/widgets/gradient_background.dart';
import 'package:mobile/features/breathing/presentation/widgets/oracle_avatar.dart';

import 'package:mobile/features/breathing/presentation/widgets/progress_line.dart';
import 'package:mobile/features/breathing/presentation/widgets/responsive_text.dart';
import 'package:mobile/shared/services/image_cache_service.dart';

/// Intro screen for the breathing exercise
/// Shows Oracle's welcome message and start button
/// 
/// Flutter Learning Notes:
/// - StatefulWidget: For widgets that need to manage state
/// - initState(): Called once when widget is first created
/// - Image pre-caching: Load images before they're needed
/// - Widget composition: Building complex UI from simple components
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> 
    with ImageCacheMixin, TickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  /// Initialize screen with image pre-caching
  /// Flutter Learning: Separate initialization logic for clarity
  Future<void> _initializeScreen() async {
    // Pre-cache images for smooth performance
    await _precacheScreenImages();
  }

  /// Pre-cache all images used in this screen
  /// Flutter Learning: Pre-cache images in initState for best performance
  Future<void> _precacheScreenImages() async {
    try {
      // Pre-cache breathing exercise images
      await context.imageCacheService.precacheBreathingImages(context);
      
      // If this screen had specific images, we would cache them here:
      // await precacheImagesForWidget(context, [
      //   'assets/images/intro_background.png',
      //   'assets/images/start_button.png',
      // ]);
      
    } catch (e) {
      // Image caching failures shouldn't break the screen
      debugPrint('Failed to pre-cache intro screen images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Episode progress indicator at top
              const BreathingProgressLine(),
              
              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400), // Max width for centering on wide screens
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      // Oracle avatar with proper sizing
                      const OracleAvatar(size: 50),
                      
                      const SizedBox(height: 24), // 24px gap as per design
                      
                      // Welcome text with lavender highlight on "breathe"
                      ResponsiveTextWidgets.introHeading(),
                      
                      const SizedBox(height: 32), // 32px gap as per design
                      
                      // Subtitle with proper line breaks
                      ResponsiveTextWidgets.introSubtitle(),
                      
                      const Spacer(), // Flexible space before CTA
                      
                      // CTA section with label and circular button
                      Column(
                        children: [
                          // CTA label above button
                          Text(
                            'Start the Breath Exercise',
                            style: ResponsiveTextStyles.ctaLabel,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          
                          // Circular button with arrow (larger for better touch target)
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF1A1D4A), // Navy background
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1A1D4A).withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _startBreathingExercise,
                                borderRadius: BorderRadius.circular(28),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFFFFD54F), // Yellow arrow
                                    size: 24, // 24px as per design
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 56), // Bottom inset as per design
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Start the breathing exercise
  void _startBreathingExercise() {
    // Navigate to the breathing exercise flow
    // This will be implemented when navigation is set up
    debugPrint('Starting breathing exercise...');
  }
}

/// Example of a breathing phase screen with image pre-caching
/// Flutter Learning: Consistent patterns across similar screens
class BreathingPhaseScreen extends StatefulWidget {
  const BreathingPhaseScreen({
    super.key,
    required this.phaseName,
  });

  final String phaseName;

  @override
  State<BreathingPhaseScreen> createState() => _BreathingPhaseScreenState();
}

class _BreathingPhaseScreenState extends State<BreathingPhaseScreen>
    with ImageCacheMixin, TickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
    _precachePhaseImages();
  }

  /// Pre-cache images specific to this breathing phase
  Future<void> _precachePhaseImages() async {
    await context.imageCacheService.precacheBreathingImages(context);
    
    // Phase-specific images (if any)
    // await precacheImagesForWidget(context, [
    //   'assets/images/${widget.phaseName}_background.png',
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              const BreathingProgressLine(),
              
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Oracle avatar
                    const OracleAvatar(),
                    
                    SizedBox(height: context.responsiveSpacing),
                    
                    // Phase instruction
                    ResponsiveTextWidgets.subheading(
                      _getPhaseInstruction(),
                    ),
                    
                    SizedBox(height: context.responsiveSpacing * 2),
                    
                    // Sound waves (when implementing)
                    // const SoundWaveWidget(),
                    
                    SizedBox(height: context.responsiveSpacing * 2),
                    
                    // Breathing bubble (when implementing)
                    // BreathingBubble(...),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPhaseInstruction() {
    switch (widget.phaseName) {
      case 'inhale':
        return 'Inhale slowly for 5 seconds and fill your lungs';
      case 'hold':
        return 'Hold in the breath for a while...';
      case 'exhale':
        return 'Exhale slowly for 5 seconds and empty your lungs';
      default:
        return 'Follow the breathing instructions';
    }
  }
}
