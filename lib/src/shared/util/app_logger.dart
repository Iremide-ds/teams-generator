import 'package:flutter/foundation.dart';

class AppLogger {
  // Private constructor
  AppLogger._();

  static AppLogger? _instance;

  // Factory constructor for singleton
  factory AppLogger() {
    _instance ??= AppLogger._();
    return _instance!;
  }

  // ANSI Color codes
  static const String _reset = '\x1B[0m';
  static const String _bold = '\x1B[1m';

  // Text colors
  // static const String _black = '\x1B[30m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';
  static const String _white = '\x1B[37m';

  // Background colors
  static const String _bgRed = '\x1B[41m';
  // static const String _bgYellow = '\x1B[43m';
  // static const String _bgBlue = '\x1B[44m';
  // static const String _bgCyan = '\x1B[46m';

  // Log levels with colors
  static const String _info = 'INFO';
  static const String _warning = 'WARNING';
  static const String _error = 'ERROR';
  static const String _debug = 'DEBUG';

  // Color mappings for different log levels
  String _getLogLevelColor(String level) {
    switch (level) {
      case _info:
        return '$_blue$_bold';
      case _warning:
        return '$_yellow$_bold';
      case _error:
        return '$_red$_bold';
      case _debug:
        return '$_green$_bold';
      default:
        return '$_white$_bold';
    }
  }

  String _getMessageColor(String level) {
    switch (level) {
      case _info:
        return _cyan;
      case _warning:
        return _yellow;
      case _error:
        return _red;
      case _debug:
        return _green;
      default:
        return _white;
    }
  }

  // Private method to format log messages
  String _formatMessage(String level, String message, [String? tag]) {
    final timestamp = DateTime.now().toIso8601String();
    final tagString = tag != null ? '[$tag] ' : '';

    if (kDebugMode) {
      // Colored format for debug mode
      final levelColor = _getLogLevelColor(level);
      final messageColor = _getMessageColor(level);
      final timestampColor = _magenta;
      final tagColor = _cyan;

      return '$timestampColor[$timestamp]$_reset $levelColor[$level]$_reset $tagColor$tagString$_reset$messageColor$message$_reset';
    } else {
      // Plain format for release mode
      return '[$timestamp] [$level] $tagString$message';
    }
  }

  // Info logging
  void info(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint(_formatMessage(_info, message, tag));
    }
  }

  // Warning logging
  void warning(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint(_formatMessage(_warning, message, tag));
    }
  }

  // Error logging
  void error(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint(_formatMessage(_error, message, tag));
    }
  }

  // Debug logging
  void debug(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint(_formatMessage(_debug, message, tag));
    }
  }

  // Generic log method with custom level
  void log(String level, String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint(_formatMessage(level.toUpperCase(), message, tag));
    }
  }

  void exception(Exception e, [StackTrace? stackTrace, String? context]) {
    final contextString = context != null ? ' Context: $context' : '';
    error('Exception: $e$contextString', 'EXCEPTION');
    if (stackTrace != null && kDebugMode) {
      // Color the stack trace in red for better visibility
      debugPrint('${_red}Stack trace: $stackTrace$_reset');
    }
  }

  void fatalError(Object e, [StackTrace? stackTrace, String? context]) {
    final contextString = context != null ? ' Context: $context' : '';

    if (kDebugMode) {
      // Use background red for fatal errors to make them stand out more
      final fatalMessage =
          '$_bgRed$_white$_bold FATAL ERROR $_reset $_red Exception: $e$contextString$_reset';
      debugPrint(fatalMessage);
    } else {
      error('FATAL ERROR - Exception: $e$contextString', 'FATAL');
    }

    if (stackTrace != null && kDebugMode) {
      debugPrint('$_bgRed${_white}Stack trace: $stackTrace$_reset');
    }
  }
}
