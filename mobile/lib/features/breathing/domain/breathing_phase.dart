/// Represents the different phases of the breathing exercise
/// Following the PRD: Intro → Inhale → Hold → Exhale → Success
enum BreathingPhase {
  /// Initial screen with Oracle introduction
  intro,
  
  /// Inhale phase: "Inhale slowly for 5 seconds"
  inhale,
  
  /// Hold phase: "Hold the breath for a while..."
  hold,
  
  /// Exhale phase: "Exhale slowly for 5 seconds"
  exhale,
  
  /// Success phase: completion message and navigation
  success,
}

/// Extension to provide useful methods for BreathingPhase
extension BreathingPhaseExtension on BreathingPhase {
  /// Get the display name for each phase
  String get displayName {
    switch (this) {
      case BreathingPhase.intro:
        return 'Intro';
      case BreathingPhase.inhale:
        return 'Inhale';
      case BreathingPhase.hold:
        return 'Hold';
      case BreathingPhase.exhale:
        return 'Exhale';
      case BreathingPhase.success:
        return 'Success';
    }
  }

  /// Get the duration for each phase in seconds
  /// According to PRD: Intro (manual), Inhale (5s), Hold (5s), Exhale (5s), Success (manual)
  int get durationSeconds {
    switch (this) {
      case BreathingPhase.intro:
        return 0; // Manual trigger
      case BreathingPhase.inhale:
        return 5;
      case BreathingPhase.hold:
        return 5;
      case BreathingPhase.exhale:
        return 5;
      case BreathingPhase.success:
        return 0; // Manual trigger
    }
  }

  /// Get the Oracle's message for each phase
  String get oracleMessage {
    switch (this) {
      case BreathingPhase.intro:
        return 'Take a moment to breathe, transform each inhale into power.';
      case BreathingPhase.inhale:
        return 'Inhale slowly for 5 seconds and fill your lungs.';
      case BreathingPhase.hold:
        return 'Hold in the breath for a while…';
      case BreathingPhase.exhale:
        return 'Exhale slowly for 5 seconds and empty your lungs.';
      case BreathingPhase.success:
        return 'Fantastic job! Your breath is your superpower, offering strength and calm.';
    }
  }

  /// Get the route path for navigation
  String get routePath {
    switch (this) {
      case BreathingPhase.intro:
        return '/intro';
      case BreathingPhase.inhale:
        return '/inhale';
      case BreathingPhase.hold:
        return '/hold';
      case BreathingPhase.exhale:
        return '/exhale';
      case BreathingPhase.success:
        return '/success';
    }
  }

  /// Get the next phase in the sequence
  BreathingPhase? get nextPhase {
    switch (this) {
      case BreathingPhase.intro:
        return BreathingPhase.inhale;
      case BreathingPhase.inhale:
        return BreathingPhase.hold;
      case BreathingPhase.hold:
        return BreathingPhase.exhale;
      case BreathingPhase.exhale:
        return BreathingPhase.success;
      case BreathingPhase.success:
        return null; // End of sequence
    }
  }
}