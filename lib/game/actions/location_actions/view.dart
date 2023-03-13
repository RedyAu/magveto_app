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
      return Container(
        padding: const EdgeInsets.all(8.0),
        height: 90,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (game.locationInPlay.type == LocationType.outpost)
              if (!game.locationInPlay.isAllRedeemed) ...[
                Expanded(child: RedeemButtons())
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
          ],
        ),
      );
    });
  }
}
