import 'dart:convert';

import 'package:teams_gen/src/core/service/data_cache.dart';
import 'package:teams_gen/src/shared/model/dase_model.dart';
import 'package:teams_gen/src/shared/model/player.dart';

class GroupOfPlayers extends BaseModel {
  final List<Player> players;
  final String name;

  GroupOfPlayers({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.players,
    required this.name,
  });

  factory GroupOfPlayers.fromJson(String rawJson, DatabaseManager dbManager) {
    final json = jsonDecode(rawJson);

    final players = (json['players'] as List?)?.cast<String>() ?? [];
    final mappedPlayers = players.map((id) {
      return dbManager.fetchSavedPlayer(id);
    }).toList();

    return GroupOfPlayers(
      id: json['id'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      name: json['name'],
      players: mappedPlayers,
    );
  }

  @override
  GroupOfPlayers copyWith({
    DateTime? updatedAt,
    String? name,
    List<Player>? players,
  }) {
    return GroupOfPlayers(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      players: players ?? this.players,
      name: name ?? this.name,
    );
  }

  @override
  String toJson() {
    return jsonEncode({
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'name': name,
      'players': players.map((e) => e.id).toList(),
    });
  }

  @override
  String toString() {
    return 'GroupOfPlayers(id: $id, name: $name, players: $players)';
  }
}
