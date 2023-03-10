import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:magveto_app/game/action_dialog.dart';
import 'package:magveto_app/game/actions/brethren/connection_tile.dart';
import 'package:magveto_app/graphics/index.dart';
import 'package:magveto_app/logic/index.dart';
import 'package:provider/provider.dart';

class BuildRoadDialog extends StatefulWidget {
  const BuildRoadDialog(BuildContext context, {Key? key}) : super(key: key);

  @override
  _BuildRoadDialogState createState() => _BuildRoadDialogState();
}

class _BuildRoadDialogState extends State<BuildRoadDialog> {
  // Only ever one connection can be selected
  Set<BrotherConnection> _selectedConnectionSet = {};
  List<BrotherConnection> _connections = [];

  ScrollController _scrollController = ScrollController();

  BrotherConnection get selectedConnection {
    if (_selectedConnectionSet.isEmpty) {
      return _connections.first;
    }
    return _selectedConnectionSet.single;
  }

  // Amounts of items used to build the road
  // TODO use records when available
  List<int> itemsToUse = [0, 0, 0, 0];
  List<int> itemsGotUsed = [0, 0, 0, 0];
  int roadsGotBuilt = 0;

  @override
  void initState() {
    super.initState();

    _connections = context
        .read<GameProvider>()
        .brotherConnections
        .where((element) =>
            element.hasTeam(context.read<GameProvider>().teamInPlay))
        .toList();

    // add an empty connection for teams that are not contained in any connection
    context
        .read<GameProvider>()
        .teams
        .where((element) =>
            !_connections.any((connection) => connection.hasTeam(element)) &&
            element != context.read<GameProvider>().teamInPlay)
        .forEach((element) {
      _connections.add(
        BrotherConnection(
          BrotherTeam(element),
          BrotherTeam(context.read<GameProvider>().teamInPlay),
        ),
      );
    });

    _connections.removeWhere((element) => element.isFinished);
  }

  void resolveItemsToUse() {
    var resolveResult = resolvePairs(itemsToUse);
    setState(() {
      itemsGotUsed = resolveResult.sublist(0, 4).toList();
      roadsGotBuilt = resolveResult[4];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ActionDialog(
      icon: Icon(Icons.add_road),
      title: "Út építése",
      heroTag: "build_road",
      child: Consumer<GameProvider>(builder: (context, game, child) {
        return Column(
          children: [
            if (_selectedConnectionSet.isEmpty)
              ActionSegmentTitle('Válaszd ki a kapcsolatot!'),
            FadingEdgeScrollView.fromSingleChildScrollView(
              shouldDisposeScrollController: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<BrotherConnection>(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context).colorScheme.primaryContainer;
                        }
                        return Color(0xffa8814c);
                      },
                    ),
                    side: MaterialStatePropertyAll<BorderSide?>(
                      BorderSide(
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  showSelectedIcon: false,
                  emptySelectionAllowed: true,
                  selected: _selectedConnectionSet,
                  onSelectionChanged: (value) {
                    setState(() {
                      _selectedConnectionSet = value;
                    });
                  },
                  segments: _connections
                      .map(
                        (e) => ButtonSegment<BrotherConnection>(
                          value: e,
                          label: BrotherConnectionTile(
                              connection: e, teamOfView: game.teamInPlay),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            // only display section if a connection is selected. use animated container to animate the height change
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutCubicEmphasized,
              height: _selectedConnectionSet.isEmpty ? 15 : 400,
              child: _selectedConnectionSet.isEmpty
                  ? Container()
                  : DefaultTabController(
                      length: (!selectedConnection.isFinished ? 1 : 0) +
                          (selectedConnection.canBeFinished ? 1 : 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TabBar(
                            tabs: [
                              if (!selectedConnection.isFinished)
                                Tab(text: "Építés"),
                              if (selectedConnection.canBeFinished)
                                Tab(text: "Befejezés"),
                            ],
                          ),
                          Container(
                            height: 350,
                            child: TabBarView(
                              children: [
                                if (!selectedConnection.isFinished)
                                  Column(
                                    children: [
                                      SizedBox(height: 10),
                                      ActionSegmentTitle(
                                          'Mennyit szeretnél felhasználni?'),
                                      ActionSegmentTitle(
                                        'Két különböző tárgy ér egy útelemet.',
                                        subtitle: true,
                                      ),
                                      SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'kívánt ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                                text: '(felhasznált)',
                                                style: TextStyle(
                                                    color: Colors.amberAccent)),
                                            TextSpan(text: ' / van nálad'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            height: 60,
                                            child: ItemWidget(
                                                type: ItemType.scripture),
                                          ),
                                          SizedBox(
                                            height: 60,
                                            child: ItemWidget(
                                                type: ItemType.prayer),
                                          ),
                                          SizedBox(
                                            height: 60,
                                            child: ItemWidget(
                                                type: ItemType.charity),
                                          ),
                                          SizedBox(
                                            height: 60,
                                            child: ItemWidget(
                                                type: ItemType.blessing),
                                          ),
                                        ],
                                      ),

                                      // display: amount used in bold, slash amount the user has
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '${itemsToUse[0]} ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text:
                                                        '(${itemsGotUsed[0]})',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .amberAccent)),
                                                TextSpan(
                                                    text:
                                                        ' / ${game.characterInPlay.inventory!.scripture}'),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '${itemsToUse[1]} ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text:
                                                        '(${itemsGotUsed[1]})',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .amberAccent)),
                                                TextSpan(
                                                    text:
                                                        ' / ${game.characterInPlay.inventory!.prayer}'),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '${itemsToUse[2]} ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text:
                                                        '(${itemsGotUsed[2]})',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .amberAccent)),
                                                TextSpan(
                                                    text:
                                                        ' / ${game.characterInPlay.inventory!.charity}'),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '${itemsToUse[3]} ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text:
                                                        '(${itemsGotUsed[3]})',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .amberAccent)),
                                                TextSpan(
                                                    text:
                                                        ' / ${game.characterInPlay.inventory!.blessing}'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // plus and minus buttons for each type. they appear as a single togglebutton with two sides
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ToggleButtons(
                                            constraints: BoxConstraints(
                                              minWidth: 30,
                                              minHeight: 30,
                                            ),
                                            // set selected if action is available
                                            isSelected: [
                                              itemsToUse[0] <
                                                  game.characterInPlay
                                                      .inventory!.scripture,
                                              itemsToUse[0] > 0,
                                            ],
                                            direction: Axis.vertical,
                                            children: [
                                              Icon(size: 15, Icons.add),
                                              Icon(size: 15, Icons.remove),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(99),
                                            color: Colors.white60,
                                            selectedColor: Colors.amber,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderColor: Colors.white38,
                                            selectedBorderColor: Colors.amber,
                                            onPressed: (index) {
                                              if (index == 0) {
                                                itemsToUse[0]++;
                                                itemsToUse[0] >
                                                        game
                                                            .characterInPlay
                                                            .inventory!
                                                            .scripture
                                                    ? itemsToUse[0] = game
                                                        .characterInPlay
                                                        .inventory!
                                                        .scripture
                                                    : itemsToUse[0];
                                              } else {
                                                itemsToUse[0]--;
                                                itemsToUse[0] < 0
                                                    ? itemsToUse[0] = 0
                                                    : itemsToUse[0];
                                              }
                                              resolveItemsToUse();
                                            },
                                          ),
                                          ToggleButtons(
                                            constraints: BoxConstraints(
                                              minWidth: 30,
                                              minHeight: 30,
                                            ),
                                            // set selected if action is available
                                            isSelected: [
                                              itemsToUse[1] <
                                                  game.characterInPlay
                                                      .inventory!.prayer,
                                              itemsToUse[1] > 0,
                                            ],
                                            direction: Axis.vertical,
                                            children: [
                                              Icon(size: 15, Icons.add),
                                              Icon(size: 15, Icons.remove),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(99),
                                            color: Colors.white60,
                                            selectedColor: Colors.amber,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderColor: Colors.white38,
                                            selectedBorderColor: Colors.amber,
                                            onPressed: (index) {
                                              if (index == 0) {
                                                itemsToUse[1]++;
                                                itemsToUse[1] >
                                                        game.characterInPlay
                                                            .inventory!.prayer
                                                    ? itemsToUse[1] = game
                                                        .characterInPlay
                                                        .inventory!
                                                        .prayer
                                                    : itemsToUse[1];
                                              } else {
                                                itemsToUse[1]--;
                                                itemsToUse[1] < 0
                                                    ? itemsToUse[1] = 0
                                                    : itemsToUse[1];
                                              }
                                              resolveItemsToUse();
                                            },
                                          ),
                                          ToggleButtons(
                                            constraints: BoxConstraints(
                                              minWidth: 30,
                                              minHeight: 30,
                                            ),
                                            // set selected if action is available
                                            isSelected: [
                                              itemsToUse[2] <
                                                  game.characterInPlay
                                                      .inventory!.charity,
                                              itemsToUse[2] > 0,
                                            ],
                                            direction: Axis.vertical,
                                            children: [
                                              Icon(size: 15, Icons.add),
                                              Icon(size: 15, Icons.remove),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(99),
                                            color: Colors.white60,
                                            selectedColor: Colors.amber,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderColor: Colors.white38,
                                            selectedBorderColor: Colors.amber,
                                            onPressed: (index) {
                                              if (index == 0) {
                                                itemsToUse[2]++;
                                                itemsToUse[2] >
                                                        game.characterInPlay
                                                            .inventory!.charity
                                                    ? itemsToUse[2] = game
                                                        .characterInPlay
                                                        .inventory!
                                                        .charity
                                                    : itemsToUse[2];
                                              } else {
                                                itemsToUse[2]--;
                                                itemsToUse[2] < 0
                                                    ? itemsToUse[2] = 0
                                                    : itemsToUse[2];
                                              }
                                              resolveItemsToUse();
                                            },
                                          ),
                                          ToggleButtons(
                                            constraints: BoxConstraints(
                                              minWidth: 30,
                                              minHeight: 30,
                                            ),
                                            // set selected if action is available
                                            isSelected: [
                                              itemsToUse[3] <
                                                  game.characterInPlay
                                                      .inventory!.blessing,
                                              itemsToUse[3] > 0,
                                            ],
                                            direction: Axis.vertical,
                                            children: [
                                              Icon(size: 15, Icons.add),
                                              Icon(size: 15, Icons.remove),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(99),
                                            color: Colors.white60,
                                            selectedColor: Colors.amber,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderColor: Colors.white38,
                                            selectedBorderColor: Colors.amber,
                                            onPressed: (index) {
                                              if (index == 0) {
                                                itemsToUse[3]++;
                                                itemsToUse[3] >
                                                        game.characterInPlay
                                                            .inventory!.blessing
                                                    ? itemsToUse[3] = game
                                                        .characterInPlay
                                                        .inventory!
                                                        .blessing
                                                    : itemsToUse[3];
                                              } else {
                                                itemsToUse[3]--;
                                                itemsToUse[3] < 0
                                                    ? itemsToUse[3] = 0
                                                    : itemsToUse[3];
                                              }
                                              resolveItemsToUse();
                                            },
                                          ),
                                        ],
                                      ),
                                      Divider(height: 25),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Eredmény: ",
                                              style: TextStyle(fontSize: 20)),
                                          SizedBox(
                                            height: 35,
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: RoadCountWidget(
                                                  color: game.teamInPlay.color,
                                                  count: roadsGotBuilt),
                                            ),
                                          ),
                                          Text(" db útelem",
                                              style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        height: 35,
                                        child: FilledButton(
                                          onPressed: roadsGotBuilt > 0
                                              ? () {
                                                  // create an inventory transaction that takes away the used items
                                                  // and use it on the current player
                                                  game.characterInPlay
                                                      .inventory!
                                                      .take(Inventory(
                                                          scripture:
                                                              itemsToUse[0],
                                                          prayer: itemsToUse[1],
                                                          charity:
                                                              itemsToUse[2],
                                                          blessing:
                                                              itemsToUse[3]));

                                                  // add the built roads to the current connection to the current team
                                                  selectedConnection.between
                                                      .firstWhere((element) =>
                                                          element.team ==
                                                          game.teamInPlay)
                                                      .roads += roadsGotBuilt;

                                                  // add the selected connection to game if it is not already there
                                                  if (!game.brotherConnections
                                                      .contains(
                                                          selectedConnection))
                                                    game.brotherConnections.add(
                                                        selectedConnection);

                                                  game.notify();
                                                  Navigator.pop(context);
                                                }
                                              : null,
                                          child: Text("Mehet!",
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                      ),
                                    ],
                                  ),
                                // TODO factor out to other file
                                // TODO make possible to choose which character givces the blessing
                                if (selectedConnection.canBeFinished)
                                  Column(
                                    children: [
                                      SizedBox(height: 40),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: selectedConnection.between
                                            .map((e) => SizedBox(
                                                    child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    e.team.idWidgetFor(null),
                                                    Transform.translate(
                                                      offset: Offset(15, 15),
                                                      child: SizedBox(
                                                          height: 40,
                                                          child: ItemWidget(
                                                              type: ItemType
                                                                  .blessing)),
                                                    )
                                                  ],
                                                )))
                                            .toList(),
                                      ),
                                      SizedBox(height: 40),
                                      ActionSegmentTitle('Készen álltok?'),
                                      ActionSegmentTitle(
                                        'Ha a játékpályán is elkészült az út, 1-1 áldás beadásával aktiválhatjátok.',
                                        subtitle: true,
                                      ),
                                      SizedBox(height: 30),
                                      SizedBox(
                                        height: 35,
                                        child: FilledButton(
                                          onPressed: (selectedConnection.teams
                                                  .every((t) => t.characters
                                                      .any((c) =>
                                                          c.inventory!
                                                              .blessing >
                                                          0)))
                                              ? () {
                                                  // take away a blessing from each team. take away the blessing from the first character that has it
                                                  selectedConnection.teams
                                                      .forEach((t) {
                                                    t.characters
                                                        .firstWhere((c) =>
                                                            c.inventory!
                                                                .blessing >
                                                            0)
                                                        .inventory!
                                                        .take(Inventory(
                                                            blessing: 1));
                                                  });

                                                  // set the connection to finished
                                                  selectedConnection
                                                      .isFinished = true;

                                                  game.notify();
                                                  Navigator.pop(context);
                                                }
                                              : null,
                                          child: Text("Mehet!",
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
