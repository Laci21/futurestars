import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';
import '../../features/breathing/audio/audio_manager.dart';

/// Provider for the audio service
/// This enables dependency injection and easy testing
final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioManager();
});

/// Provider to track audio initialization state
final audioInitializationProvider = FutureProvider<bool>((ref) async {
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
final audioAvailabilityProvider = Provider<bool>((ref) {
  final audioService = ref.read(audioServiceProvider);
  return audioService.isAudioAvailable;
});