import 'package:logger/logger.dart';

/// Application-wide logging service
/// Provides structured logging with different levels for development and production
class AppLogger {
  AppLogger._();
  
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Log debug information (development only)
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log informational messages
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warnings (non-critical issues)
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log errors (critical issues)
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal errors (app-breaking issues)
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

/// Extension to add logging to any class
mixin LoggerMixin {
  void logDebug(String message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger.debug('[$runtimeType] $message', error, stackTrace);
  }

  void logInfo(String message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger.info('[$runtimeType] $message', error, stackTrace);
  }

  void logWarning(String message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger.warning('[$runtimeType] $message', error, stackTrace);
  }

  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger.error('[$runtimeType] $message', error, stackTrace);
  }

  void logFatal(String message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger.fatal('[$runtimeType] $message', error, stackTrace);
  }
}