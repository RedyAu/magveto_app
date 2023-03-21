import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../graphics/index.dart';
import '../../../../logic/index.dart';
import '../../../action_dialog.dart';

class FinishRoadTab extends StatelessWidget {
  final RoadConnection selectedConnection;
  final TabController tabController;

  const FinishRoadTab({
    super.key,
    required this.selectedConnection,
    required this.tabController,
  });

  // TODO only allow finish if all parties minimum community

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      return Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      game.teamInPlay.idWidgetFor(game.characterInPlay),
                      Transform.translate(
                        offset: Offset(20, 20),
                        child: SizedBox(
                          height: 40,
                          child: Opacity(
                            opacity: game.characterInPlay.inventory!.blessing > 0
                                ? 1
                                : 0.5,
                            child: ItemWidget(type: ItemType.blessing),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      selectedConnection.teams
                          .firstWhere((element) => element != game.teamInPlay)
                          .idWidgetFor(null),
                      Transform.translate(
                        offset: Offset(20, 20),
                        child: SizedBox(
                          height: 40,
                          child: Opacity(
                            opacity: selectedConnection.teams
                                        .firstWhere((element) =>
                                            element != game.teamInPlay)
                                        .characters
                                        .first
                                        .inventory!
                                        .blessing >
                                    0
                                ? 1
                                : 0.5,
                            child: ItemWidget(type: ItemType.blessing),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          ActionSegmentTitle('Készen álltok?'),
          ActionSegmentTitle(
            'Ha a játékpályán is elkészült az út, 1-1 áldás beadásával aktiválhatjátok.',
            subtitle: true,
          ),
          SizedBox(height: 30),
          if (selectedConnection.canBeFinished) ...[
            SizedBox(
              height: 35,
              child: FilledButton(
                onPressed: hasBlessingToFinish(game)
                    ? () {
                        // take away a blessing from each team. take away the blessing from the first character that has it
                        selectedConnection.teams.forEach((t) {
                          t.characters
                              .firstWhere((c) => c.inventory!.blessing > 0)
                              .inventory!
                              .take(Inventory(blessing: 1));
                        });

                        // set the connection to finished
                        selectedConnection.isFinished = true;

                        GameProvider.of(context).notify();
                        Navigator.pop(context);
                      }
                    : null,
                child:
                    Text("Mehet, összeértünk!", style: TextStyle(fontSize: 20)),
              ),
            ),
            if (!hasBlessingToFinish(game))
              ActionSegmentTitle(
                'Nincs elég áldásotok, hogy befejezzétek az utat.',
                subtitle: true,
              ),
            FilledButton.tonalIcon(
              onPressed: () => tabController.animateTo(0),
              label: Text("Még építkezünk..."),
              icon: Icon(Icons.arrow_back),
            ),
          ],
          if (!selectedConnection.canBeFinished) ...[
            ActionSegmentTitle(
              'Ezt az utat még nem fejezhetitek be.\nEgy utat csak akkor lehet befejezni, ha mindkét csapat letett legalább egy elemet, és összesen legalább 4 elem hosszú az út.',
              subtitle: true,
            ),
            SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: () => tabController.animateTo(0),
              label: Text("Vissza"),
              icon: Icon(Icons.arrow_back),
            ),
          ],
        ],
      );
    });
  }

  bool hasBlessingToFinish(GameProvider game) {
    Team otherTeam = selectedConnection.teams
        .firstWhere((element) => element != game.teamInPlay);

    return game.characterInPlay.inventory!.blessing > 0 &&
        otherTeam.characters.any((c) => c.inventory!.blessing > 0);
  }
}
