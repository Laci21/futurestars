import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/breathing/presentation/controller/breathing_controller.dart';
import 'package:mobile/features/breathing/domain/breathing_phase.dart';
import 'package:mobile/shared/providers/audio_provider.dart';
import 'package:mobile/shared/services/audio_service.dart';

/// Mock audio service for unit testing
class MockAudioService implements AudioService {
  bool _isAudioAvailable = false;
  
  @override
  Future<void> initialize() async {
    // Mock initialization - do nothing
  }

  @override
  bool get isAudioAvailable => _isAudioAvailable;

  @override
  Future<void> startBackgroundMusic() async {
    // Mock audio playback - do nothing
  }

  @override
  Future<void> playVoiceClip(String clipName) async {
    // Mock voice clip playback - do nothing
  }

  @override
  Future<void> stopVoiceover() async {
    // Mock stop voiceover - do nothing
  }

  @override
  Future<void> stopAll() async {
    // Mock stop all - do nothing
  }

  @override
  Future<void> pauseAll() async {
    // Mock pause - do nothing
  }

  @override
  Future<void> resumeAll() async {
    // Mock resume - do nothing
  }

  @override
  Future<void> dispose() async {
    _isAudioAvailable = false;
  }
}

void main() {
  // Initialize Flutter services for unit tests (needed for HapticFeedback)
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('BreathingController', () {
    late ProviderContainer container;
    late BreathingController controller;
    
    setUp(() {
      // Create container with mocked audio service
      container = ProviderContainer(
        overrides: [
          audioServiceProvider.overrideWithValue(MockAudioService()),
        ],
      );
      
      // Get the controller instance
      controller = container.read(breathingControllerProvider.notifier);
    });
    
    tearDown(() {
      container.dispose();
    });

    test('starts in intro phase with correct initial state', () {
      final state = container.read(breathingControllerProvider);
      
      expect(state.phase, BreathingPhase.intro);
      expect(state.countdown, 0);
      expect(state.elapsed, Duration.zero);
      expect(state.progress, 0.0);
      expect(state.isAudioLoaded, false);
    });

    test('progresses through phases in correct order', () {
      // Start in intro
      expect(container.read(breathingControllerProvider).phase, BreathingPhase.intro);
      
      // Move to inhale
      controller.nextPhase();
      expect(container.read(breathingControllerProvider).phase, BreathingPhase.inhale);
      
      // Move to hold
      controller.nextPhase();
      expect(container.read(breathingControllerProvider).phase, BreathingPhase.hold);
      
      // Move to exhale
      controller.nextPhase();
      expect(container.read(breathingControllerProvider).phase, BreathingPhase.exhale);
      
      // Move to success
      controller.nextPhase();
      expect(container.read(breathingControllerProvider).phase, BreathingPhase.success);
      
      // Should stay in success - no further progression
      controller.nextPhase();
      expect(container.read(breathingControllerProvider).phase, BreathingPhase.success);
    });
    
    test('calculates progress correctly', () {
      // Intro: 0.0
      expect(container.read(breathingControllerProvider).progress, 0.0);
      
      // Inhale: 0.25
      controller.nextPhase();
      expect(container.read(breathingControllerProvider).progress, 0.25);
      
      // Hold: 0.5
      controller.nextPhase();
      expect(container.read(breathingControllerProvider).progress, 0.5);
      
      // Exhale: 0.75
      controller.nextPhase();
      expect(container.read(breathingControllerProvider).progress, 0.75);
      
      // Success: 1.0
      controller.nextPhase();
      expect(container.read(breathingControllerProvider).progress, 1.0);
    });
    

    test('handles audio loading states', () {
      // Initially audio should not be loaded
      expect(container.read(breathingControllerProvider).isAudioLoaded, false);
      
      // Set audio loaded
      controller.setAudioLoaded(true);
      expect(container.read(breathingControllerProvider).isAudioLoaded, true);
      
      // Set audio not loaded
      controller.setAudioLoaded(false);
      expect(container.read(breathingControllerProvider).isAudioLoaded, false);
    });
    
    test('updates countdown correctly', () {
      // Start with countdown 0
      expect(container.read(breathingControllerProvider).countdown, 0);
      
      // Update countdown
      controller.updateCountdown(5);
      expect(container.read(breathingControllerProvider).countdown, 5);
      
      controller.updateCountdown(3);
      expect(container.read(breathingControllerProvider).countdown, 3);
      
      controller.updateCountdown(0);
      expect(container.read(breathingControllerProvider).countdown, 0);
    });
    
    test('updates elapsed time correctly', () {
      // Start with elapsed 0
      expect(container.read(breathingControllerProvider).elapsed, Duration.zero);
      
      // Update elapsed time
      controller.updateElapsed(const Duration(seconds: 2));
      expect(container.read(breathingControllerProvider).elapsed, const Duration(seconds: 2));
      
      controller.updateElapsed(const Duration(seconds: 5));
      expect(container.read(breathingControllerProvider).elapsed, const Duration(seconds: 5));
      
      controller.updateElapsed(Duration.zero);
      expect(container.read(breathingControllerProvider).elapsed, Duration.zero);
    });
    
    test('breathing phases have correct durations', () {
      // Test that each phase reports the expected duration
      expect(BreathingPhase.intro.durationSeconds, 0); // Manual phase
      expect(BreathingPhase.inhale.durationSeconds, 5);
      expect(BreathingPhase.hold.durationSeconds, 5);
      expect(BreathingPhase.exhale.durationSeconds, 5);
      expect(BreathingPhase.success.durationSeconds, 0); // Manual phase
    });
    
    test('breathing phases have correct display names', () {
      expect(BreathingPhase.intro.displayName, 'Intro');
      expect(BreathingPhase.inhale.displayName, 'Inhale');
      expect(BreathingPhase.hold.displayName, 'Hold');
      expect(BreathingPhase.exhale.displayName, 'Exhale');
      expect(BreathingPhase.success.displayName, 'Success');
    });
  });
}