import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../logic/index.dart';
import '../../../action_dialog.dart';
import 'dialog.dart';

class RedeemButtons extends StatelessWidget {
  const RedeemButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        return Row(
          children: [
            if (!game.locationInPlay.tiles
                .firstWhere((element) => element.type == GroundTileType.path)
                .isRedeemed)
              Expanded(child: redeemButton(GroundTileType.path, context)),
            if (!game.locationInPlay.tiles
                .firstWhere((element) => element.type == GroundTileType.rocky)
                .isRedeemed)
              Expanded(child: redeemButton(GroundTileType.rocky, context)),
            if (!game.locationInPlay.tiles
                .firstWhere((element) => element.type == GroundTileType.thorny)
                .isRedeemed)
              Expanded(child: redeemButton(GroundTileType.thorny, context)),
          ],
        );
      },
    );
  }

  Widget redeemButton(GroundTileType type, BuildContext context) {
    return Hero(
      tag: "redeem_${type.name}",
      child: FilledButton.tonal(
        onPressed: () => Navigator.push(
          context,
          ActionRoute(
            builder: (context) => RedeemDialog(type),
          ),
        ),
        child: Image.asset(
          "assets/button/redeem_${type.name}.png",
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}
