import 'dart:math';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teams_gen/src/core/service/data_cache.dart';
import 'package:teams_gen/src/shared/model/group_of_players.dart';

class GeneratedTeamsListPage extends StatefulWidget {
  const GeneratedTeamsListPage({
    required this.group,
    super.key,
    required this.special,
    required this.playersPerTeam,
  });

  final GroupOfPlayers group;
  final Set<int> special;

  final int playersPerTeam;

  @override
  State<GeneratedTeamsListPage> createState() => _GeneratedTeamsListPageState();
}

class _GeneratedTeamsListPageState extends State<GeneratedTeamsListPage> {
  final List<List<String>> _teams = [];

  @override
  void initState() {
    super.initState();

    _proceedToGenerateTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated teams'),
        actions: [
          IconButton(onPressed: () => _save(), icon: Icon(Icons.save)),
          IconButton(
            onPressed: () async {
              await _save();

              SharePlus.instance.share(
                ShareParams(text: _formatTeamsForSharing()),
              );
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          _proceedToGenerateTeams();
        },
        child: ListView.separated(
          itemBuilder: (context, index) {
            final currentIndex = _teams[index];
            final teamCount = index + 1;

            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Team $teamCount'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: currentIndex.map((e) {
                      return ActionChip(label: Text(e));
                    }).toList(),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 8);
          },
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 24),
          itemCount: _teams.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _save();
          Navigator.of(context).pop(true);
        },
        child: Center(child: Icon(Icons.done)),
      ),
    );
  }

  Future<void> _save() async {
    await DatabaseManager.instance.saveGroup(widget.group);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Saved!')));
  }

  void _proceedToGenerateTeams() {
    final playerNames = widget.group.players.map((e) {
      return e.name;
    }).toList();
    final specialPlayers =
        List.generate(widget.special.length, (index) {
          final currentIndex = widget.special.elementAt(index);

          return widget.group.players[currentIndex];
        }).map((e) {
          return e.name;
        }).toList();

    final results = _generateTeams2(
      playerNames,
      specialPlayers,
      widget.playersPerTeam,
    );

    _teams.clear();
    _teams.addAll(results);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  List<List<String>> _generateTeams2(
    List<String> players,
    List<String> specialPlayers,

    int teamSize,
  ) {
    final numTeamsRaw = players.length % teamSize;
    final numTeams = numTeamsRaw == 0
        ? (players.length / teamSize).toInt()
        : (players.length / teamSize).round();

    final random = Random(DateTime.now().millisecondsSinceEpoch);
    final teams = List.generate(numTeams, (_) => <String>[]);

    final shuffledSpecials = List<String>.from(specialPlayers)..shuffle(random);
    for (var i = 0; i < shuffledSpecials.length; i++) {
      if (numTeams > i) {
        teams[i].add(shuffledSpecials[i]);
        continue;
      }

      final randomIndex = random.nextInt(numTeams);
      teams[randomIndex].add(shuffledSpecials[i]);
    }

    final regularPlayers = players
        .where((p) => !specialPlayers.contains(p))
        .toList();
    regularPlayers.shuffle(random);
    for (var i = 0; i < regularPlayers.length; i++) {
      if (i < numTeams) {
        if (teams[i].length >= teamSize) {
          // Find a team that still has space
          var targetTeam = teams.indexWhere((team) => team.length < teamSize);
          if (targetTeam != -1) {
            teams[targetTeam].add(regularPlayers[i]);
          } else {
            // All teams are full, distribute to random team (overflow case)
            final randomIndex = random.nextInt(numTeams);
            teams[randomIndex].add(regularPlayers[i]);
          }
        } else {
          teams[i].add(regularPlayers[i]);
        }
        continue;
      } else {
        // For remaining players, find a team with space or distribute randomly
        var availableTeam = teams.indexWhere((team) => team.length < teamSize);
        if (availableTeam != -1) {
          teams[availableTeam].add(regularPlayers[i]);
        } else {
          // All teams are full, distribute randomly (overflow case)
          final randomIndex = random.nextInt(numTeams);
          teams[randomIndex].add(regularPlayers[i]);
        }
      }
    }

    return teams;
  }

  String _formatTeamsForSharing() {
    final teams = List<List<String>>.from(_teams);

    if (teams.isEmpty) {
      return "No teams generated.";
    }

    final buffer = StringBuffer();
    buffer.writeln("🏆 TEAM ASSIGNMENTS 🏆");
    buffer.writeln("=" * 30);
    buffer.writeln();

    for (int i = 0; i < teams.length; i++) {
      final teamNumber = i + 1;
      final playerCount = teams[i].length;

      buffer.writeln("Team $teamNumber ($playerCount players):");
      buffer.writeln("─" * 20);

      if (teams[i].isEmpty) {
        buffer.writeln("  (No players assigned)");
      } else {
        for (int j = 0; j < teams[i].length; j++) {
          buffer.writeln("  ${j + 1}. ${teams[i][j]}");
        }
      }

      if (i < teams.length - 1) {
        buffer.writeln();
      }
    }

    buffer.writeln();
    buffer.writeln("=" * 30);
    buffer.writeln("Total Teams: ${teams.length}");
    buffer.writeln(
      "Total Players: ${teams.fold(0, (sum, team) => sum + team.length)}",
    );

    return buffer.toString();
  }
}
