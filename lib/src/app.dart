import 'package:flutter/material.dart';
import 'package:teams_gen/create_group.dart';
import 'package:teams_gen/src/core/service/data_cache.dart';
import 'package:teams_gen/src/shared/model/group_of_players.dart';
import 'package:teams_gen/src/shared/shared.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final DatabaseManager _dbManager;

  final List<GroupOfPlayers> _groups = [];

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FC Teams'),
        actions: [
          Visibility(
            visible: _groups.isNotEmpty,
            child: TextButton(
              onPressed: () {
                DatabaseManager.reset();
              },
              child: Text('Delete all'),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 750),
            child: Stack(
              children: [
                if (value)
                  Container(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(color: Colors.black45),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                _groups.isEmpty
                    ? Center(child: Text('No teams avaialble!'))
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          final currentIndex = _groups[index];

                          return InkWell(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CreateGroupFormWidget(
                                      existingGroup: currentIndex,
                                    );
                                  },
                                ),
                              );
                              await _refresh();
                            },
                            child: Ink(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      toggleLoadingOn();
                                      await _dbManager.removeGroup(
                                        currentIndex,
                                      );
                                      toggleLoadingOff();
                                      _refresh();
                                    },
                                    icon: Icon(Icons.delete),
                                  ),

                                  Expanded(child: Text(currentIndex.name)),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.keyboard_arrow_right),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 8);
                        },
                        itemCount: _groups.length,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 24,
                        ),
                      ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateGroupFormWidget(),
            ),
          );
          await _refresh();
        },
        child: Center(child: Icon(Icons.add)),
      ),
    );
  }

  void _init() async {
    isLoading.value = true;

    await _initDB();
    // await DatabaseManager.reset();
    _fetchSavedData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });

    isLoading.value = false;
  }

  Future<void> _refresh() async {
    isLoading.value = true;

    _fetchSavedData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });

    isLoading.value = false;
  }

  Future<void> _initDB() async {
    _dbManager = await DatabaseManager.getInstance();
  }

  void _fetchSavedData() {
    _groups.clear();
    _groups.addAll(_dbManager.fetchSavedGroups());
  }
}
