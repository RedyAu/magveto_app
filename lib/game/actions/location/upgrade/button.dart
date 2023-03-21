import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../logic/index.dart';
import '../../../action_dialog.dart';
import 'dialog.dart';

class UpgradeLocationButton extends StatelessWidget {
  const UpgradeLocationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "upgrade",
      child: Consumer<GameProvider>(builder: (context, game, child) {
        return FilledButton.icon(
          onPressed: () => Navigator.push(
            context,
            ActionRoute(
              builder: (context) => UpgradeLocationDialog(context),
            ),
          ),
          label: Text(
              game.characterInPlay.currentLocation!.type == LocationType.outpost
                  ? "Gyülekezetplántálás"
                  : "Templomépítés"),
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(game.characterInPlay.currentLocation!.type ==
                    LocationType.outpost
                ? "assets/button/outpost/${game.teamInPlay.id}.png"
                : "assets/button/community/${game.teamInPlay.id}.png"),
          ),
        );
      }),
    );
  }
}
