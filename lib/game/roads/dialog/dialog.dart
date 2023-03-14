import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../logic/index.dart';
import '../../action_dialog.dart';
import '../road_tile.dart';
import 'tabs/build.dart';
import 'tabs/finish.dart';

class BuildRoadDialog extends StatefulWidget {
  const BuildRoadDialog(BuildContext context, {Key? key}) : super(key: key);

  @override
  _BuildRoadDialogState createState() => _BuildRoadDialogState();
}

class _BuildRoadDialogState extends State<BuildRoadDialog>
    with TickerProviderStateMixin {
  // Only ever one connection can be selected
  Set<RoadConnection> _selectedConnectionSet = {};
  List<RoadConnection> _connections = [];

  ScrollController segmentedButtonScrollController = ScrollController();
  late TabController tabController;

  RoadConnection get selectedConnection {
    if (_selectedConnectionSet.isEmpty) {
      return _connections.first;
    }
    return _selectedConnectionSet.single;
  }

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
        RoadConnection(
          TeamRoads(element),
          TeamRoads(context.read<GameProvider>().teamInPlay),
        ),
      );
    });

    _connections.removeWhere((element) => element.isFinished);

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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
            ActionSegmentTitle('Válaszd ki a kapcsolatot!'),
            FadingEdgeScrollView.fromSingleChildScrollView(
              shouldDisposeScrollController: true,
              child: SingleChildScrollView(
                controller: segmentedButtonScrollController,
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<RoadConnection>(
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
                        (e) => ButtonSegment<RoadConnection>(
                          value: e,
                          label: RoadTileWidget(
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
              decoration: null,
              child: _selectedConnectionSet.isEmpty
                  ? Container()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          controller: tabController,
                          tabs: [
                            Tab(text: "Építés"),
                            Tab(text: "Befejezés"),
                          ],
                        ),
                        Container(
                          height: 350,
                          child: TabBarView(
                            controller: tabController,
                            physics: BouncingScrollPhysics(
                                decelerationRate:
                                    ScrollDecelerationRate.normal),
                            children: [
                              BuildRoadTab(
                                  selectedConnection: selectedConnection,
                                  tabController: tabController),
                              FinishRoadTab(
                                selectedConnection: selectedConnection,
                                tabController: tabController,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      }),
    );
  }
}
