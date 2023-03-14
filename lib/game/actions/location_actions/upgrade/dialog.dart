import 'package:flutter/material.dart';
import 'package:magveto_app/graphics/index.dart';
import 'package:provider/provider.dart';

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
              "Már csak egy áldáscsillagot kell beadnod.",
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
                      game.characterInPlay.currentLocation!.type ==
                              LocationType.outpost
                          ? game.characterInPlay.currentLocation!.type =
                              LocationType.community
                          : game.characterInPlay.currentLocation!.type =
                              LocationType.church;
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
