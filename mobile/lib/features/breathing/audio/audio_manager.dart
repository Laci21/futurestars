import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:mobile/shared/services/audio_service.dart';
import 'package:mobile/shared/services/app_logger.dart';

/// Production audio manager for the breathing exercise
/// Handles background music, Oracle voiceovers, and audio focus management
class AudioManager with LoggerMixin implements AudioService {
  
  /// Voice clip asset paths mapping
  static const Map<String, String> _voiceClipPaths = {
    'intro': 'assets/audio/oracle_intro.m4a',
    'inhale': 'assets/audio/oracle_inhale.m4a',
    'hold': 'assets/audio/oracle_hold.m4a',
    'exhale': 'assets/audio/oracle_exhale.m4a',
    'success': 'assets/audio/oracle_success.m4a',
  };

  // Audio players
  late final AudioPlayer _backgroundMusicPlayer;
  late final AudioPlayer _voiceoverPlayer;
  
  // Audio session for handling interruptions
  late final AudioSession _audioSession;
  
  // State
  bool _isInitialized = false;
  bool _backgroundMusicLoaded = false;
  bool _voiceoversLoaded = false;
  
  // Audio session interruption subscription
  StreamSubscription<AudioInterruptionEvent>? _interruptionSubscription;

  /// Initialize the audio manager
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize audio session
      _audioSession = await AudioSession.instance;
      await _audioSession.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
      ));

      // Initialize players
      _backgroundMusicPlayer = AudioPlayer();
      _voiceoverPlayer = AudioPlayer();

      // Load audio assets
      await _loadBackgroundMusic();
      await _loadVoiceovers();
      
      // Set up audio session interruption handling
      _setupAudioInterruptions();

      _isInitialized = true;
      logInfo('Audio manager initialized successfully');
    } catch (e, stackTrace) {
      // Graceful fallback - continue without audio
      logError('Audio initialization failed', e, stackTrace);
      _isInitialized = false;
    }
  }

  /// Load background music
  Future<void> _loadBackgroundMusic() async {
    try {
      await _backgroundMusicPlayer.setAsset('assets/audio/background_music.m4a');
      await _backgroundMusicPlayer.setVolume(0.1);
      _backgroundMusicLoaded = true;
      logInfo('Background music loaded successfully');
    } catch (e, stackTrace) {
      logWarning('Background music loading failed: assets/audio/background_music.m4a', e, stackTrace);
      _backgroundMusicLoaded = false;
    }
  }

  /// Load Oracle voiceovers - just mark as ready for lazy loading
  Future<void> _loadVoiceovers() async {
    try {
      logInfo('Voiceovers ready for lazy loading (no pre-caching)');
      
      // Don't pre-cache anymore - just mark as loaded
      // Files will be validated when actually played
      _voiceoversLoaded = true;
      
    } catch (e, stackTrace) {
      logError('Voiceover initialization failed', e, stackTrace);
      _voiceoversLoaded = false;
    }
  }

  /// Start background music
  @override
  Future<void> startBackgroundMusic() async {
    if (!_isInitialized) {
      logWarning('Cannot start background music - audio not initialized');
      return;
    }
    
    if (!_backgroundMusicLoaded) {
      logWarning('Background music not loaded - continuing without background music');
      return;
    }
    
    try {
      await _backgroundMusicPlayer.setLoopMode(LoopMode.one);
      await _backgroundMusicPlayer.setVolume(0.1);
      await _backgroundMusicPlayer.play();
      logInfo('Background music started');
    } catch (e, stackTrace) {
      logError('Background music playback failed', e, stackTrace);
    }
  }

  /// Play Oracle voiceover with volume ducking
  @override
  Future<void> playVoiceClip(String clipName) async {
    if (!_isInitialized || !_voiceoversLoaded) {
      logWarning('Audio not ready for voiceover: $clipName');
      return;
    }
    
    final assetPath = _voiceClipPaths[clipName];
    if (assetPath == null) {
      logError('Unknown voice clip: $clipName');
      return;
    }
    
    try {
      // Duck background music volume smoothly
      await _fadeVolume(_backgroundMusicPlayer, null, 0.05, const Duration(milliseconds: 300));
      
      // Load and play voiceover with detailed error handling
      try {
        await _voiceoverPlayer.setAsset(assetPath);
        await _voiceoverPlayer.play();
        
        // Wait for voiceover to complete
        await _voiceoverPlayer.playerStateStream.firstWhere(
          (state) => state.processingState == ProcessingState.completed,
        );
      } catch (audioError, audioStackTrace) {
        logError('Audio loading/playback error for $clipName', audioError, audioStackTrace);
        
        if (audioError.toString().contains('Operation Stopped')) {
          logWarning('Audio format issue detected for $assetPath');
        }
        
        // Continue without voiceover rather than crashing
        logWarning('Continuing exercise without voiceover for: $clipName');
      }
      
      // Restore background music volume smoothly
      await _fadeVolume(_backgroundMusicPlayer, null, 0.1, const Duration(milliseconds: 300));
      
    } catch (e, stackTrace) {
      logError('Overall voiceover process failed for $clipName', e, stackTrace);
      // Restore volume even on error
      await _fadeVolume(_backgroundMusicPlayer, null, 0.1, const Duration(milliseconds: 300));
    }
  }

  /// Stop current voiceover only
  @override
  Future<void> stopVoiceover() async {
    try {
      await _voiceoverPlayer.stop();
      logInfo('Voiceover stopped');
      
      // Restore background music volume if it was ducked
      if (_backgroundMusicLoaded && _backgroundMusicPlayer.playing) {
        await _fadeVolume(_backgroundMusicPlayer, null, 0.1, const Duration(milliseconds: 300));
      }
    } catch (e, stackTrace) {
      logError('Failed to stop voiceover', e, stackTrace);
    }
  }

  /// Stop all audio with fade-out
  @override
  Future<void> stopAll() async {
    if (!_isInitialized) return;
    
    try {
      // Fade out background music over 2 seconds
      await _fadeVolume(_backgroundMusicPlayer, null, 0.0, const Duration(seconds: 2));
      
      // Stop both players
      await _backgroundMusicPlayer.stop();
      await _voiceoverPlayer.stop();
      
      logInfo('Successfully stopped all audio with fade-out');
    } catch (e, stackTrace) {
      logError('Failed to stop audio gracefully', e, stackTrace);
      // Force stop if fade fails
      await _backgroundMusicPlayer.stop();
      await _voiceoverPlayer.stop();
    }
  }

  /// Pause all audio
  @override
  Future<void> pauseAll() async {
    if (!_isInitialized) return;
    
    await _backgroundMusicPlayer.pause();
    await _voiceoverPlayer.pause();
  }

  /// Resume all audio
  @override
  Future<void> resumeAll() async {
    if (!_isInitialized) return;
    
    await _backgroundMusicPlayer.setVolume(0.1);
    await _backgroundMusicPlayer.play();
  }

  /// Dispose of resources
  @override
  Future<void> dispose() async {
    if (!_isInitialized) return;
    
    // Cancel interruption subscription
    await _interruptionSubscription?.cancel();
    _interruptionSubscription = null;
    
    // Dispose players
    await _backgroundMusicPlayer.dispose();
    await _voiceoverPlayer.dispose();
    _isInitialized = false;
    
    logInfo('Audio manager disposed');
  }

  /// Check if audio is available
  @override
  bool get isAudioAvailable => _isInitialized && (_backgroundMusicLoaded || _voiceoversLoaded);
  
  /// Set up audio session interruption handling (phone calls, etc.)
  void _setupAudioInterruptions() {
    _interruptionSubscription = _audioSession.interruptionEventStream.listen(
      (event) {
        logInfo('Audio interruption: ${event.type}');
        switch (event.type) {
          case AudioInterruptionType.duck:
            // Another app wants to play audio briefly (like notifications)
            // Duck our volume temporarily
            _fadeVolume(_backgroundMusicPlayer, null, 0.3, const Duration(milliseconds: 200));
            break;
          case AudioInterruptionType.pause:
            // Another app wants to play audio (like phone calls)
            pauseAll();
            break;
          case AudioInterruptionType.unknown:
            break;
        }
      },
      onError: (error) {
        logWarning('Audio interruption stream error', error);
      },
    );
  }
  
  /// Smoothly fade audio volume from current to target over duration
  Future<void> _fadeVolume(
    AudioPlayer player, 
    double? fromVolume, 
    double toVolume, 
    Duration duration,
  ) async {
    try {
      final currentVolume = fromVolume ?? player.volume;
      const stepCount = 10;
      final stepDuration = Duration(milliseconds: duration.inMilliseconds ~/ stepCount);
      final volumeStep = (toVolume - currentVolume) / stepCount;
      
      for (int i = 1; i <= stepCount; i++) {
        final newVolume = (currentVolume + (volumeStep * i)).clamp(0.0, 1.0);
        await player.setVolume(newVolume);
        await Future.delayed(stepDuration);
      }
      
      // Ensure we end at exact target volume
      await player.setVolume(toVolume);
    } catch (e, stackTrace) {
      logWarning('Volume fade failed', e, stackTrace);
      // Fallback to direct volume set
      await player.setVolume(toVolume);
    }
  }
}