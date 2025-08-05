import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/shared/services/audio_service.dart';
import 'package:mobile/features/breathing/audio/audio_manager.dart';

/// Provider for the audio service
/// This enables dependency injection and easy testing
final audioServiceProvider = Provider.autoDispose<AudioService>((ref) {
  final audioManager = AudioManager();
  
  // Dispose the audio manager when the provider is disposed
  ref.onDispose(() async {
    await audioManager.dispose();
  });
  
  return audioManager;
});

/// Provider to track audio initialization state
final audioInitializationProvider = FutureProvider.autoDispose<bool>((ref) async {
  final audioService = ref.read(audioServiceProvider);
  try {
    await audioService.initialize();
    return audioService.isAudioAvailable;
  } catch (e) {
    // Return false if initialization fails
    return false;
  }
});

/// Provider to track current audio availability
final audioAvailabilityProvider = Provider.autoDispose<bool>((ref) {
  final audioService = ref.read(audioServiceProvider);
  return audioService.isAudioAvailable;
});