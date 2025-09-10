import 'dart:convert';

import 'package:teams_gen/dase_model.dart';

class Player extends BaseModel {
  final String name;
  final bool isFavored;

  Player({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.name,
    this.isFavored = false,
  });

  // Factory constructor from JSON
  factory Player.fromJson(String rawJson) {
    final json = jsonDecode(rawJson);

    return Player(
      id: json['id'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      name: json['name'],
      isFavored: json['isFavored'] ?? true,
    );
  }

  @override
  Player copyWith({String? name, bool? isFavored, DateTime? updatedAt}) {
    return Player(
      id: id, // Keep the same ID
      createdAt: createdAt, // Keep original creation time
      updatedAt: updatedAt ?? DateTime.now(),
      name: name ?? this.name,
      isFavored: isFavored ?? this.isFavored,
    );
  }

  @override
  String toJson() {
    return jsonEncode({
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'name': name,
      'isFavored': isFavored,
    });
  }

  @override
  String toString() {
    return 'Player(id: $id, name: $name, isFavored: $isFavored)';
  }
}
