/// Abstract interface for audio services
/// This enables easy testing and different implementations
abstract class AudioService {
  /// Initialize the audio service
  Future<void> initialize();

  /// Start background music
  Future<void> startBackgroundMusic();

  /// Play Oracle voiceover with volume ducking
  Future<void> playVoiceClip(String clipName);

  /// Stop all audio
  Future<void> stopAll();

  /// Pause all audio
  Future<void> pauseAll();

  /// Resume all audio
  Future<void> resumeAll();

  /// Dispose of resources
  Future<void> dispose();

  /// Check if audio is available
  bool get isAudioAvailable;
}