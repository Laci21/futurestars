import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_logger.dart';

/// Centralized image pre-caching service for smooth performance
/// Pre-loads images before they're needed to eliminate loading delays
/// 
/// Flutter Learning Notes:
/// - precacheImage(): Loads images into memory cache
/// - ImageProvider: Different ways to load images (AssetImage, NetworkImage, etc.)
/// - try-catch: Essential for handling missing assets gracefully
/// - Future.wait(): Execute multiple async operations in parallel
class ImageCacheService with LoggerMixin {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  /// Set to track which image sets have been pre-cached
  final Set<String> _cachedSets = {};

  /// Pre-cache all breathing exercise images
  /// Call this in app initialization or before entering breathing flow
  Future<void> precacheBreathingImages(BuildContext context) async {
    if (_cachedSets.contains('breathing')) {
      logInfo('Breathing images already cached, skipping');
      return;
    }

    try {
      logInfo('Starting to pre-cache breathing exercise images');
      
      // List of all images used in breathing exercise
      final imagesToCache = [
        // If you had actual image assets, they would be listed here:
        // 'assets/images/oracle_character.png',
        // 'assets/images/background_scenery.png',
        // 'assets/images/breathing_icons.png',
        
        // Since we're using CustomPainter for most graphics,
        // we'll pre-cache any actual image assets when they're added
      ];

      // Pre-cache all images in parallel for better performance
      final List<Future<void>> cacheOperations = imagesToCache.map((imagePath) {
        return _precacheSingleImage(context, imagePath);
      }).toList();

      await Future.wait(cacheOperations);
      
      _cachedSets.add('breathing');
      logInfo('Successfully pre-cached ${imagesToCache.length} breathing images');
      
    } catch (e, stackTrace) {
      logError('Failed to pre-cache breathing images', e, stackTrace);
    }
  }

  /// Pre-cache a single image with error handling
  /// Flutter Learning: Always handle image loading errors gracefully
  Future<void> _precacheSingleImage(BuildContext context, String imagePath) async {
    try {
      await precacheImage(AssetImage(imagePath), context);
      logInfo('Cached image: $imagePath');
    } catch (e) {
      // Don't let one missing image break the entire caching process
      logWarning('Failed to cache image: $imagePath - $e');
    }
  }

  /// Pre-cache help modal images
  Future<void> precacheHelpImages(BuildContext context) async {
    if (_cachedSets.contains('help')) return;

    try {
      logInfo('Pre-caching help modal images');
      
      final helpImages = [
        // Add help-related images here when available
        // 'assets/images/help_illustration.png',
      ];

      await Future.wait(helpImages.map((path) => _precacheSingleImage(context, path)));
      
      _cachedSets.add('help');
      logInfo('Help images cached successfully');
      
    } catch (e, stackTrace) {
      logError('Failed to cache help images', e, stackTrace);
    }
  }

  /// Pre-cache Oracle character variations (if using image assets)
  Future<void> precacheOracleImages(BuildContext context) async {
    if (_cachedSets.contains('oracle')) return;

    try {
      logInfo('Pre-caching Oracle character images');
      
      final oracleImages = [
        // Add Oracle character image variations here
        // 'assets/images/oracle_happy.png',
        // 'assets/images/oracle_calm.png',
        // 'assets/images/oracle_guiding.png',
      ];

      await Future.wait(oracleImages.map((path) => _precacheSingleImage(context, path)));
      
      _cachedSets.add('oracle');
      logInfo('Oracle images cached successfully');
      
    } catch (e, stackTrace) {
      logError('Failed to cache Oracle images', e, stackTrace);
    }
  }

  /// Pre-cache all app images at once (call during app startup)
  /// Flutter Learning: Batch operations for better performance
  Future<void> precacheAllImages(BuildContext context) async {
    logInfo('Pre-caching all app images');
    
    await Future.wait([
      precacheBreathingImages(context),
      precacheHelpImages(context),
      precacheOracleImages(context),
    ]);
    
    logInfo('All app images pre-cached successfully');
  }

  /// Clear image cache (useful for memory management)
  void clearCache() {
    _cachedSets.clear();
    // Clear Flutter's image cache
    imageCache.clear();
    logInfo('Image cache cleared');
  }

  /// Get cache status for debugging
  Map<String, bool> getCacheStatus() {
    return {
      'breathing': _cachedSets.contains('breathing'),
      'help': _cachedSets.contains('help'),
      'oracle': _cachedSets.contains('oracle'),
    };
  }
}

/// Mixin to add image pre-caching capabilities to widgets
/// Flutter Learning: Mixins provide reusable functionality
mixin ImageCacheMixin {
  final ImageCacheService _imageCacheService = ImageCacheService();

  /// Pre-cache images in a widget's initState
  Future<void> precacheImagesForWidget(BuildContext context, List<String> imagePaths) async {
    try {
      final cacheOperations = imagePaths.map((path) async {
        await precacheImage(AssetImage(path), context);
      });
      
      await Future.wait(cacheOperations);
    } catch (e) {
      debugPrint('Failed to pre-cache widget images: $e');
    }
  }
}

/// Extension to add pre-caching methods to BuildContext
/// Flutter Learning: Extensions add functionality to existing classes
extension ImageCacheContext on BuildContext {
  /// Quick access to image cache service from any BuildContext
  ImageCacheService get imageCacheService => ImageCacheService();

  /// Pre-cache a single image from context
  Future<void> precacheAsset(String assetPath) async {
    try {
      await precacheImage(AssetImage(assetPath), this);
    } catch (e) {
      debugPrint('Failed to precache $assetPath: $e');
    }
  }
}