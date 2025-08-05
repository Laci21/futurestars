import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated sound wave bars matching the design exactly
/// Shows horizontal audio visualizer bars during breathing phases
/// 
/// Flutter Learning Notes:
/// - AnimationController: Drives the wave animation
/// - AnimatedBuilder: Rebuilds widget when animation changes  
/// - Transform.scale: Animates individual bar heights
/// - Row: Arranges bars horizontally
/// - Curves: Makes animation feel natural (easeInOut)
class SoundWaveWidget extends StatefulWidget {
  const SoundWaveWidget({
    super.key,
    this.isAnimating = true,
    this.barCount = 20,
    this.maxHeight = 40.0,
    this.barWidth = 3.0,
    this.spacing = 4.0,
    this.color,
  });

  /// Whether the bars should animate
  final bool isAnimating;
  
  /// Number of bars to display
  final int barCount;
  
  /// Maximum height of the tallest bars
  final double maxHeight;
  
  /// Width of each individual bar
  final double barWidth;
  
  /// Spacing between bars
  final double spacing;
  
  /// Color of the bars (defaults to design color)
  final Color? color;

  @override
  State<SoundWaveWidget> createState() => _SoundWaveWidgetState();
}

class _SoundWaveWidgetState extends State<SoundWaveWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _barControllers;
  late List<Animation<double>> _barAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.isAnimating) {
      _startAnimating();
    }
  }

  /// Initialize all animation controllers for individual bars
  /// Flutter Learning: Multiple AnimationControllers can create complex effects
  void _initializeAnimations() {
    // Main controller for overall wave timing
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Individual controllers for each bar with slight delays
    _barControllers = List.generate(widget.barCount, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 800 + (index * 50)), // Staggered timing
        vsync: this,
      );
    });

    // Individual animations for each bar height
    _barAnimations = _barControllers.map((controller) {
      return Tween<double>(
        begin: 0.3, // Minimum height scale
        end: 1.0,   // Maximum height scale
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();
  }

  /// Start the wave animation with staggered bar timing
  void _startAnimating() {
    // Start each bar animation with a slight delay
    for (int i = 0; i < _barControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _barControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  /// Stop all animations
  void _stopAnimating() {
    for (final controller in _barControllers) {
      controller.stop();
    }
  }

  @override
  void didUpdateWidget(SoundWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle animation state changes
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _startAnimating();
      } else {
        _stopAnimating();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final controller in _barControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.maxHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(widget.barCount, _buildAnimatedBar),
      ),
    );
  }

  /// Build individual animated bar
  /// Flutter Learning: AnimatedBuilder is efficient for custom animations
  Widget _buildAnimatedBar(int index) {
    return AnimatedBuilder(
      animation: _barAnimations[index],
      builder: (context, child) {
        // Calculate bar height with some randomness for natural feel
        final baseHeight = _calculateBarHeight(index);
        final animatedScale = widget.isAnimating 
            ? _barAnimations[index].value
            : 0.5; // Static height when not animating
        final finalHeight = baseHeight * animatedScale;

        return Container(
          width: widget.barWidth,
          height: finalHeight,
          margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
          decoration: BoxDecoration(
            color: widget.color ?? const Color(0xFFE8F8FF), // Light cyan from design
            borderRadius: BorderRadius.circular(widget.barWidth / 2),
            // Subtle glow effect
            boxShadow: [
              BoxShadow(
                color: (widget.color ?? const Color(0xFFE8F8FF)).withOpacity(0.4),
                blurRadius: 2,
                spreadRadius: 0.5,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Calculate base height for each bar to create wave pattern
  /// Flutter Learning: math functions can create natural-looking patterns
  double _calculateBarHeight(int index) {
    // Create a wave pattern with some randomness
    final normalizedIndex = index / (widget.barCount - 1);
    
    // Sine wave for natural audio visualization feel
    final sineValue = math.sin(normalizedIndex * math.pi * 2);
    
    // Add some variation to make it look more organic
    final variation = math.sin(normalizedIndex * math.pi * 4) * 0.3;
    
    // Combine sine wave with variation and normalize to 0.4-1.0 range
    final combinedValue = (sineValue + variation).abs();
    return (combinedValue * 0.6 + 0.4) * widget.maxHeight;
  }
}

/// Static version of sound wave for non-animated states
/// Flutter Learning: Sometimes you need simpler versions for different contexts
class StaticSoundWave extends StatelessWidget {
  const StaticSoundWave({
    super.key,
    this.barCount = 20,
    this.maxHeight = 40.0,
    this.barWidth = 3.0,
    this.spacing = 4.0,
    this.color,
  });

  final int barCount;
  final double maxHeight;
  final double barWidth;
  final double spacing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(barCount, (index) {
          final height = _calculateStaticBarHeight(index);
          
          return Container(
            width: barWidth,
            height: height,
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            decoration: BoxDecoration(
              color: (color ?? const Color(0xFFE8F8FF)).withOpacity(0.6),
              borderRadius: BorderRadius.circular(barWidth / 2),
            ),
          );
        }),
      ),
    );
  }

  double _calculateStaticBarHeight(int index) {
    final normalizedIndex = index / (barCount - 1);
    final sineValue = math.sin(normalizedIndex * math.pi * 1.5);
    return (sineValue.abs() * 0.7 + 0.3) * maxHeight;
  }
}
