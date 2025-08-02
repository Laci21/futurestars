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

  /// Bubble scale animation (breathes in and out)
  late final Animation<double> bubbleScale;

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
        tween: Tween<double>(begin: 1.0, end: 1.4).chain(
          CurveTween(curve: Curves.easeInOutCubic)
        ), // Grow during inhale
        weight: 25, // 5 seconds
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.4), // Stay large during hold
        weight: 25, // 5 seconds
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOutCubic)
        ), // Shrink during exhale
        weight: 25, // 5 seconds
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0), // Static during success
        weight: 20, // 4 seconds
      ),
    ]).animate(master);

    // Progress: Linear progress through the exercise
    progress = Tween<double>(begin: 0.0, end: 1.0).animate(master);

    // TODO: Implement countdown animation
    // This will require custom animation logic to show 5→1 during timed phases
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