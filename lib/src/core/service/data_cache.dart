import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams_gen/src/shared/model/group_of_players.dart';
import 'package:teams_gen/src/shared/model/player.dart';
import 'package:teams_gen/src/shared/util/app_logger.dart';

class DatabaseManager {
  // Private constructor
  DatabaseManager._();

  static DatabaseManager? _instance;
  static Completer<DatabaseManager>? _completer;

  // SharedPreferences instance
  SharedPreferences? _prefs;
  String? _connectionString;

  // Async factory method
  static Future<DatabaseManager> getInstance() async {
    if (_instance != null) {
      return _instance!;
    }

    if (_completer != null) {
      return _completer!.future;
    }

    _completer = Completer<DatabaseManager>();

    try {
      final instance = DatabaseManager._();
      await instance._initialize();
      _instance = instance;
      _completer!.complete(_instance!);
      return _instance!;
    } catch (e) {
      _completer!.completeError(e);
      _completer = null;
      rethrow;
    }
  }

  static DatabaseManager get instance => _instance!;

  AppLogger get _logger => AppLogger();

  bool _proceed() {
    if (_prefs == null) {
      throw StateError('DatabaseManager not initialized');
    }
    return true;
  }

  Future<void> _initialize() async {
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    // Load saved connection settings if any
    await _loadConnectionSettings();

    // Save connection info to SharedPreferences
    await _saveConnectionSettings();

    _logger.info('Database connected');
  }

  Future<void> _loadConnectionSettings() async {
    if (_prefs == null) return;

    // Load previous connection settings
    final lastConnection = _prefs!.getString('last_connection');
    final lastConnectedAt = _prefs!.getString('last_connected_at');

    if (lastConnection != null) {
      _logger.info('Previous connection: $lastConnection');
    }

    if (lastConnectedAt != null) {
      _logger.info('Last connected at: $lastConnectedAt');
    }
  }

  Future<void> _saveConnectionSettings() async {
    if (_prefs == null || _connectionString == null) return;

    // Save current connection settings
    await _prefs!.setString('last_connection', _connectionString!);
    await _prefs!.setString(
      'last_connected_at',
      DateTime.now().toIso8601String(),
    );
    await _prefs!.setBool('is_database_initialized', true);

    _logger.info('Connection settings saved to SharedPreferences');
  }

  List<String> fetchGroupIndexes() {
    _proceed();

    final result = _prefs!.getStringList('all_groups') ?? [];
    _logger.info('Groups index -> $result');

    return result;
  }

  List<String> fetchPlayerIndexes() {
    _proceed();

    final result = _prefs!.getStringList('all_players') ?? [];
    _logger.info('Players index -> $result');

    return result;
  }

  List<GroupOfPlayers> fetchSavedGroups() {
    final allGroups = fetchGroupIndexes();

    if (allGroups.isNotEmpty) {
      final groups = <GroupOfPlayers>[];

      for (var i = 0; i < allGroups.length; i++) {
        final currentIndex = allGroups[i];

        final result = _prefs!.getString(currentIndex);
        final parsedData = GroupOfPlayers.fromJson(result!, _instance!);

        groups.add(parsedData);
      }

      _logger.info('Saved group of players -> $groups');

      return groups;
    }

    return <GroupOfPlayers>[];
  }

  Player fetchSavedPlayer(String playerID) {
    _proceed();

    final playerRaw = _prefs!.getString('player_$playerID');
    final result = Player.fromJson(playerRaw!);

    _logger.info('Saved players -> $result');

    return result;
  }

  Future<void> removeGroup(GroupOfPlayers group) async {
    _proceed();

    final dbKey = 'group_${group.id}';
    for (var i in group.players) {
      await removePlayer(i);
    }

    final result = await _prefs!.remove(dbKey);
    if (result) {
      _logger.info('removed a group -> $group');

      final oldIndex = fetchGroupIndexes();
      _logger.info('Old group index -> $oldIndex');

      final newIndex = [...oldIndex..remove(dbKey)];
      _logger.info('New group index -> $newIndex');

      await _prefs!.setStringList('all_groups', newIndex);
    }
  }

  Future<void> removePlayer(Player player) async {
    _proceed();

    final dbKey = 'player_${player.id}';
    final result = await _prefs!.remove(dbKey);
    if (result) {
      _logger.info('Removed a player -> $player');

      final oldIndex = fetchPlayerIndexes();
      _logger.info('Old players index -> $oldIndex');

      final newIndex = [...oldIndex..remove(dbKey)];
      _logger.info('New players index -> $newIndex');

      await _prefs!.setStringList('all_players', newIndex);
    }
  }

  Future<void> saveGroup(GroupOfPlayers group) async {
    _proceed();

    final dbKey = 'group_${group.id}';

    for (var i in group.players) {
      await savePlayer(i);
    }
    final result = await _prefs!.setString(dbKey, group.toJson());
    if (result) {
      _logger.info('Saved a group -> $group');

      final existingIndex = fetchGroupIndexes();
      _logger.info('Existing index -> $existingIndex');

      final newIndex = <String>[];

      if (existingIndex.contains(dbKey)) {
        newIndex.addAll(existingIndex);
      } else {
        newIndex.addAll([...existingIndex, dbKey]);
      }
      _logger.info('New index -> $newIndex');

      await _prefs!.setStringList('all_groups', newIndex);
    }
  }

  Future<void> savePlayer(Player player) async {
    _proceed();

    final dbKey = 'player_${player.id}';
    final result = await _prefs!.setString(dbKey, player.toJson());
    if (result) {
      _logger.info('Saved a player -> $player');

      final existingIndex = fetchPlayerIndexes();
      _logger.info('Existing index -> $existingIndex');

      final newIndex = <String>[];

      if (existingIndex.contains(dbKey)) {
        newIndex.addAll(existingIndex);
      } else {
        newIndex.addAll([...existingIndex, dbKey]);
      }
      _logger.info('New index -> $newIndex');

      await _prefs!.setStringList('all_players', newIndex);
    }
  }

  // Reset singleton (useful for testing)
  static Future<void> reset() async {
    if (_instance?._prefs != null) {
      await _instance?._prefs?.clear();
    }
    _instance = null;
    _completer = null;
  }
}
