import 'package:flutter/material.dart';
import 'package:magveto_app/game/action_dialog.dart';
import 'package:magveto_app/game/actions/location_actions/redeem/button.dart';
import 'package:magveto_app/game/actions/location_actions/rim/button.dart';
import 'package:magveto_app/game/actions/location_actions/service/button.dart';
import 'package:magveto_app/game/actions/location_actions/upgrade/button.dart';
import 'package:magveto_app/game/actions/location_actions/upgrade/dialog.dart';
import 'package:provider/provider.dart';

import '../../../logic/index.dart';

class LocationActionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (game.locationInPlay.type == LocationType.outpost)
            if (!game.locationInPlay.isAllRedeemed) ...[
              Expanded(child: RedeemButton())
            ] else ...[
              Expanded(child: UpgradeLocationButton())
            ]
          else if (game.locationInPlay.type == LocationType.community) ...[
            Expanded(child: StartServiceButton()),
            if (game.locationInPlay.isServicesReady)
              Expanded(child: UpgradeLocationButton()),
            RimButton()
          ] else if (game.locationInPlay.type == LocationType.church) ...[
            Expanded(child: StartServiceButton()),
            RimButton()
          ],
        ]
            /*[
            if (!game.characterInPlay.currentLocation!.isAllRedeemed)
              Expanded(
                child: ElevatedButton(
                    onPressed: () {},
                    child: Image.asset("assets/button/redeem.png")),
              )
            else if (game.characterInPlay.currentLocation!.type ==
                LocationType.church)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Hero
                  tag: "rim",
                  child: FilledButton.tonal(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/button/new_rim.png"),
                    ),
                  ),
                ),
              ),
            if (game.characterInPlay.currentLocation!.type !=
                LocationType.church)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Hero(
                  tag: "upgrade",
                  child: FilledButton(
                    onPressed: () => Navigator.push(
                      context,
                      ActionRoute(
                        builder: (context) => UpgradeLocationDialog(context),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(game
                                  .characterInPlay.currentLocation!.type ==
                              LocationType.outpost
                          ? "assets/button/outpost/${game.teamInPlay.id}.png"
                          : "assets/button/community/${game.teamInPlay.id}.png"),
                    ),
                  ),
                ),
              ),
          ],*/
            ),
      );
    });
  }
}
