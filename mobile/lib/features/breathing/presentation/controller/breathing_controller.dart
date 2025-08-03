import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/breathing_phase.dart';
import '../../../../shared/services/app_logger.dart';
import '../../../../shared/providers/audio_provider.dart';

/// Enhanced breathing state containing all information needed for the UI
class BreathingState {
  const BreathingState({
    required this.phase,
    required this.countdown,
    required this.isAudioLoaded,
    required this.elapsed,
    required this.progress,
  });

  /// Current phase of the breathing exercise
  final BreathingPhase phase;
  
  /// Countdown timer (5 → 1 for timed phases)
  final int countdown;
  
  /// Whether audio assets are loaded and ready
  final bool isAudioLoaded;
  
  /// Time elapsed since phase started
  final Duration elapsed;
  
  /// Progress through the entire exercise (0.0 to 1.0)
  final double progress;

  /// Create a copy with updated values
  BreathingState copyWith({
    BreathingPhase? phase,
    int? countdown,
    bool? isAudioLoaded,
    Duration? elapsed,
    double? progress,
  }) {
    return BreathingState(
      phase: phase ?? this.phase,
      countdown: countdown ?? this.countdown,
      isAudioLoaded: isAudioLoaded ?? this.isAudioLoaded,
      elapsed: elapsed ?? this.elapsed,
      progress: progress ?? this.progress,
    );
  }

  @override
  String toString() {
    return 'BreathingState(phase: $phase, countdown: $countdown, '
           'isAudioLoaded: $isAudioLoaded, elapsed: $elapsed, progress: $progress)';
  }
}

/// Controller for managing breathing exercise state
class BreathingController extends StateNotifier<BreathingState> with LoggerMixin {
  BreathingController(this._ref) : super(const BreathingState(
    phase: BreathingPhase.intro,
    countdown: 0,
    isAudioLoaded: false,
    elapsed: Duration.zero,
    progress: 0.0,
  )) {
    logInfo('Breathing controller initialized');
  }

  final Ref _ref;

  /// Start the breathing exercise
  void startExercise() {
    state = state.copyWith(
      phase: BreathingPhase.intro,
      countdown: 0,
      elapsed: Duration.zero,
      progress: 0.0,
    );
  }

  /// Move to the next phase
  void nextPhase() {
    final nextPhase = state.phase.nextPhase;
    if (nextPhase != null) {
      logInfo('Moving to next phase: ${nextPhase.displayName}');
      
      // Haptic feedback on phase change
      _triggerPhaseHaptic(nextPhase);
      
      state = state.copyWith(
        phase: nextPhase,
        countdown: nextPhase.durationSeconds,
        elapsed: Duration.zero,
        progress: _calculateProgress(nextPhase),
      );

      // Play Oracle voiceover for this phase
      _playPhaseAudio(nextPhase);
    }
  }

  /// Play audio for the current phase
  Future<void> _playPhaseAudio(BreathingPhase phase) async {
    try {
      final audioService = _ref.read(audioServiceProvider);
      if (audioService.isAudioAvailable) {
        await audioService.playVoiceClip(phase.name);
      }
    } catch (e, stackTrace) {
      logWarning('Failed to play audio for phase: ${phase.displayName}', e, stackTrace);
    }
  }

  /// Trigger haptic feedback for phase changes
  /// Flutter Learning: Different haptic patterns for different interactions
  void _triggerPhaseHaptic(BreathingPhase phase) {
    try {
      switch (phase) {
        case BreathingPhase.intro:
          // Light haptic for gentle start
          HapticFeedback.lightImpact();
          break;
        case BreathingPhase.inhale:
          // Medium haptic for active breathing phase
          HapticFeedback.mediumImpact();
          break;
        case BreathingPhase.hold:
          // Light haptic for pause phase
          HapticFeedback.lightImpact();
          break;
        case BreathingPhase.exhale:
          // Medium haptic for active breathing phase
          HapticFeedback.mediumImpact();
          break;
        case BreathingPhase.success:
          // Heavy haptic for completion celebration
          HapticFeedback.heavyImpact();
          break;
      }
      logInfo('Triggered haptic feedback for phase: ${phase.displayName}');
    } catch (e, stackTrace) {
      // Haptics might not be available on all devices - graceful fallback
      logWarning('Failed to trigger haptic feedback', e, stackTrace);
    }
  }

  /// Update countdown timer
  void updateCountdown(int newCountdown) {
    state = state.copyWith(countdown: newCountdown);
  }

  /// Update elapsed time
  void updateElapsed(Duration newElapsed) {
    state = state.copyWith(elapsed: newElapsed);
  }

  /// Set audio loaded status
  void setAudioLoaded(bool loaded) {
    state = state.copyWith(isAudioLoaded: loaded);
  }

  /// Reset to initial state
  void reset() {
    state = const BreathingState(
      phase: BreathingPhase.intro,
      countdown: 0,
      isAudioLoaded: false,
      elapsed: Duration.zero,
      progress: 0.0,
    );
  }

  /// Calculate progress through the entire exercise
  double _calculateProgress(BreathingPhase phase) {
    switch (phase) {
      case BreathingPhase.intro:
        return 0.0;
      case BreathingPhase.inhale:
        return 0.25;
      case BreathingPhase.hold:
        return 0.5;
      case BreathingPhase.exhale:
        return 0.75;
      case BreathingPhase.success:
        return 1.0;
    }
  }
}

/// Provider for the breathing exercise controller
final breathingControllerProvider = StateNotifierProvider<BreathingController, BreathingState>((ref) {
  return BreathingController(ref);
});