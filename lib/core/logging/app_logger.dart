import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

enum LogTag { network, auth, app }

abstract final class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 4,
      lineLength: 90,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kDebugMode ? Level.debug : Level.off,
  );

  static void debug(
    String message, {
    LogTag tag = LogTag.app,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;
    _logger.d(_format(tag, message), error: error, stackTrace: stackTrace);
  }

  static void info(String message, {LogTag tag = LogTag.app}) {
    if (!kDebugMode) return;
    _logger.i(_format(tag, message));
  }

  static void warning(
    String message, {
    LogTag tag = LogTag.app,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;
    _logger.w(_format(tag, message), error: error, stackTrace: stackTrace);
  }

  static void error(
    String message, {
    LogTag tag = LogTag.app,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;
    _logger.e(_format(tag, message), error: error, stackTrace: stackTrace);
  }

  static String _format(LogTag tag, String message) {
    return '[${_tagLabel(tag)}] $message';
  }

  static String _tagLabel(LogTag tag) {
    switch (tag) {
      case LogTag.network:
        return 'NETWORK';
      case LogTag.auth:
        return 'AUTH';
      case LogTag.app:
        return 'APP';
    }
  }
}
