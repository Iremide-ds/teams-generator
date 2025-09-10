import 'package:flutter/material.dart';
import 'package:teams_gen/generated_teams_list.dart';
import 'package:teams_gen/group_of_players.dart';
import 'package:teams_gen/player.dart';
import 'package:teams_gen/shared.dart';

class CreateGroupFormWidget extends StatefulWidget {
  const CreateGroupFormWidget({super.key, this.existingGroup});

  final GroupOfPlayers? existingGroup;

  @override
  State<CreateGroupFormWidget> createState() => _CreateGroupFormWidgetState();
}

class _CreateGroupFormWidgetState extends State<CreateGroupFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _groupName = TextEditingController();
  final _playersPerTeam = TextEditingController();
  final _players = <(String?, TextEditingController)>[
    (null, TextEditingController()),
    (null, TextEditingController()),
    (null, TextEditingController()),
    (null, TextEditingController()),
  ];
  final _favorePlayers = <int>{};

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Create a group')),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: TextFormField(
                  validator: notEmpty,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _groupName,
                  decoration: InputDecoration(
                    labelText: 'Group Name',
                    hintText: 'Enter a unique group name',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Players (${_players.length} in total)'),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 24),
                  child: Column(
                    children: List.generate(_players.length, (index) {
                      final e = _players[index];

                      return PlayerField(
                        controller: e.$2,
                        index: index,
                        isFavored: _favorePlayers.contains(index),
                        onTapFav: (index) {
                          final contains = _favorePlayers.contains(index);
                          if (contains) {
                            _favorePlayers.remove(index);
                          } else {
                            _favorePlayers.add(index);
                          }
                          setState(() {});
                        },
                        onTapClose: (index) {
                          if (_players.length <= 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Minimum of 4 players in a group',
                                ),
                              ),
                            );

                            return;
                          }

                          _players.removeAt(index);
                          _favorePlayers.remove(index);

                          final newFavoredPlayers = <int>{};
                          for (var e in _favorePlayers) {
                            if (e > index) {
                              newFavoredPlayers.add(e - 1);
                            } else {
                              newFavoredPlayers.add(e);
                            }
                          }

                          _favorePlayers.clear();
                          _favorePlayers.addAll(newFavoredPlayers);

                          setState(() {});
                        },
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _players.add((null, TextEditingController()));
            setState(() {});
          },
          child: Center(child: Icon(Icons.add)),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          child: FilledButton(
            onPressed: _proceed,
            style: FilledButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Proceed'),
          ),
        ),
      ),
    );
  }

  void _init() {
    if (widget.existingGroup != null) {
      final data = widget.existingGroup!;

      _groupName.text = data.name;
      _players.clear();
      _players.addAll(
        data.players.map((e) {
          return (e.id, TextEditingController(text: e.name));
        }),
      );

      _favorePlayers.clear();
      for (var i in data.players) {
        if (i.isFavored) {
          _favorePlayers.add(data.players.indexOf(i));
        }
      }
    }
  }

  Future<String?> _numberOfPlayersInATeam() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Team size'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How many players per team?'),
              const SizedBox(height: 10),
              Form(
                key: _formKey2,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: [OnlyIntInputFormatter()],
                  controller: _playersPerTeam,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field can not be empty';
                    }

                    final numberValue = num.tryParse(value)?.toInt() ?? 0;
                    if (numberValue == 0) {
                      return 'Number is too low';
                    }
                    if (numberValue > _players.length) {
                      return 'Only ${_players.length} players available';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Number of players',
                    hintText: 'Number of players in a team',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey2.currentState?.validate() == true) {
                  Navigator.of(context).pop(_playersPerTeam.text);
                }
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _promptForOveride() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Create new group?'),
          content: Text(
            'Create a new group or edit the existing group named `${widget.existingGroup?.name}`.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Create new'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Edit existing'),
            ),
          ],
        );
      },
    );
  }

  void _proceed() async {
    if (_formKey.currentState?.validate() != true) return;

    final proceedResult = await _numberOfPlayersInATeam();
    if (proceedResult == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Enter a valid number!')));
      return;
    }

    var shouldOverride = false;
    if (widget.existingGroup != null) {
      final result = await _promptForOveride();
      if (result != null) {
        shouldOverride = result;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select an option!')));
        return;
      }
    }

    List<Player> generatePlayers(List<(String?, TextEditingController)> data) {
      return List.generate(data.length, (index) {
        final e = data[index];

        return Player(
          name: e.$2.text,
          isFavored: _favorePlayers.contains(index),
        );
      });
    }

    final existingPlayers = widget.existingGroup?.players.where((e) {
      return _players.map((e) => e.$1).where((e) => e != null).contains(e.id);
    });
    final newPlayers = _players.where((e) => e.$1 == null).toList();

    final group = shouldOverride
        ? widget.existingGroup!.copyWith(
            name: _groupName.text,
            players: [...?existingPlayers, ...generatePlayers(newPlayers)],
          )
        : GroupOfPlayers(
            players: generatePlayers(_players),
            name: _groupName.text.isEmpty
                ? 'Group (${DateTime.now().millisecondsSinceEpoch})'
                : _groupName.text,
          );

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) {
          return GeneratedTeamsListPage(
            group: group,
            special: _favorePlayers,
            playersPerTeam: num.parse(_playersPerTeam.text).toInt(),
          );
        },
      ),
    );

    if (result == true) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class PlayerField extends StatelessWidget {
  const PlayerField({
    super.key,
    required this.controller,
    required this.index,
    required this.isFavored,
    required this.onTapFav,
    required this.onTapClose,
  });

  final TextEditingController controller;
  final int index;

  final bool isFavored;

  final void Function(int index) onTapFav;
  final void Function(int index) onTapClose;

  @override
  Widget build(BuildContext context) {
    final playerNumber = index + 1;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$playerNumber'),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              child: TextFormField(
                validator: notEmpty,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Player name',
                  hintText: 'e.g Shola',
                ),
              ),
            ),
          ),
          // const SizedBox(width: 4),
          IconButton(
            onPressed: () {
              onTapFav(index);
            },
            icon: Icon(isFavored ? Icons.favorite : Icons.favorite_outline),
          ),
          CloseButton(
            onPressed: () {
              onTapClose(index);
            },
          ),
        ],
      ),
    );
  }
}
