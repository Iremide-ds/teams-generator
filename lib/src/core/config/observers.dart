import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class RiverpodLogger extends ProviderObserver {
  const RiverpodLogger();

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (kDebugMode) {
      developer.log(
        '🟢 PROVIDER ADDED: ${context.provider.name ?? context.provider.runtimeType}',
        name: 'Riverpod',
        level: 800, // Fine level
      );
    }
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (kDebugMode) {
      developer.log(
        '🔄 PROVIDER UPDATED: ${context.provider.name ?? context.provider.runtimeType}\n'
        'Previous: ${_formatValue(previousValue)}\n'
        'New: ${_formatValue(newValue)}',
        name: 'Riverpod',
        level: 700, // Info level
      );
    }
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    if (kDebugMode) {
      developer.log(
        '🔴 PROVIDER DISPOSED: ${context.provider.name ?? context.provider.runtimeType}',
        name: 'Riverpod',
        level: 800, // Fine level
      );
    }
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    if (kDebugMode) {
      developer.log(
        '❌ PROVIDER ERROR: ${context.provider.name ?? context.provider.runtimeType}\n'
        'Error: $error\n'
        'StackTrace: $stackTrace',
        name: 'Riverpod',
        level: 1000, // Severe level
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Formats values for logging in a readable way
  String _formatValue(Object? value) {
    if (value == null) return 'null';
    if (value is String) return '"$value"';
    if (value is Map) return 'Map(${value.length} entries)';
    if (value is List) return 'List(${value.length} items)';
    if (value is Set) return 'Set(${value.length} items)';
    if (value is Iterable) return 'Iterable(${value.length} items)';

    // For complex objects, show their type and some basic info
    final type = value.runtimeType.toString();
    if (value.toString() == type) {
      return type;
    }

    // Truncate long strings
    final stringValue = value.toString();
    if (stringValue.length > 100) {
      return '${stringValue.substring(0, 100)}...';
    }

    return stringValue;
  }
}
