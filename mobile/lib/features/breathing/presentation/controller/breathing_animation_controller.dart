import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

/// Master animation controller for perfect timing synchronization
/// This ensures all animations (bubble, countdown, audio) are perfectly synchronized
class BreathingAnimationController {
  BreathingAnimationController({required TickerProvider vsync}) {
    // 20-second total duration for the entire breathing cycle
    master = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: vsync,
    );

    _initializeAnimations();
  }

  /// Master controller - single source of truth for timing
  late final AnimationController master;

  /// Bubble scale animation (breathes in and out) - main bubble with text
  late final Animation<double> bubbleScale;

  /// Middle circle scale animation (subtle breathing)
  late final Animation<double> middleCircleScale;

  /// Countdown animation (5 → 1)
  late final Animation<int> countdown;

  /// Progress through entire exercise (0.0 to 1.0)
  late final Animation<double> progress;

  /// Initialize all derived animations from the master controller
  void _initializeAnimations() {
    // Phase timing breakdown:
    // 0.0-0.05 (1s): intro
    // 0.05-0.3 (5s): inhale  
    // 0.3-0.55 (5s): hold
    // 0.55-0.8 (5s): exhale
    // 0.8-1.0 (4s): success

    // Bubble scale: grows during inhale, stays during hold, shrinks during exhale
    bubbleScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0), // Static during intro
        weight: 5, // 1 second
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2).chain(
          CurveTween(curve: Curves.easeInOutCubic)
        ), // Grow moderately during inhale
        weight: 25, // 5 seconds
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.2), // Stay moderately large during hold
        weight: 25, // 5 seconds
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOutCubic)
        ), // Shrink during exhale
        weight: 25, // 5 seconds
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0), // Static during success
        weight: 20, // 4 seconds
      ),
    ]).animate(master);

    // Middle circle scale: very subtle breathing animation (much smaller range than main bubble)
    middleCircleScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0), // Static during intro
        weight: 5, // 1 second
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.05).chain(
          CurveTween(curve: Curves.easeInOutCubic)
        ), // Grow very slightly during inhale
        weight: 25, // 5 seconds
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.05), // Stay very slightly larger during hold
        weight: 25, // 5 seconds
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOutCubic)
        ), // Shrink very slightly during exhale
        weight: 25, // 5 seconds
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0), // Static during success
        weight: 20, // 4 seconds
      ),
    ]).animate(master);

    // Progress: Linear progress through the exercise
    progress = Tween<double>(begin: 0.0, end: 1.0).animate(master);

    // Countdown animation: Shows 5→1 during timed phases
    countdown = _createCountdownAnimation();
  }

  /// Start the breathing animation sequence
  void start() {
    master.forward();
  }

  /// Pause the animation
  void pause() {
    master.stop();
  }

  /// Resume the animation
  void resume() {
    master.forward();
  }

  /// Reset to beginning
  void reset() {
    master.reset();
  }

  /// Stop and reset
  void stop() {
    master.stop();
    master.reset();
  }

  /// Create countdown animation that shows 5→1 during timed phases
  Animation<int> _createCountdownAnimation() {
    return AnimationProxy<int>(
      parent: master,
      getValue: (value) {
        // Inhale phase: 0.05-0.3 (5 seconds)
        if (value >= 0.05 && value < 0.3) {
          final phaseProgress = (value - 0.05) / 0.25; // 0.0 to 1.0 within inhale
          return (5.0 - (phaseProgress * 4.0)).floor().clamp(1, 5);
        }
        // Hold phase: 0.3-0.55 (5 seconds) - no countdown, show pause icon
        if (value >= 0.3 && value < 0.55) {
          return -1; // Special value for pause icon
        }
        // Exhale phase: 0.55-0.8 (5 seconds)
        if (value >= 0.55 && value < 0.8) {
          final phaseProgress = (value - 0.55) / 0.25;
          return (5.0 - (phaseProgress * 4.0)).floor().clamp(1, 5);
        }
        return 0; // No countdown for intro/success
      },
    );
  }

  /// Get current phase based on animation progress
  String getCurrentPhase() {
    final value = master.value;
    if (value < 0.05) return 'intro';
    if (value < 0.3) return 'inhale';
    if (value < 0.55) return 'hold';
    if (value < 0.8) return 'exhale';
    return 'success';
  }

  /// Dispose of resources
  void dispose() {
    master.dispose();
  }
}

/// Custom animation proxy for countdown logic
class AnimationProxy<T> extends Animation<T> {
  AnimationProxy({
    required this.parent,
    required this.getValue,
  });

  final Animation<double> parent;
  final T Function(double) getValue;

  @override
  T get value => getValue(parent.value);

  @override
  AnimationStatus get status => parent.status;

  @override
  void addListener(VoidCallback listener) => parent.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => parent.removeListener(listener);

  @override
  void addStatusListener(AnimationStatusListener listener) => parent.addStatusListener(listener);

  @override
  void removeStatusListener(AnimationStatusListener listener) => parent.removeStatusListener(listener);
}