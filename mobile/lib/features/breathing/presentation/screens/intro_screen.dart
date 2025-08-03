import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/oracle_avatar.dart';
import '../widgets/breathing_bubble.dart';
import '../widgets/progress_line.dart';
import '../widgets/responsive_text.dart';
import '../../../../shared/services/image_cache_service.dart';

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
                child: Padding(
                  padding: context.responsivePadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Oracle avatar
                      const OracleAvatar(size: 80),
                      
                      SizedBox(height: context.responsiveSpacing * 2),
                      
                      // Welcome text
                      ResponsiveTextWidgets.heading(
                        'Take some moment to breathe, transform each inhale into power',
                      ),
                      
                      SizedBox(height: context.responsiveSpacing),
                      
                      // Subtitle
                      ResponsiveTextWidgets.body(
                        'Your breath is a bridge between challenge and tranquility',
                      ),
                      
                      SizedBox(height: context.responsiveSpacing * 3),
                      
                      // Start button
                      ElevatedButton(
                        onPressed: _startBreathingExercise,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: const Color(0xFF1A1D4A),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ResponsiveTextWidgets.button('Start the Breath Exercise'),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ],
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
