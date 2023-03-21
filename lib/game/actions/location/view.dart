import 'package:flutter/material.dart';
import 'package:magveto_app/game/actions/location/new/button.dart';
import 'package:provider/provider.dart';

import '../../../logic/index.dart';
import 'redeem/button.dart';
import 'rim/button.dart';
import 'service/button.dart';
import 'upgrade/button.dart';

class LocationActionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      return Container(
        padding: const EdgeInsets.all(8),
        height: 90,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (game.locationInPlay.type == LocationType.outpost)
              if (!game.locationInPlay.isAllRedeemed)
                Expanded(child: RedeemButtons())
              else
                Expanded(child: UpgradeLocationButton())
            else if (game.locationInPlay.type == LocationType.community) ...[
              if (!game.locationInPlay.isServicesReady)
                Expanded(child: StartServiceButton())
              else
                Expanded(child: UpgradeLocationButton()),
              RimButton()
            ] else if (game.locationInPlay.type == LocationType.church) ...[
              Expanded(child: NewLocationButton(game.teamInPlay.id)),
              // TODO Possibility to relocate character to already existing location?
              RimButton(),
            ],
          ],
        ),
      );
    });
  }
}
