import 'package:flutter/material.dart';
import 'package:magveto_app/logic/index.dart';
import 'package:provider/provider.dart';

import '../../../../graphics/index.dart';
import '../../../action_dialog.dart';

class FinishRoadTab extends StatelessWidget {
  final RoadConnection selectedConnection;
  final TabController tabController;

  const FinishRoadTab({
    super.key,
    required this.selectedConnection,
    required this.tabController,
  });

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
          ActionSegmentTitle('K??szen ??lltok?'),
          ActionSegmentTitle(
            'Ha a j??t??kp??ly??n is elk??sz??lt az ??t, 1-1 ??ld??s bead??s??val aktiv??lhatj??tok.',
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
                    Text("Mehet, ??ssze??rt??nk!", style: TextStyle(fontSize: 20)),
              ),
            ),
            if (!hasBlessingToFinish(game))
              ActionSegmentTitle(
                'Nincs el??g ??ld??sotok, hogy befejezz??tek az utat.',
                subtitle: true,
              ),
            FilledButton.tonalIcon(
              onPressed: () => tabController.animateTo(0),
              label: Text("M??g ??p??tkez??nk..."),
              icon: Icon(Icons.arrow_back),
            ),
          ],
          if (!selectedConnection.canBeFinished) ...[
            ActionSegmentTitle(
              'Ezt az utat m??g nem fejezhetitek be.\nEgy utat csak akkor lehet befejezni, ha mindk??t csapat letett legal??bb egy elemet, ??s ??sszesen legal??bb 4 elem hossz?? az ??t.',
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
