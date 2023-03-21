import 'package:flutter/material.dart';

import '../../../../logic/index.dart';
import '../../../action_dialog.dart';

class UpgradeLocationDialog extends StatelessWidget {
  const UpgradeLocationDialog(BuildContext context, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameProvider game = GameProvider.of(context);
    return ActionDialog(
        heroTag: "upgrade",
        title:
            game.characterInPlay.currentLocation!.type == LocationType.outpost
                ? "Gyülekezetplántálás"
                : "Templomépítés",
        icon: Icon(Icons.upgrade),
        child: Column(
          children: [
            Image.asset(
              game.characterInPlay.currentLocation!.type == LocationType.outpost
                  ? "assets/button/outpost/${game.teamInPlay.id}.png"
                  : "assets/button/community/${game.teamInPlay.id}.png",
              height: 100,
              filterQuality: FilterQuality.medium,
            ),
            SizedBox(height: 20),
            ActionSegmentTitle(game.characterInPlay.currentLocation!.type ==
                    LocationType.outpost
                ? "Három föld váltságot nyert, megalapíthatod a gyülekezetet!"
                : "A gyülekezetedben elindultak a szolgálatok, felépítheted a templomot!"),
            ActionSegmentTitle(
              game.characterInPlay.currentLocation!.type == LocationType.outpost
                  ? "Már csak egy áldáscsillagot kell beadnod."
                  : "A szolgálatokat és egy áldáscsillagot kell beadnod.",
              subtitle: true,
            ),
            SizedBox(height: 20),
            SizedBox(
                height: 65,
                child: game.characterInPlay.inventory!
                    .getCompareWithBlessingWidgetList(Inventory(blessing: 1))
                    .first),
            SizedBox(height: 20),
            FilledButton(
              onPressed: game.characterInPlay.inventory!
                      .canTake(Inventory(blessing: 1))
                  ? () {
                      game.characterInPlay.inventory!
                          .take(Inventory(blessing: 1));
                      if (game.locationInPlay.type == LocationType.outpost) {
                        game.locationInPlay.type = LocationType.community;
                      } else {
                        game.locationInPlay.type = LocationType.church;

                        // TODO character trait
                        int amountToTake = 3;
                        for (var i = 0;
                            i < 2 &&
                                game.locationInPlay.scriptureService > 0 &&
                                amountToTake > 0;
                            i++) {
                          game.locationInPlay.scriptureService--;
                          amountToTake--;
                        }
                        for (var i = 0;
                            i < 2 &&
                                game.locationInPlay.prayerService > 0 &&
                                amountToTake > 0;
                            i++) {
                          game.locationInPlay.prayerService--;
                          amountToTake--;
                        }
                        for (var i = 0;
                            i < 2 &&
                                game.locationInPlay.charityService > 0 &&
                                amountToTake > 0;
                            i++) {
                          game.locationInPlay.charityService--;
                          amountToTake--;
                        }
                      }
                      game.notify();
                      Navigator.pop(context);
                    }
                  : null,
              child: Text(
                "Mehet!",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
          ],
        ));
  }
}
