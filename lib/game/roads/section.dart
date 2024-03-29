import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/index.dart';
import '../action_dialog.dart';
import 'dialog/dialog.dart';
import 'road_tile.dart';

class RoadsSection extends StatelessWidget {
  const RoadsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO hide button if every possible connection is built and active
            Tooltip(
              preferBelow: false,
              message: game.characterInPlay.currentLocation!.type ==
                      LocationType.outpost
                  ? "Csak 2. (gyülekezeti ház) és 3. (templomos gyülekezet) szinten elérhető!\nKivéve útépítő karakterek."
                  : "",
              child: Hero(
                tag: "build_road",
                child: ElevatedButton.icon(
                  onPressed: game.characterInPlay.currentLocation!.type ==
                              LocationType.outpost &&
                          !(game.characterInPlay.hasTrait(Trait.freeRoad) !=
                              null)
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            ActionRoute(
                              builder: (context) => BuildRoadDialog(context),
                            ),
                          );
                        },
                  icon: Icon(Icons.add_road),
                  label: Text("Út építése"),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: game.teamInPlay.color, width: 3),
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primaryContainer),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(width: 5),
                    Image.asset(
                      'assets/item/brethren.png',
                      width: 50,
                      filterQuality: FilterQuality.medium,
                    ),
                    Center(
                        child: Text(
                      ":",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: game.teamInPlay.color),
                    )),
                    SizedBox(width: 8),
                    ...game.brotherConnections
                        .where((element) => element.hasTeam(game.teamInPlay))
                        .map((c) => RoadTileWidget(
                            connection: c, teamOfView: game.teamInPlay)),
                    if (!game.brotherConnections
                        .any((element) => element.hasTeam(game.teamInPlay)))
                      Center(
                        child: Text(
                          "Nincsenek\nTestvérgyülekezetek",
                          style: TextStyle(
                            color: Colors.white38,
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
