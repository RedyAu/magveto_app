import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magveto_app/graphics/background.dart';
import 'package:provider/provider.dart';

import '../game/screen.dart';
import '../logic/index.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen>
    with SingleTickerProviderStateMixin {
  List<Player> players = [];
  int allPlayersCount = 0;
  late TabController tabController;
  late TextEditingController newPlayerNameController;
  late FocusNode newPlayerNameFocusNode;
  bool teamsReady = false;
  List<Team> teams = [];
  late final List<Team> defaultTeams;

  @override
  void initState() {
    teams = [];
    defaultTeams = getDefaultTeams();
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    newPlayerNameController = TextEditingController();
    newPlayerNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    tabController.dispose();
    newPlayerNameController.dispose();
    newPlayerNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Új játék'),
      ),
      body: MagvetoBackground(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  // Players
                  Card(
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "Játékosok hozzáadása",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: players.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(players[index].name),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          players.removeAt(index);
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (players.length < 3)
                              Text(
                                  "Adj hozzá még legalább ${3 - players.length} játékost az indításhoz!"),
                            if (players.length < 12)
                              Card(
                                elevation: 10,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: TextField(
                                            focusNode: newPlayerNameFocusNode,
                                            autofocus: true,
                                            controller: newPlayerNameController,
                                            decoration: const InputDecoration(
                                              labelText: "Játékos neve",
                                            ),
                                            onChanged: (_) => setState(() {}),
                                            onSubmitted: (value) =>
                                                setState(() {
                                              if (value.isEmpty) return;
                                              players.add(Player(value));
                                              newPlayerNameController.clear();
                                              newPlayerNameFocusNode
                                                  .requestFocus();
                                            }),
                                          ),
                                        ),
                                      ),
                                      // yellow and round add button
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        onPressed:
                                            newPlayerNameController.text.isEmpty
                                                ? null
                                                : () {
                                                    setState(() {
                                                      players.add(Player(
                                                          newPlayerNameController
                                                              .text));
                                                      newPlayerNameController
                                                          .clear();
                                                      newPlayerNameFocusNode
                                                          .requestFocus();
                                                    });
                                                  },
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.done),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          onPressed: () =>
                                              newPlayerNameFocusNode
                                                  .nextFocus())
                                    ],
                                  ),
                                ),
                              ),
                            if (players.length >= 12)
                              Text("Maximum 12 játékost adhatsz hozzá!"),
                          ],
                        ),
                      )),
                  // Choose teams
                  Card(
                    margin: EdgeInsets.all(8),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Csapatok kiválasztása",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 15, right: 8, left: 8),
                        child: Text(
                          "Válassz ki ${getMinimumTeamsCount(players.length)}-${getMaximumTeamsCount(players.length)} csapatot a játékhoz!\nA csapatokhoz a következő lépésben rendelhetsz majd játékosokat.",
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: defaultTeams.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              elevation:
                                  teams.contains(defaultTeams[index]) ? 10 : 0,
                              child: ListTile(
                                leading: Switch(
                                  value: teams.contains(defaultTeams[index]),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        teams.add(defaultTeams[index]);
                                      } else {
                                        teams.remove(defaultTeams[index]);
                                      }
                                    });
                                  },
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CharacterTile(
                                      defaultTeams[index],
                                      defaultTeams[index].characters[0],
                                    ),
                                    CharacterTile(
                                      defaultTeams[index],
                                      defaultTeams[index].characters[1],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ]),
                  ),

                  // Set up
                  Card(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              "Csapatok beállítása",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 15, right: 8, left: 8),
                            child: Text(
                              "Rendeld hozzá magatokat csapatokhoz!\nHúzd a neveket a csapatokra, hogy hozzárendeld őket.",
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // wrap of draggable name chips
                          Wrap(
                            children: players
                                .map(
                                  (player) => Draggable(
                                    data: player,
                                    child: nameCard(player.name),
                                    childWhenDragging:
                                        nameCard(player.name, true),
                                    feedback: nameCard(player.name),
                                  ),
                                )
                                .toList(),
                          ),
                          if (players.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 50,
                                  child: Icon(Icons.arrow_downward),
                                ),
                                // only display the shuffle button if there were no player assignments yet
                                if (players.length == allPlayersCount)
                                  FilledButton(
                                    onPressed: () {
                                      setState(() {
                                        players.shuffle();
                                        // go trough players. assign them to random teams that are empty. if no teams are empty, assign them to teams that have only one player. using playerCount to keep track of how many players are assigned to a team
                                        for (var player in players) {
                                          // get list of empty teams
                                          var emptyTeams = teams
                                              .where((t) => t.playerCount == 0)
                                              .toList();
                                          if (emptyTeams.isNotEmpty) {
                                            emptyTeams[Random()
                                                    .nextInt(emptyTeams.length)]
                                                .characters[0]
                                                .player = player;
                                          } else {
                                            // get list of teams with only one player
                                            var singlePlayerTeams = teams
                                                .where(
                                                    (t) => t.playerCount == 1)
                                                .toList();
                                            if (singlePlayerTeams.isNotEmpty) {
                                              singlePlayerTeams[Random()
                                                      .nextInt(singlePlayerTeams
                                                          .length)]
                                                  .characters[1]
                                                  .player = player;
                                            }
                                          }
                                        }
                                        players.clear();
                                      });
                                    },
                                    child: Text("Keverj!"),
                                  )
                              ],
                            ),
                          Expanded(
                              child: ListView.builder(
                            itemCount: teams.length,
                            itemBuilder: (context, index) {
                              return DragTarget<Player>(
                                onWillAccept: (candidateData) {
                                  if (teams[index].playerCount >= 2)
                                    return false;
                                  return true;
                                },
                                onAccept: (e) {
                                  setState(() {
                                    if (teams[index].characters[0].player ==
                                        null)
                                      teams[index].characters[0].player = e;
                                    else
                                      teams[index].characters[1].player = e;
                                    players.remove(e);
                                  });
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    elevation: 5,
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CharacterTile(
                                            teams[index],
                                            teams[index].characters[0],
                                            trailing: (teams[index]
                                                        .characters[0]
                                                        .player !=
                                                    null)
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      nameCard(teams[index]
                                                          .characters[0]
                                                          .player!
                                                          .name),
                                                      IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          setState(() {
                                                            players.add(teams[
                                                                    index]
                                                                .characters[0]
                                                                .player!);
                                                            teams[index]
                                                                .characters[0]
                                                                .player = null;
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  )
                                                : null,
                                          ),
                                          CharacterTile(
                                            teams[index],
                                            teams[index].characters[1],
                                            trailing: (teams[index]
                                                        .characters[1]
                                                        .player !=
                                                    null)
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      nameCard(teams[index]
                                                          .characters[1]
                                                          .player!
                                                          .name),
                                                      IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          setState(() {
                                                            players.add(teams[
                                                                    index]
                                                                .characters[1]
                                                                .player!);
                                                            teams[index]
                                                                .characters[1]
                                                                .player = null;
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  )
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ))
                        ],
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TabPageSelector(
                controller: tabController,
                color: Colors.grey[500],
                selectedColor: Theme.of(context).colorScheme.primary,
                borderStyle: BorderStyle.none,
                indicatorSize: 15,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 5,
          child: () {
            switch (tabController.index) {
              case 0:
                return ElevatedButton(
                    onPressed: players.length < 3
                        ? null
                        : () {
                            tabController.animateTo(1);
                            setState(() {});
                          },
                    child: const Text(
                      "Tovább",
                      style: TextStyle(fontSize: 20),
                    ));
              case 1:
                return ElevatedButton(
                    onPressed: (teams.length <
                                getMinimumTeamsCount(players.length) ||
                            teams.length > getMaximumTeamsCount(players.length))
                        ? null
                        : () {
                            tabController.animateTo(2);
                            setState(() {
                              allPlayersCount = players.length;
                            });
                          },
                    child: const Text(
                      "Tovább",
                      style: TextStyle(fontSize: 20),
                    ));
              case 2:
                return Consumer<GameProvider>(builder: (context, game, child) {
                  return FilledButton(
                    onPressed: (players.isEmpty &&
                            teams.every((t) => t.playerCount > 0))
                        ? () {
                            teams.sort((a, b) => a.id.compareTo(b.id));
                            // for teams that dont have a second player, put the first characters player to the second character as well
                            for (var team in teams) {
                              if (team.characters[1].player == null) {
                                team.characters[1].player =
                                    team.characters[0].player;
                              }
                            }
                            game.startGame(teams);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GameScreen()));
                          }
                        : null,
                    child: const Text(
                      "Játék indítása",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                });
              default:
            }
          }()),
    );
  }
}

Widget nameCard(String name, [bool isDragging = false]) {
  return Card(
    elevation: isDragging ? 0 : 5,
    color: Colors.grey[700],
    margin: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
    child: Padding(padding: const EdgeInsets.all(8.0), child: Text(name)),
  );
}

class CharacterTile extends StatelessWidget {
  final Team team;
  final Character character;
  final Widget? trailing;

  const CharacterTile(
    this.team,
    this.character, {
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: team.idWidgetFor(character),
        title: Text(
          character.name,
        ),
        trailing: trailing);
  }
}

int getMinimumTeamsCount(int playersCount) {
  if (playersCount < 3) return 99;
  if (playersCount < 6) return 3;
  return (playersCount / 2).ceil();
}

int getMaximumTeamsCount(int playersCount) {
  if (playersCount < 3) return 0;
  if (playersCount <= 6) return playersCount;
  return 6;
}
