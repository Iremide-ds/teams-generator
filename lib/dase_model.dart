// Base class for models with auto-generated IDs
import 'dart:math' show Random;

abstract class BaseModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  BaseModel({String? id, DateTime? createdAt, DateTime? updatedAt})
    : id = id ?? _generateId(),
      createdAt = createdAt ?? DateTime.now(),
      updatedAt = updatedAt ?? DateTime.now();

  // Generate a unique ID (you can customize this method)
  static String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(99999);
    final uuid = _generateUUID();
    return '${timestamp.toRadixString(36)}-${random.toRadixString(36)}-$uuid';
  }

  // Alternative UUID-style generator
  static String _generateUUID() {
    final random = Random();
    final chars = '0123456789abcdef';
    String uuid = '';

    for (int i = 0; i < 32; i++) {
      if (i == 8 || i == 12 || i == 16 || i == 20) {
        uuid += '-';
      }
      uuid += chars[random.nextInt(chars.length)];
    }

    return uuid;
  }

  // Copy method for immutable updates
  BaseModel copyWith({DateTime? updatedAt});

  // Convert to JSON
  String toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '$runtimeType(id: $id)';
}
